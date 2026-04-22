# 🛠️ Bare Metal OS: From MBR to Shell (Tutorial Edition)

Welcome to the **MinimalOS Tutorial**. This project is a deep dive into the "First Seconds" of a computer's life. We are bypassing modern luxuries like GRUB, UEFI, and Linux to build a 32-bit Operating System from absolute scratch.

## 📖 What is happening here?

This project demonstrates the **Classic x86 Boot Sequence**. It is divided into three distinct logical layers that transition the computer from a "calculator" state to a "functional" state.

### 1. The Stage 1 Bootloader (MBR)
The computer starts in **16-bit Real Mode**. The BIOS finds our code in the first 512 bytes of the disk (the Master Boot Record). Our MBR handles the "heavy lifting":
* **Memory Placement**: BIOS loads the MBR at `0x7C00`.
* **Disk I/O**: The MBR uses BIOS Interrupt `0x13` to read the rest of our OS from the disk into RAM at address `0x1000`.
* **GDT Setup**: It defines the **Global Descriptor Table**, which tells the CPU how to handle memory segments.
* **Architecture Switch**: It flips the CPU into **32-bit Protected Mode**, allowing us to use modern C code and access 4GB of RAM.

[Image of x86 boot sequence from BIOS to MBR to Kernel]

### 2. The Kernel (Ring 0)
Once the CPU is in 32-bit mode, it jumps to our C code at `0x1000`. The kernel takes control of the hardware:
* **VGA Driver**: Writes directly to the video memory at `0xB8000` to show text.
* **Keyboard Driver**: Communicates with the I/O Controller via ports `0x60` and `0x64` to "poll" for keypresses.
* **Virtual File System**: A small "Ramdisk" structure that simulates files stored in memory.

### 3. The User Space Shell
A simple interactive loop that reads keyboard input, compares strings (like `ls`), and provides feedback to the user.

---

## 📖 Project Anatomy
Before you build, here is a map of the source files and their responsibilities:

| File | Language | Purpose |
| :--- | :--- | :--- |
| **mbr.s** | Assembly | The entry point. Loads the kernel from disk and switches the CPU to 32-bit mode. |
| **gdt_mbr.s** | Assembly | Defines the Global Descriptor Table (GDT) needed to enable Protected Mode. |
| **kernel.c** | C | The kernel entry point. Orchestrates the transition from boot to the shell. |
| **vga.c** | C | Hardware driver for the video card. Handles printing text to the screen. |
| **keyboard.c** | C | Hardware driver for the keyboard. Polls hardware ports for keypresses. |
| **fs.c** | C | A minimal "Ramdisk" simulating a file system in memory. |
| **shell.c** | C | The user interface logic. Handles command parsing and interaction. |
| **io.h** | C/Asm | Low-level helpers to communicate with hardware ports (IN/OUT instructions). |
| **linker.ld** | Script | Tells the compiler exactly where in RAM the code must live (0x1000). |
| **Makefile** | Script | Automates the complex build process for macOS cross-compilation. |

---

## 🌲 Execution Flow Tree
The following tree shows how execution flows through the source files, starting from the moment the power button is pressed.



```text
BIOS (Hardware ROM)
 └──> mbr.s [Real Mode 16-bit]
       ├──> (Initializes Stack)
       ├──> load_kernel (Reads kernel.bin from disk via BIOS Int 0x13)
       ├──> switch_to_pm (Loads gdt_mbr.s)
       └──> jmp 0x08:init_pm [Protected Mode 32-bit]
             └──> kernel.c (kernel_main)
                   ├──> vga.c (vga_clear / vga_write)
                   └──> shell.c (run_shell)
                         ├──> keyboard.c (get_key / polling)
                         └──> fs.c (fs_ls if "ls" is typed)
```

## 💻 Compatibility Note

**This project is specifically configured for macOS (Apple Silicon: M1, M2, M3).** Because your Mac's CPU uses the ARM architecture, you cannot use the default Mac compiler (`gcc` or `clang`) to build this OS. Instead, we use a **Cross-Compiler** (`x86_64-elf-gcc`) to create Intel-compatible instructions while working on an Apple-compatible machine.

---

## 🚀 How to Compile and Run

### 1. Prerequisites
You must have the cross-compilation toolchain and emulator installed. Open your terminal and run:

```bash
brew install x86_64-elf-gcc x86_64-elf-binutils nasm qemu
```

### 2. Compile and run
make
qemu-system-i386 -drive format=raw,file=os-image.bin
