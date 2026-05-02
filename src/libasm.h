#ifndef LIBASM_H
#define LIBASM_H

typedef unsigned long size_t;

long write(unsigned int fd, const char *buf, const size_t count);
[[noreturn]] void exit(int status);

#endif
