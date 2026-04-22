#ifndef IO_H
#define IO_H
#include <stdint.h>
// Inline assembly to read a byte from a hardware port
static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    asm volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}
#endif
