# Makefile do Kernel
# Compila o kernel com cross-compiler i686-elf

CC       = i686-elf-gcc
CFLAGS   = -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g
ASM      = nasm
ASMFLAGS = -f elf32
LD       = i686-elf-ld
LDFLAGS  = -T kernel/kernel.ld -nostdlib

SRC_C    = kernel/kernel.c kernel/vga.c
OBJ_C    = $(SRC_C:.c=.o)
TARGET   = kernel.bin
ELF      = kernel.elf

all: $(TARGET)

# Compila arquivos C para objetos (cross-compiler freestanding)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Linka o kernel (ELF)
$(ELF): $(OBJ_C)
	$(LD) $(LDFLAGS) -o $@ $^

# Extrai o binário puro do kernel (flat binary)
$(TARGET): $(ELF)
	i686-elf-objcopy -O binary $< $@

clean:
	rm -f $(OBJ_C) $(ELF) $(TARGET)

.PHONY: all clean
