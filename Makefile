.DEFAULT_GOAL := all

target := fizzbuzz

src_dir := src
bin_dir := bin
base_name := main

bin := $(bin_dir)/$(target)

cc := gcc
strip := strip
gdb := gdb
objdump := objdump
python3 := python3

# Flags for freestanding, no libc, static linking
warnings := -Wall -Wextra -Wpedantic -Werror=implicit-function-declaration -Werror=implicit-int -Wshadow -Wmissing-prototypes -Wstrict-prototypes -Wundef -Wunused-macros -Wcast-align -Wconversion -Wno-sign-conversion -Wnull-dereference -Wtrampolines -Wmissing-declarations -Wredundant-decls -Wwrite-strings -Wunused-parameter -Wbad-function-cast -Wno-analyzer-fd-leak
cflags := -ffreestanding -fno-unroll-loops -ffunction-sections -nostdlib -static -fanalyzer -g -Os -std=c23 -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-fat-lto-objects -fno-stack-protector -I$(src_dir) -I$(src_dir)/libasm $(warnings) 
ldflags := -nostdlib -static -Wl,-z,max-page-size=0x1000,--build-id=none,--gc-sections,-e,_start -flto

# Create binary directory
mkdir:
	mkdir -p $(bin_dir)

# Compile all source files into .o files
build: mkdir
	$(cc) -c $(cflags) -MMD -MF $(bin_dir)/$(base_name).d $(src_dir)/$(base_name).c -o $(bin_dir)/$(base_name).o

# Link all .o files into executable
link: build
	$(cc) $(bin_dir)/$(base_name).o -o $(bin) $(ldflags)

strip: link
	$(strip) --strip-all --remove-section=.comment --remove-section=.note.gnu.property $(bin)

bloaty: strip
	bloaty $(bin)

# Build everything
all: link

run: all
	$(bin) $(ARGS)

# Remove generated files
clean:
	rm -rf $(bin_dir)

debug: all
	$(gdb) $(bin) $(COREFILE)

objdump: all
	$(objdump) -d -s -M intel $(bin)

instructions: all
	$(objdump) -d $(bin) | grep -E '^\s+[0-9a-f]+:' | wc -l

test: all
	$(python3) tests/output.py
	$(python3) tests/instructions.py

strace: all
	strace $(bin) $(ARGS)
