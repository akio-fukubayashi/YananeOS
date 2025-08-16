; YananeOS Boot

; Start Address(BIOS)
[org 0x7c00]

init:
    ; Init Register
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Init Stack
    mov sp, 0x7E00

load_kernel:
    ; CHS mode (Future versions will support LBA)
    mov ah, 0x02            ; read sectors mode
    mov al, 1               ; Sector Count

    ; Drive Settings(1 sector = 512 bytes)
    mov ch, 0               ; Cylinder Number
    mov cl, 2               ; Sector Number (Sectors from 2 onwards in the kernel)
    mov dh, 0               ; Head Number
    ;mov dl, [boot_drive]    ; Drive Number (Set by BIOS)
    mov dl, 0x80

    ; Load Memory ES:BX = 0x10000
    mov bx, 0x1000
    mov es, bx
    xor bx, bx
    int 0x13

    ; Read Failed (CF=0)
    jc hang

switch_protect_mode:
    ; Not Intterupt
    cli

    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 1          ; Set PE bit
    mov cr0, eax

    jmp 0x08:protect_mode_entry ; far jump CS=0x08

[BITS 32]
protect_mode_entry:
    ; Set Segment (Use Data segment)
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set Stack
    mov esp, 0x9FC00

    ; Call Kernel
    jmp 0x10000

hang:
    hlt
    jmp hang

; GDT (Flat Model)
align 8
gdt_start:
    dq 0x0000000000000000    ; Null descriptor
    dq 0x00CF9A000000FFFF    ; Code Segment (0x08)
    dq 0x00CF92000000FFFF    ; Data Segment (0x10)
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1   ; GDT Size -1
    dd gdt_start                 ; GDT Address

; Fill 512 bytes
times 510-($-$$) db 0

; 2 bytes 0xAA55
db 0x55
db 0xAA
    