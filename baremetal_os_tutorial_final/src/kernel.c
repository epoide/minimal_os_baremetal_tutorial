extern void vga_clear();
extern void vga_write(const char*);
extern void run_shell();

// This is the first function called after the MBR switch
void kernel_main() {
    vga_clear();
    vga_write("BARE METAL KERNEL V1.0\n");
    vga_write("System initialized successfully.\n");
    
    run_shell(); // Start the shell infinite loop
}
