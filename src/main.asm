default rel

SECTION .rodata align=1 noexec

STDOUT               equ 1
SYS_WRITE            equ 1
SYS_EXIT             equ 60

COUNT_FROM           equ 1
COUNT_TO             equ 100
FIZZ_COUNTER         equ 3
BUZZ_COUNTER         equ 5
DIVISOR_10           equ 10

NULL                 equ 0
ASCII_ZERO           equ '0'
ASCII_ZERO_PAIR      equ '00'
NEWLINE              equ `\n`

ONE_DIGIT_PTR_OFFSET equ 1

FIZZ                 db 'Fizz', NEWLINE
BUZZ                 db 'Buzz', NEWLINE
FIZZBUZZ             db 'FizzBuzz', NEWLINE
DEFAULT_BUFFER       db NULL, NULL, NEWLINE

FIZZ_LEN             equ 5
BUZZ_LEN             equ 5
FIZZBUZZ_LEN         equ 9
TWO_DIGIT_LEN        equ $-DEFAULT_BUFFER
ONE_DIGIT_LEN        equ TWO_DIGIT_LEN - ONE_DIGIT_PTR_OFFSET

SECTION .text align=1 exec

global _start

_start:
        mov     r8b, COUNT_FROM
        mov     r9b, FIZZ_COUNTER
        mov     r10b, BUZZ_COUNTER
        mov     edi, STDOUT
loop_start:
        mov     edx, FIZZ_LEN
        dec     r9b
        jnz     not_fizz
        mov     r9b, FIZZ_COUNTER
        lea     rsi, [FIZZ]
        dec     r10b
        jnz     write
        mov     r10b, BUZZ_COUNTER
        lea     rsi, [FIZZBUZZ]
        mov     edx, FIZZBUZZ_LEN
        jmp     write

not_fizz:
        dec     r10b
        jnz     number
        mov     r10b, BUZZ_COUNTER
        lea     rsi, [BUZZ]
        jmp     write

number:
        movzx   eax, r8b
        mov     dl, DIVISOR_10
        div     dl
        add     ax, ASCII_ZERO_PAIR
        cmp     al, ASCII_ZERO
        jne     two_digits
        mov     byte [DEFAULT_BUFFER+ONE_DIGIT_PTR_OFFSET], ah
        lea     rsi, [DEFAULT_BUFFER+ONE_DIGIT_PTR_OFFSET]
        mov     edx, ONE_DIGIT_LEN
        jmp     write

two_digits:
        mov     [DEFAULT_BUFFER], ax
        lea     rsi, [DEFAULT_BUFFER]
        mov     edx, TWO_DIGIT_LEN
write:
        mov     eax, SYS_WRITE
        syscall
        inc     r8d
        cmp     r8b, COUNT_TO
        jle     loop_start
        mov     eax, SYS_EXIT
        xor     edi, edi
        syscall
