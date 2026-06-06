# ============================================================
# Makefile Principal — Microcoop OS
# ============================================================
# Gerencia a compilação do bootloader, kernel e geração da
# imagem final para execução no QEMU.
# ============================================================

# Ferramentas
ASM      = nasm
CC       = i686-elf-gcc
LD       = i686-elf-ld
OBJCOPY  = i686-elf-objcopy
QEMU     = qemu-system-i386

# Flags
ASMFLAGS    = -f bin
CFLAGS      = -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g
LDFLAGS     = -T kernel/kernel.ld -nostdlib

# Arquivos fonte
BOOTLOADER_SRC = bootloader/boot.asm
KERNEL_C_SRC   = kernel/kernel.c kernel/vga.c
KERNEL_OBJ     = $(KERNEL_C_SRC:.c=.o)

# Arquivos gerados
BOOTLOADER_BIN = bootloader/bootloader.bin
KERNEL_ELF     = kernel/kernel.elf
KERNEL_BIN     = kernel/kernel.bin
IMAGE          = microcoop.bin

# ============================================================
# Targets principais
# ============================================================

.PHONY: all bootloader kernel run clean debug test

# Padrão: construir tudo
all: $(IMAGE)

# ============================================================
# Build do Bootloader
# ============================================================

bootloader: $(BOOTLOADER_BIN)

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	@echo "[BUILD] Compilando bootloader..."
	$(ASM) $(ASMFLAGS) $< -o $@
	@echo "[BUILD] Bootloader compilado: $(BOOTLOADER_BIN)"
	@echo "  Tamanho: $$(wc -c < $@) bytes"

# ============================================================
# Build do Kernel
# ============================================================

kernel: $(KERNEL_BIN)

# Regra implícita: .c → .o
%.o: %.c
	@echo "[BUILD] Compilando $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Link do kernel ELF
$(KERNEL_ELF): $(KERNEL_OBJ)
	@echo "[BUILD] Linkando kernel..."
	$(LD) $(LDFLAGS) -o $@ $^

# Extrair binário puro
$(KERNEL_BIN): $(KERNEL_ELF)
	@echo "[BUILD] Extraindo kernel binário..."
	$(OBJCOPY) -O binary $< $@
	@echo "[BUILD] Kernel compilado: $(KERNEL_BIN)"
	@echo "  Tamanho: $$(wc -c < $@) bytes"

# ============================================================
# Imagem Final (bootloader + kernel concatenados)
# ============================================================

$(IMAGE): bootloader kernel
	@echo "[BUILD] Gerando imagem final: $(IMAGE)"
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) > $@
	# Garantir que a imagem seja múltiplo de 512 bytes
	actual_size=$$(wc -c < $@); \
	padding=$$(( (512 - (actual_size % 512)) % 512 )); \
	if [ $$padding -ne 0 ]; then \
		dd if=/dev/zero bs=1 count=$$padding >> $@ 2>/dev/null; \
	fi
	@echo "[BUILD] Imagem gerada: $(IMAGE)"
	@echo "  Tamanho total: $$(wc -c < $@) bytes"

# ============================================================
# Executar no QEMU
# ============================================================

run: $(IMAGE)
	@echo "[RUN] Iniciando QEMU..."
	$(QEMU) -drive format=raw,file=$(IMAGE) -m 128M -serial stdio

# Modo debug (sem aceleração, monitor QEMU)
debug: $(IMAGE)
	@echo "[DEBUG] Iniciando QEMU em modo debug..."
	$(QEMU) -drive format=raw,file=$(IMAGE) -m 128M -d cpu_reset -no-reboot -no-shutdown

# ============================================================
# Testes
# ============================================================

test: test-boot test-build

# Verificar assinatura de boot (0xAA55)
test-boot: $(BOOTLOADER_BIN)
	@echo "[TEST] Verificando assinatura do bootloader..."
	@signature=$$(xxd -s 510 -l 2 -p $(BOOTLOADER_BIN)); \
	if [ "$$signature" = "55aa" ]; then \
		echo "[TEST] ✅ Assinatura de boot válida (0xAA55)"; \
	else \
		echo "[TEST] ❌ Assinatura de boot INVÁLIDA ($$signature)"; \
		exit 1; \
	fi

# Verificar se a compilação completa funciona
test-build: clean all
	@echo "[TEST] ✅ Compilação completa bem-sucedida!"
	@echo "  Imagem: $(IMAGE)"
	@echo "  Tamanho: $$(wc -c < $(IMAGE)) bytes"

# ============================================================
# Limpeza
# ============================================================

clean:
	@echo "[CLEAN] Limpando arquivos compilados..."
	rm -f $(BOOTLOADER_BIN) $(KERNEL_OBJ) $(KERNEL_ELF) $(KERNEL_BIN) $(IMAGE)
	@echo "[CLEAN] Limpeza concluída."
