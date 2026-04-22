[org 0x7c00]          ; BIOS loads the first sector of the disk to this address
KERNEL_OFFSET equ 0x1000 ; We decide to load our kernel at this address in RAM

    ; The BIOS passes the boot drive ID in the DL register. We save it.
    mov [BOOT_DRIVE], dl

    ; Set up the 16-bit stack (growing downwards from 0x9000)
    mov bp, 0x9000
    mov sp, bp

    call load_kernel        ; Use BIOS interrupts to read the rest of the disk
    call switch_to_pm       ; Flip the switch into 32-bit Protected Mode
    jmp $                   ; Infinite loop if the kernel ever returns

%include "src/gdt_mbr.s"    ; Include the Global Descriptor Table definition

[bits 16]
load_kernel:
    mov bx, KERNEL_OFFSET   ; Load destination = 0x1000
    mov dh, 40              ; Number of sectors to read (20KB of code)
    mov dl, [BOOT_DRIVE]    ; The drive ID saved earlier
    mov ah, 0x02            ; BIOS function 'Read Sectors'
    mov al, dh              ; AL = how many sectors to read
    mov ch, 0x00            ; Cylinder 0
    mov dh, 0x00            ; Head 0
    mov cl, 0x02            ; Sector 2 (Sector 1 is this MBR itself)
    int 0x13                ; Call BIOS interrupt
    ret

[bits 16]
switch_to_pm:
    cli                     ; 1. Disable all interrupts (dangerous during switch)
    lgdt [gdt_descriptor]    ; 2. Point CPU to our memory segment definitions
    mov eax, cr0            ; 3. Get Control Register 0
    or eax, 0x1             ; 4. Set the 'Protected Mode Enable' bit
    mov cr0, eax            ; 5. Update Control Register 0
    jmp 0x08:init_pm        ; 6. Perform a 'Far Jump' to flush 16-bit instructions

[bits 32]
init_pm:
    ; Now in 32-bit mode, update all segment registers to use our Data Segment (0x10)
    mov ax, 0x10            
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Update stack for 32-bit (now in a much larger memory range)
    mov ebp, 0x90000
    mov esp, ebp

    call KERNEL_OFFSET      ; JUMP TO THE C KERNEL ENTRY POINT!
    jmp $

BOOT_DRIVE db 0             ; Variable to store drive ID
times 510-($-$$) db 0       ; Pad file with zeros until byte 510
dw 0xaa55                   ; Bytes 511-512: The 'Bootable' signature for BIOS
