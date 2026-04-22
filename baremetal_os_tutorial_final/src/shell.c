extern void vga_write(const char*);
extern void vga_putc(char);
extern char get_key();
extern void fs_ls();

// Helper to compare strings for command parsing
int str_eq(const char* a, const char* b) {
    while(*a && *b && *a == *b) { a++; b++; }
    return *a == *b;
}

void run_shell() {
    char command_buffer[64]; 
    int buffer_idx = 0;
    
    vga_write("\nuser@minimalOS$ ");
    
    while(1) {
        char c = get_key(); // Poll for input
        
        if (c == '\n') {   // User pressed Enter
            command_buffer[buffer_idx] = 0; // Null terminate string
            
            if (str_eq(command_buffer, "ls")) {
                fs_ls();
            } else if (buffer_idx > 0) {
                vga_write("\nCommand not found.");
            }
            
            vga_write("\nuser@minimalOS$ ");
            buffer_idx = 0; // Clear buffer for next command
        } 
        else if (c > 0 && buffer_idx < 63) {
            command_buffer[buffer_idx++] = c; 
            vga_putc(c); // Echo character to the screen
        }
    }
}
