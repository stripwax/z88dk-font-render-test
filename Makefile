SOURCES := $(wildcard *.c *.asm)
OBJECTS = $(SOURCES:.c=.o)

JUST_PRINT := $(findstring n,$(MAKEFLAGS))
ifneq (,$(JUST_PRINT))
CC = gcc -D__z88dk_callee=""
else
CC = zcc
CFLAGS = +zx
EXAMPLE_FLAGS = -m -lndos -create-app
endif

all: font_4x8_even.bin font_4x8_odd.bin example__.bin example.tap

font_4x8_even.bin font_4x8_odd.bin:
	python3 generate.py

example__.bin: $(OBJECTS)
	$(CC) $(CFLAGS) $(EXAMPLE_FLAGS) -o example $(OBJECTS) -subtype=bin

example.tap: $(OBJECTS)
	$(CC) $(CFLAGS) $(EXAMPLE_FLAGS) -o example $(OBJECTS)

test: all
	@z88dk-ticks -l 0x8000 -pc 0x8000 example__.bin

clean:
	@rm -rf *.o
	@rm -rf *.map
	@rm -rf *.bin
	@rm -rf *.tap
	@rm -rf *.sym
	@rm -rf example

.PHONY: clean

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.asm
	$(CC) $(ASMFLAGS) -c -o $@ $<
