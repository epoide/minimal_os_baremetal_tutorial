OUTPUT_FORMAT(binary) /* Output raw bytes, no headers */
SECTIONS {
    . = 0x1000;        /* The kernel binary expects to be loaded at 0x1000 */
    .text : { *(.text) }
    .data : { *(.data) }
    .bss  : { *(.bss) }
}
