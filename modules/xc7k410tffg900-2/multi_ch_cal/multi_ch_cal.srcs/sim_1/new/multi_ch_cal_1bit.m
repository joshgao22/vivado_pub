%% File Header/文件说明
%
% 调零算法对幅相一致性的要求较高，且 AD9361 多片同步的精度随机性较大，因此需要对
% AD9361 多片同步误差进行精细校准。采用收发扩频码的方式在校准过程中对两片 AD9361
% 的两个接收通道进行幅相测量，在接收端使用加法器进行非相干相关峰累积，累积 N 个
% 符号后出峰，根据相关峰的高度差和相位差，在接收端对信号的幅度和相位进行补偿。
%
clc; clear; close all;
%% initial system parameters/初始系统参数
rng(0);
Eb_N0 = 30; % energy per bit to noise power spectral density ratio
interp = 8; % interpolation factor
SNR = 10*log10(2/interp) + Eb_N0; % signal-to-noise power ration
channelNum = 2;
deltaAmp = 1-(2*rand-1)*0.05;     % random amplitude error, range: [0.95,1.05]
deltaAngRad = (2*rand-1)*pi;      % random phase error, range: [-pi,pi]
deltaAngDeg = deltaAngRad/pi*180;
angleInit = 20/pi*180;

% standard pn sequence
pnSequence = comm.PNSequence('Polynomial','x^7+x^6+1', ...
  'InitialConditions',[zeros(1,6),1],'SamplesPerFrame',2^7-1);
PRBS7 = pnSequence();
PRBS7_polar = 1-2*[PRBS7;0];

chipLen = length(PRBS7_polar);      % pn chip length
accumSymbolNum = 16;
totalSymbolNum = accumSymbolNum+1;

randomChipIndex_ch1 = randi(chipLen*interp*2-1)-chipLen*interp;   % random rx chip index
randomChipIndex_ch2 = randomChipIndex_ch1 + (randi(2*interp-1)-interp);   % random rx chip index
% randomChipIndex_ch1 = -2;   % random rx chip index
% randomChipIndex_ch2 = 5;   % random rx chip index

%%
% 发送信号：方波成型
seqTx = kron(repmat(PRBS7_polar,totalSymbolNum,1),ones(interp,1));

% 接收信号：随机初始相位，加噪，随机幅度误差，随机相位误差
seqRx = awgn(seqTx,SNR,'measured').*[1,deltaAmp].*[exp(1i*angleInit),...
  exp(1i*(angleInit+deltaAngRad))];
seqRx(:,1) = circshift(seqRx(:,1),randomChipIndex_ch1);
seqRx(:,2) = circshift(seqRx(:,2),randomChipIndex_ch2);

% 降采样，与 Verilog 实现一样在码片中心采样
seqRxDown = zeros(chipLen*accumSymbolNum,channelNum,interp);

for i = 0:interp-1
  % 补偿 Verilog 模块的读数延迟
  seqRxDown(:,:,i+1) = downsample(seqRx((1:accumSymbolNum*chipLen*interp)+2,:),interp,i);
end

% 取符号位
seqRxMsbReal = zeros(size(seqRxDown));
seqRxMsbImag = zeros(size(seqRxDown));
seqRxMsbReal(real(seqRxDown)>0) = 1;
seqRxMsbReal(real(seqRxDown)<0) = -1;
seqRxMsbImag(imag(seqRxDown)>0) = 1;
seqRxMsbImag(imag(seqRxDown)<0) = -1;

% 符号位累积
seqRxMsbRealAccum = zeros(chipLen,channelNum,interp);
seqRxMsbImagAccum = zeros(chipLen,channelNum,interp);

for i = 0:chipLen-1
  % PN 码圆周移位，遍历所有 PN 码相位
  PRBS7_cshift = circshift(repmat(PRBS7_polar,accumSymbolNum,1),-i); % 负号为了和 Verilog 程序对应
  % 累积，若当前比特与 PN 码相同，结果 +1；否则结果 -1
  seqRxMsbRealAccum(i+1,:,:) = sum(PRBS7_cshift==seqRxMsbReal)-...
    sum(PRBS7_cshift~=seqRxMsbReal);
  seqRxMsbImagAccum(i+1,:,:) = sum(PRBS7_cshift==seqRxMsbImag)-...
    sum(PRBS7_cshift~=seqRxMsbImag);
end

seqRxMsbAccum = seqRxMsbRealAccum+1i*seqRxMsbImagAccum;

% 通过相关峰位置判断目标信号位置
maxPeakIndex = zeros(2,interp);

for i = 1:2
  for j = 1:interp
    maxPeakIndex(i,j) = find(abs(seqRxMsbAccum(:,i,j))==max(abs(seqRxMsbAccum(:,i,j))),1); % PN 码相位
  end
end

maxPeakIndexDiff = zeros(channelNum,1); % 相位差

for i = 1:channelNum
  for j = 1:interp
    if (maxPeakIndex(i,j)==maxPeakIndex(i,1))
      maxPeakIndexDiff(i) = j;
    end
  end
end

% 以下条件仅对双通道有效
if (maxPeakIndex(1,1) == maxPeakIndex(2,1))
  relativeDelay = maxPeakIndexDiff(2) - maxPeakIndexDiff(1);
  desiredPointIndex = [1,1]+[0,chipLen];
elseif (mod(maxPeakIndex(1,1)-1,chipLen) == mod(maxPeakIndex(2,1),chipLen))
  relativeDelay = maxPeakIndexDiff(2) - maxPeakIndexDiff(1) + interp;
  desiredPointIndex = [1,2]+[0,chipLen];
elseif (mod(maxPeakIndex(1,1)+1,chipLen) == mod(maxPeakIndex(2,1),chipLen))
  relativeDelay = maxPeakIndexDiff(2) - maxPeakIndexDiff(1) - interp;
  desiredPointIndex = [2,1]+[0,chipLen];
end

% 输入信号累加
seqRxDownAccum = squeeze(sum(reshape(seqRxDown(:,:,1),128,[],2),2));
% 取目标位置信号
desiredPoint = seqRxDownAccum(desiredPointIndex);

ampEst = abs(desiredPoint)./abs(desiredPoint(1));
angleEst = (angle(desiredPoint) - angle(desiredPoint(1)))/pi*180;

seqRxExport = round([real(seqRx(:,1)),imag(seqRx(:,1)),real(seqRx(:,2)),...
  imag(seqRx(:,2))]/max(abs(seqRx),[],'all')*(2^11-1));
writematrix(seqRxExport,'./fine_cal_data.txt');
