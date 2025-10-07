bootloader implements the first stage of an x86 OS startup.
It initializes the stack, reads multiple sectors from disk into memory at 0x1000 using BIOS interrupt 13h, sets up a Global Descriptor Table (GDT) to define code and data segments, switches the CPU into 32-bit Protected Mode by setting the PE flag in CR0, and finally jumps to the kernel entry point.
