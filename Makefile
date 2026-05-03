.DEFAULT_GOAL := all

target := fizzbuzz

src_dir := src
bin_dir := bin
base_name := main

bin := $(bin_dir)/$(target)
min_bin := $(bin_dir)/$(target)_min
asm_src := $(src_dir)/$(base_name).asm
obj := $(bin_dir)/$(base_name).o
linker_script := $(src_dir)/tiny.ld

nasm := nasm
ld := ld
strip := strip
gdb := gdb
objdump := objdump
python3 := python3

asmflags := -f elf64
ldflags := -static -e _start -N
min_ldflags := -static -nostdlib -T $(linker_script) -z max-page-size=1 -z common-page-size=1 -z nosectionheader

# Create binary directory
mkdir:
	mkdir -p $(bin_dir)

# Assemble the NASM source into an object file
build: mkdir
	$(nasm) $(asmflags) $(asm_src) -o $(obj)

# Link the object file into a static executable
link: build
	$(ld) $(ldflags) $(obj) -o $(bin)

link_min: build
	$(ld) $(min_ldflags) $(obj) -o $(min_bin)

strip: link
	$(strip) --strip-all --remove-section=.comment --remove-section=.note.gnu.property $(bin)	

bloaty: strip
	bloaty $(bin)

bloaty_min: link_min
	bloaty $(min_bin)

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
