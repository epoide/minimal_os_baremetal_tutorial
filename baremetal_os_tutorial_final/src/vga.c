#include <stdint.h>
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

// VGA memory starts at 0xB8000 in Protected Mode.
// Each character is 2 bytes: [Character][Color/Attribute]
static uint16_t* const vga_buffer = (uint16_t*)0xB8000;
static int cursor_pos = 0;

void vga_putc(char c) {
    if (c == '\n') {
        // Move cursor to the start of the next line
        cursor_pos += VGA_WIDTH - (cursor_pos % VGA_WIDTH);
    } else {
        // Write char with color 0x0F (White on Black)
        vga_buffer[cursor_pos++] = (uint16_t)c | (uint16_t)0x0F << 8;
    }
}

void vga_write(const char* s) {
    while(*s) vga_putc(*s++);
}

void vga_clear() {
    for(int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = (uint16_t)' ' | (uint16_t)0x0F << 8;
    }
    cursor_pos = 0;
}
