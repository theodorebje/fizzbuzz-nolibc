#define SYS_WRITE 1
#define SYS_EXIT 60

typedef unsigned long size_t;

long write(unsigned int fd, const char *buf, size_t count);
long write(unsigned int fd, const char *buf, size_t count) {
    long ret;
    __asm__ volatile("syscall"
                     : "=a"(ret)              // return value comes from rax
                     : "a"(SYS_WRITE),        // rax = syscall number
                       "D"(fd),               // rdi = fd
                       "S"(buf),              // rsi = buf
                       "d"(count)             // rdx = count
                     : "memory", "rcx", "r11" // syscall clobbers rcx and r11
    );
    return ret;
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
        if (!either) {
            char buf[3];
            char len;
            if (i >= 100) {
                buf[0] = '0' + (i / 100);
                buf[1] = '0' + ((i / 10) % 10);
                buf[2] = '0' + (i % 10);
                len = 3;
            } else if (i >= 10) {
                buf[0] = '0' + (i / 10);
                buf[1] = '0' + (i % 10);
                len = 2;
            } else {
                buf[0] = '0' + i;
                len = 1;
            }
            write(1, buf, len);
        }
        write(1, "\n", 1);
    }

    __asm__ volatile("syscall"
                     :
                     : "a"(SYS_EXIT), "D"(0)
                     : "memory", "rcx", "r11");
    __builtin_unreachable();
}
