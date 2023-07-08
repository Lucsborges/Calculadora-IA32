OUTPUT = CALCULADORA

SOURCES = $(wildcard *.asm)

OBJS = $(SOURCES:.asm=.o)

#Compilador
AS = nasm
ASFLAGS = -f elf32

#Linker
LD = ld
LDFLAGS = -m elf_i386

all: $(OUTPUT)

$(OUTPUT): $(OBJS)
	$(LD) $(LDFLAGS) -o $(OUTPUT) $(OBJS)

%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OUTPUT) $(OBJS)
