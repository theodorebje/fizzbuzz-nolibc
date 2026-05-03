ENTRY(_start)

PHDRS
{
    tiny PT_LOAD FILEHDR PHDRS FLAGS(5);
}

SECTIONS
{
    . = 0x400000 + SIZEOF_HEADERS;

    .text : {
        *(.text)
        *(.rodata)
    } :tiny

    /DISCARD/ : {
        *(.*)
    }
}
