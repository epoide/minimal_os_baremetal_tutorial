align 8               ; The CPU likes the GDT aligned on 8-byte boundaries
gdt_start:
    dq 0x0                ; Null Descriptor (8 bytes of 0s): Required by x86

gdt_code:                 ; Code Segment Descriptor (Offset 0x08)
    dw 0xffff             ; Limit: 4GB (0-15 bits)
    dw 0x0                ; Base: 0x0 (0-15 bits)
    db 0x0                ; Base: 0x0 (16-23 bits)
    db 10011010b          ; Access: Present(1), Ring0(00), Code(1), Conforming(0), Readable(1)
    db 11001111b          ; Flags: 4KB Granularity(1), 32-bit(1), Limit(16-19 bits)
    db 0x0                ; Base: 0x0 (24-31 bits)

gdt_data:                 ; Data Segment Descriptor (Offset 0x10)
    dw 0xffff             ; Limit: 4GB
    dw 0x0                ; Base: 0x0
    db 0x0                ; Base: 0x0
    db 10010010b          ; Access: Present(1), Ring0(00), Data(1), Writable(1)
    db 11001111b          ; Flags: same as code
    db 0x0                ; Base: 0x0

gdt_end:

gdt_descriptor:           ; The structure passed to the LGDT instruction
    dw gdt_end - gdt_start - 1 ; Size of GDT (minus 1 byte)
    dd gdt_start               ; Physical address of start of GDT
