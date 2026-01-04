MOJO         := pixi run mojo build
MOJO_TRIPLE  := i686-none-elf
MOJOFLAGS    := --emit object --target-triple=$(MOJO_TRIPLE) --target-cpu=i686

TARGET       := myos.bin

MOJO_SOURCES := $(shell find src -type f -name "*.mojo")
ASM_SOURCES  := $(shell find . -type f -name "*.s")

MOJO_OBJECTS := $(MOJO_SOURCES:.mojo=.o)
ASM_OBJECTS  := $(ASM_SOURCES:.s=.o)
OBJECTS      := $(MOJO_OBJECTS) $(ASM_OBJECTS)

LD           := i686-elf-ld
LDFLAGS      := -T linker.ld

AS           := i686-elf-as

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) $^ -o $@

%.o: %.mojo
	$(MOJO) $(MOJOFLAGS) $< -o $@

%.o: %.s
	$(AS) $< -o $@

run: $(TARGET)
	qemu-system-i386 -kernel $(TARGET) -serial stdio

clean:
	rm -f $(OBJECTS) $(TARGET)
	rm -f kgen.trace.json.time-events.txt kgen.trace.json.time-trace
