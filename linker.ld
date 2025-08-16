SECTIONS {
    . = 0x10000;

    /* Boot Entry */
    .text.entry :
    {
        *(.text.entry)
    }

    /* Global Constructor */
    .init_array :
    {
        __init_array_start = .;
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array))
        __init_array_end = .;
    }

    /* Kernel */
    .text :
    {
        *(.text*)
    }

    .data :
    {
        *(.data*)
    }

    .bss :
    {
        __bss_start = .;
        *(.bss*)
        __bss_end = .;
    }
}