default rel

SECTION .rodata align=1 noexec

STDOUT               equ 1
SYS_WRITE            equ 1
SYS_EXIT             equ 60

COUNT_FROM           equ 1
COUNT_TO             equ 100
FIZZ_COUNTER         equ 3
BUZZ_COUNTER         equ 5

NULL                 equ 0
ASCII_ZERO           equ '0'
ASCII_ZERO_PAIR      equ '00'
NEWLINE              equ `\n`

BITS_PER_BYTE        equ 8

DIVISOR              db 10
FIZZ                 db 'Fizz', NEWLINE
BUZZ                 db 'Buzz', NEWLINE
FIZZBUZZ             db 'FizzBuzz', NEWLINE
DEFAULT_BUFFER       db NULL, NULL, NEWLINE

FIZZ_LEN             equ 5
BUZZ_LEN             equ 5
FIZZBUZZ_LEN         equ 9
TWO_DIGIT_LEN        equ $-DEFAULT_BUFFER
ONE_DIGIT_LEN        equ TWO_DIGIT_LEN - 1

SECTION .text align=1 exec

global _start

_start:
        mov     r8d, -COUNT_TO
        mov     bx, (BUZZ_COUNTER << BITS_PER_BYTE) | FIZZ_COUNTER
        mov     edi, STDOUT
loop_start:
        mov     edx, FIZZ_LEN
        dec     bl
        jnz     not_fizz
        mov     bl, FIZZ_COUNTER
        lea     rsi, [FIZZ]
        dec     bh
        jnz     write
        mov     bh, BUZZ_COUNTER
        lea     rsi, [FIZZBUZZ]
        mov     edx, FIZZBUZZ_LEN
        jmp     write

not_fizz:
        dec     bh
        jnz     number
        mov     bh, BUZZ_COUNTER
        lea     rsi, [BUZZ]
        jmp     write

number:
        lea     eax, [r8 + COUNT_TO + COUNT_FROM]
        div     byte [DIVISOR]
        add     ax, ASCII_ZERO_PAIR
        mov     [DEFAULT_BUFFER], ax
        lea     rsi, [DEFAULT_BUFFER]
        mov     edx, TWO_DIGIT_LEN
        cmp     al, ASCII_ZERO
        jne     write
        inc     rsi
        dec     edx
write:
        mov     eax, SYS_WRITE
        syscall
        inc     r8d
        jnz     loop_start
        mov     eax, SYS_EXIT
        xor     edi, edi
        syscall
