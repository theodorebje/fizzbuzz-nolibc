#include "libasm.h"

[[noreturn]] void _start();

[[noreturn]] void _start() {
    write(1, "Hello, World!\n", 14);
    exit(0);
}
