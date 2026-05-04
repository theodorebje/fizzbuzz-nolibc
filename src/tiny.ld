ENTRY(_start)

PHDRS
{
    tiny PT_LOAD FILEHDR PHDRS FLAGS(7);
}

SECTIONS
{
    . = 0x400000 + SIZEOF_HEADERS;

    .text : {
        *(.text)
        *(.rodata)
        *(.data)
    } :tiny

    /DISCARD/ : {
        *(.*)
    }
}
