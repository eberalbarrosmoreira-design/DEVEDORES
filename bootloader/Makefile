# Makefile do Bootloader
# Compila o bootloader com NASM

ASM      = nasm
ASMFLAGS = -f bin -I bootloader/
TARGET   = bootloader.bin

all: $(TARGET)

$(TARGET): boot.asm
	$(ASM) $(ASMFLAGS) boot.asm -o $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all clean
