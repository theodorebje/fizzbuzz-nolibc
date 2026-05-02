#include "libasm.h"

void print_number(char n);
void print_number(char n) {
    if (n >= 100) {
        char buf[3];
        buf[0] = '0' + (n / 100);
        buf[1] = '0' + ((n / 10) % 10);
        buf[2] = '0' + (n % 10);
        write(1, buf, 3);
    } else if (n >= 10) {
        char buf[2];
        buf[0] = '0' + (n / 10);
        buf[1] = '0' + (n % 10);
        write(1, buf, 2);
    } else {
        const char x = '0' + n;
        write(1, &x, 1);
    }
}

[[noreturn]] void _start();
[[noreturn]] void _start() {
    for (char i = 1; i <= 100; ++i) {
        bool either = false;
        if (i % 3 == 0) {
            either = true;
            write(1, "Fizz", 4);
        }
        if (i % 5 == 0) {
            either = true;
            write(1, "Buzz", 4);
        }
        if (!either)
            print_number(i);
        write(1, "\n", 1);
    }
    exit(0);
}
