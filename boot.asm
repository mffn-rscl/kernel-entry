[org	0x7c00]

KERNEL_LOCATION equ 0x1000

mov   [BOOT_DISK], dl

xor   ax, ax
mov   es, ax
mov   ds, ax
mov   bp, 0x8000
mov   sp, bp

mov   bx, KERNEL_LOCATION
mov   dh, 2


mov   ah, 0x02
mov   al, ah
mov   ch, 0x00
mov   dh, 0x00
mov   cl, 0x02
mov   dl, [BOOT_DISK]
int   0x13



mov   ah, 0x0
mov   al, 0x3
int   0x10


CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

cli
lgdt [GDT_descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax
jmp CODE_SEG:start_protected_mode

jmp $

BOOT_DISK: db 0

GDT_start:
    GDT_null:
      dd   0x0
      dd   0x0
    GDT_code:
      dw    0xffff   ; define first 24 bits
      dw    0x0      ; 16 bits +                 <base>
      db    0x0        ; 8 bits = 24 bits          <base>
      db    0b10011010 ;  prev, priv, type = 1001 AND type flags = 1010
      db    0b11001111 ; other flags  + <limit>(last four bits)
      db    0x0        ; last 8 bits of the base
    
    GDT_data:
      dw    0xffff ; define first 24 bits
      dw    0x0        ; 16 bits +                 <base>
      db    0x0        ; 8 bits = 24 bits          <base>
      db    0b10010010 ;  prev, priv, type = 1001 AND type flags = 0010
      db    0b11001111 ; other flags  + <limit>(last four bits)
      db    0x0        ; last 8 bits of the base


GDT_end:

GDT_descriptor:
    dw    GDT_end - GDT_start - 1 ; size
    dd GDT_start                  ;start


[BITS 32]
start_protected_mode:
    mov   ax, DATA_SEG
    mov   ds, ax
    mov   ss, ax
    mov   es, ax
    mov   fs, ax
    mov   gs, ax

    mov   ebp, 0x90000
    mov   esp, ebp

    jmp KERNEL_LOCATION ; jump to kernel


times 510 - ($-$$) db 0
dw 0xaa55

