/**
 * @file utils.h
 */

#ifndef CX9261ADRIVER_UTILS_H
#define CX9261ADRIVER_UTILS_H
#include <algorithm>
#include <bitset>
#include <cmath>
#include <string>
namespace CX9261A {
#if __cplusplus >= 201703L
template <typename T>
constexpr const T& clamp(const T& v, const T& lo, const T& hi) {
    return std::clamp(v, lo, hi);
}
#else
template <typename T>
constexpr const T& clamp(const T& v, const T& lo, const T& hi) {
    return std::max(std::min(hi, v), lo);
}
#endif

template <typename Float>
int round(Float f) {
    return static_cast<int>(std::round(f));
}

template <typename Float>
long long round64(Float f) {
    return static_cast<long long>(std::round(f));
}

template <typename Float>
int floor(Float f) {
    return static_cast<int>(std::floor(f));
}

template <typename Float>
long long floor64(Float f) {
    return static_cast<long long>(std::floor(f));
}

template <typename Float>
int ceil(Float f) {
    return static_cast<int>(std::ceil(f));
}

template <typename Float>
long long ceil64(Float f) {
    return static_cast<long long>(std::ceil(f));
}
/**
* @brief Register类，提供方便的位操作函数
*/
class Register {
public:
    template <typename T = int>
    constexpr Register(const T value = 0) {
//        static_assert(std::is_integral_v<T>, "Register value must be integral!");
        m_value = static_cast<unsigned long long>(value);
    }
    /**
    * 以十进制返回寄存器值
    */
    unsigned char value() const { return static_cast<unsigned char>(m_value.to_ulong()); }
    /**
    * 对寄存器值进行部分值的替换操作
    * 例：replace(7, 4, 0b1111); 使寄存器的高四位为1
    * @param start 起始位
    * @param end 中止位
    * @param after 要替换的值
    */
    void replace(const unsigned int start, const unsigned int end, unsigned char after) {
        for (auto i = end; i <= start; ++i) {
            m_value[i] = (after >> (i - end)) & 0b1;
        }
    }

    auto operator[](const size_t position) { return m_value[position]; }

    template <typename Type>
    operator Type() const {
//        static_assert(std::is_integral_v<Type>, "Type must be an integral");
        return static_cast<Type>(m_value.to_ulong());
    }

private:
    std::bitset<8> m_value{};
};

template <int N>
std::string frac2bin(const double frac) {
    const long double num = frac * (pow(2.0, N));
    std::string ret = std::bitset<N>(std::floor(num)).to_string();
    return ret;
}
}  // namespace CX9261A
#endif  // CX9261ADRIVER_UTILS_H
