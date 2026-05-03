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

SECTION .data align=1 write

FIZZ_COUNT           db FIZZ_COUNTER
BUZZ_COUNT           db BUZZ_COUNTER

SECTION .text align=1 exec

global _start

_start:
        mov     r8w, -COUNT_TO
        mov     dil, STDOUT
loop_start:
        mov     dl, FIZZ_LEN
        dec     byte [FIZZ_COUNT]
        jnz     not_fizz
        mov     byte [FIZZ_COUNT], FIZZ_COUNTER
        lea     si, [FIZZ]
        dec     byte [BUZZ_COUNT]
        jnz     write
        mov     byte [BUZZ_COUNT], BUZZ_COUNTER
        lea     si, [FIZZBUZZ]
        mov     dl, FIZZBUZZ_LEN
        jmp     write

not_fizz:
        dec     byte [BUZZ_COUNT]
        jnz     number
        mov     byte [BUZZ_COUNT], BUZZ_COUNTER
        lea     si, [BUZZ]
        jmp     write

number:
        lea     ax, [r8d + COUNT_TO + COUNT_FROM]
        div     byte [DIVISOR]
        add     ax, ASCII_ZERO_PAIR
        mov     [DEFAULT_BUFFER], ax
        lea     esi, [DEFAULT_BUFFER]
        mov     dl, TWO_DIGIT_LEN
        cmp     al, ASCII_ZERO
        jne     write
        inc     sil
        dec     dl
write:
        mov     ax, SYS_WRITE
        syscall
        inc     r8b
        jnz     loop_start
        mov     ax, SYS_EXIT
        xor     dil, dil
        syscall
