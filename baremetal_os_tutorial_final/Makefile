CC = x86_64-elf-gcc
LD = x86_64-elf-ld
AS = nasm
CFLAGS = -m32 -ffreestanding -O2 -Wall -fno-pie
LDFLAGS = -m elf_i386 -T src/linker.ld

OBJ = src/kernel.o src/vga.o src/keyboard.o src/fs.o src/shell.o

all: os-image.bin

# 1. Assemble MBR as a raw 512-byte binary
mbr.bin: src/mbr.s src/gdt_mbr.s
	$(AS) -f bin src/mbr.s -o mbr.bin

# 2. Compile C files into 32-bit object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# 3. Link C objects into a raw kernel binary
kernel.bin: $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o kernel.bin

# 4. Concatenate MBR + Kernel and pad to standard disk size
os-image.bin: mbr.bin kernel.bin
	cat mbr.bin kernel.bin > os-image.bin
	truncate -s 1440k os-image.bin

clean:
	rm -rf src/*.o *.bin os-image.bin
