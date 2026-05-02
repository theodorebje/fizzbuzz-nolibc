.DEFAULT_GOAL := all

target := fizzbuzz

src_dir := src
bin_dir := bin

# Collect all source files
c_sources := $(shell find $(src_dir) -type f -name '*.c')
asm_sources := $(shell find $(src_dir) -type f -name '*.S')
sources := $(c_sources) $(asm_sources)
depfiles := $(foreach src,$(sources),$(bin_dir)/$(basename $(notdir $(src))).d)
objects := $(foreach src,$(sources),$(bin_dir)/$(basename $(notdir $(src))).o)
bin := $(bin_dir)/$(target)

cc := gcc
strip := strip
gdb := gdb
objdump := objdump

# Flags for freestanding, no libc, static linking
warnings := -Wall -Wextra -Wpedantic -Werror=implicit-function-declaration -Werror=implicit-int -Wshadow -Wmissing-prototypes -Wstrict-prototypes -Wundef -Wunused-macros -Wcast-align -Wconversion -Wno-sign-conversion -Wnull-dereference -Wtrampolines -Wmissing-declarations -Wredundant-decls -Wwrite-strings -Wunused-parameter -Wbad-function-cast -Wno-analyzer-fd-leak
cflags := -ffreestanding -nostdlib -static -fanalyzer -g -Os -std=c23 -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-fat-lto-objects -fno-stack-protector -I$(src_dir) -I$(src_dir)/libasm $(warnings) 
ldflags := -nostdlib -static -Wl,-z,max-page-size=0x1000,--build-id=none,--gc-sections,-e,_start -flto

# Create binary directory
mkdir:
	mkdir -p $(bin_dir)

# Compile all source files into .o files
build: mkdir
	@set -e; for src in $(sources); do \
		base="$$(basename "$$src")"; \
		base="$${base%.*}"; \
		obj="$(bin_dir)/$$base.o"; \
		dep="$(bin_dir)/$$base.d"; \
		echo "CC $$src -> $$obj"; \
		$(cc) -c $(cflags) -MMD -MF $$dep $$src -o $$obj; \
	done

# Include dependency files if they exist
-include $(depfiles)

# Link all .o files into executable
link: build
	@echo "Linking $(objects) -> $(bin)"
	$(cc) $(objects) -o $(bin) $(ldflags)

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

strace: all
	strace $(bin) $(ARGS)
