#!/bin/bash
#
# test_boot.sh — Valida a imagem de boot do Microcoop OS
#
# Verifica:
#   - Se o arquivo existe
#   - Se tem pelo menos 512 bytes
#   - Se a assinatura de boot (0xAA55) está presente nos bytes 510-511
#   - Se o bootloader.bin é válido

PROJECT_DIR="$(dirname "$0")/.."
BOOTLOADER="$PROJECT_DIR/bootloader/bootloader.bin"
IMAGE="$PROJECT_DIR/microcoop.bin"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "==================================="
echo "  Teste do Bootloader — Microcoop OS"
echo "==================================="

# Teste 1: Bootloader existe?
if [ -f "$BOOTLOADER" ]; then
    echo -e "${GREEN}[PASS]${NC} bootloader.bin encontrado"
    BOOTSIZE=$(stat -f%z "$BOOTLOADER" 2>/dev/null || stat -c%s "$BOOTLOADER" 2>/dev/null)
    echo "       Tamanho: $BOOTSIZE bytes"
else
    echo -e "${RED}[FAIL]${NC} bootloader.bin não encontrado!"
    echo "       Execute 'make bootloader' primeiro."
    exit 1
fi

# Teste 2: Tamanho mínimo (bootloader deve ter pelo menos 512 bytes)
if [ -f "$BOOTLOADER" ]; then
    BOOTSIZE=$(stat -f%z "$BOOTLOADER" 2>/dev/null || stat -c%s "$BOOTLOADER" 2>/dev/null)
    if [ "$BOOTSIZE" -ge 512 ]; then
        echo -e "${GREEN}[PASS]${NC} Tamanho mínimo de 512 bytes OK"
    else
        echo -e "${RED}[FAIL]${NC} Tamanho insuficiente: $BOOTSIZE bytes (mín: 512)"
        exit 1
    fi
fi

# Teste 3: Assinatura de boot (0xAA55)
if command -v xxd &> /dev/null; then
    SIGNATURE=$(xxd -s 510 -l 2 -p "$BOOTLOADER" 2>/dev/null)
    if [ "$SIGNATURE" = "55aa" ]; then
        echo -e "${GREEN}[PASS]${NC} Assinatura de boot válida (0xAA55)"
    else
        echo -e "${RED}[FAIL]${NC} Assinatura de boot INVÁLIDA (encontrado: 0x$SIGNATURE)"
        exit 1
    fi
elif command -v od &> /dev/null; then
    SIGNATURE=$(od -A n -t x1 -j 510 -N 2 "$BOOTLOADER" | tr -d ' ')
    if [ "$SIGNATURE" = "55aa" ]; then
        echo -e "${GREEN}[PASS]${NC} Assinatura de boot válida (0xAA55)"
    else
        echo -e "${RED}[FAIL]${NC} Assinatura de boot INVÁLIDA (encontrado: 0x$SIGNATURE)"
        exit 1
    fi
else
    echo -e "${YELLOW}[WARN]${NC} xxd/od não encontrados. Pulando verificação de assinatura."
fi

# Teste 4: Imagem final existe?
if [ -f "$IMAGE" ]; then
    echo -e "${GREEN}[PASS]${NC} Imagem final microcoop.bin encontrada"
    IMGSIZE=$(stat -f%z "$IMAGE" 2>/dev/null || stat -c%s "$IMAGE" 2>/dev/null)
    echo "       Tamanho: $IMGSIZE bytes"
else
    echo -e "${YELLOW}[INFO]${NC} Imagem final microcoop.bin não encontrada."
    echo "       Execute 'make all' para gerá-la."
fi

echo "==================================="
echo -e "${GREEN}Teste concluído!${NC}"
