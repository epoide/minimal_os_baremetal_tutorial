#include "io.h"

// Scancode to ASCII mapping table
char kbd_map[128] = { 
    0, 27, '1','2','3','4','5','6','7','8','9','0','-','=','\b',
    '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n',
    0,'a','s','d','f','g','h','j','k','l',';','\'', '`', 0, '\\', 
    'z','x','c','v','b','n','m',',','.','/', 0, '*', 0, ' ' 
};

char get_key() {
    // Port 0x64 is the Status Register. Bit 0 is 1 if data is waiting.
    if (inb(0x64) & 0x01) {
        // Port 0x60 is the Data Port. Contains the key scancode.
        uint8_t scancode = inb(0x60);
        // Bit 7 is set if the key was RELEASED. We only care about PRESSES.
        if (!(scancode & 0x80)) return kbd_map[scancode];
    }
    return 0; // Return null if no key is pressed
}
