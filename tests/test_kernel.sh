#!/bin/bash
#
# test_kernel.sh — Valida a compilação do kernel do Microcoop OS
#
# Verifica:
#   - Se os arquivos fonte C existem
#   - Se o kernel ELF foi gerado com o entry point correto
#   - Se o kernel binário foi extraído

PROJECT_DIR="$(dirname "$0")/.."

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "==================================="
echo "  Teste do Kernel — Microcoop OS"
echo "==================================="

# Teste 1: Códigos fonte existem?
SRC_FILES=("kernel/kernel.c" "kernel/vga.c" "kernel/vga.h" "kernel/kernel.ld")
for file in "${SRC_FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo -e "${GREEN}[PASS]${NC} $file encontrado"
    else
        echo -e "${RED}[FAIL]${NC} $file NÃO encontrado!"
        exit 1
    fi
done

# Teste 2: kernel.elf existe e tem entry point válido?
KERNEL_ELF="$PROJECT_DIR/kernel/kernel.elf"
if [ -f "$KERNEL_ELF" ]; then
    echo -e "${GREEN}[PASS]${NC} kernel.elf encontrado"
    
    # Verificar entry point usando readelf
    if command -v i686-elf-readelf &> /dev/null; then
        ENTRY=$(i686-elf-readelf -h "$KERNEL_ELF" 2>/dev/null | grep "Entry point" | awk '{print $4}')
        if [ -n "$ENTRY" ]; then
            echo -e "${GREEN}[PASS]${NC} Entry point: $ENTRY"
        else
            echo -e "${RED}[FAIL]${NC} Não foi possível determinar entry point"
            exit 1
        fi
    elif command -v readelf &> /dev/null; then
        ENTRY=$(readelf -h "$KERNEL_ELF" 2>/dev/null | grep "Entry point" | awk '{print $4}')
        if [ -n "$ENTRY" ]; then
            echo -e "${GREEN}[PASS]${NC} Entry point: $ENTRY"
        fi
    else
        echo -e "${YELLOW}[WARN]${NC} readelf não encontrado. Pulando verificação de entry point."
    fi
else
    echo -e "${YELLOW}[INFO]${NC} kernel.elf não encontrado. Execute 'make kernel' primeiro."
fi

# Teste 3: kernel.bin existe?
KERNEL_BIN="$PROJECT_DIR/kernel/kernel.bin"
if [ -f "$KERNEL_BIN" ]; then
    echo -e "${GREEN}[PASS]${NC} kernel.bin encontrado"
    KERNSIZE=$(stat -f%z "$KERNEL_BIN" 2>/dev/null || stat -c%s "$KERNEL_BIN" 2>/dev/null)
    echo "       Tamanho: $KERNSIZE bytes"
else
    echo -e "${YELLOW}[INFO]${NC} kernel.bin não encontrado. Execute 'make kernel' primeiro."
fi

echo "==================================="
echo -e "${GREEN}Teste concluído!${NC}"
