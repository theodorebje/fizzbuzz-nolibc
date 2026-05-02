#include "libasm.h"

#define SYS_WRITE 1
#define SYS_EXIT 60

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

[[noreturn]] void exit(int status) {
    __asm__ volatile("syscall"
                     :
                     : "a"(SYS_EXIT), "D"(status)
                     : "memory", "rcx", "r11");
    __builtin_unreachable();
}
