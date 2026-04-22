#include <stdint.h>
extern void vga_write(const char*);
typedef struct { char name[16]; char data[64]; } File;

File files[] = { {"readme.txt", ""}, {"todo.txt", ""} };

void fs_ls() {
    vga_write("\nFILESYSTEM CONTENTS:\n");
    for(int i = 0; i < 2; i++) {
        vga_write(" -> "); 
        vga_write(files[i].name); 
        vga_write("\n");
    }
}
