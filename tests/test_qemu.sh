#!/bin/bash
#
# test_qemu.sh — Executa o Microcoop OS no QEMU para teste visual
#
# Uso: ./test_qemu.sh [--debug] [--no-reboot]
#
# Flags:
#   --debug      Ativa modo debug (monitor QEMU, sem aceleração)
#   --no-reboot  Desliga o QEMU ao invés de reiniciar em caso de erro

PROJECT_DIR="$(dirname "$0")/.."
IMAGE="$PROJECT_DIR/microcoop.bin"

MODE="normal"
EXTRA_ARGS=""

# Processa argumentos
for arg in "$@"; do
    case $arg in
        --debug)
            MODE="debug"
            shift
            ;;
        --no-reboot)
            EXTRA_ARGS="$EXTRA_ARGS -no-reboot -no-shutdown"
            shift
            ;;
    esac
done

# Verifica se a imagem existe
if [ ! -f "$IMAGE" ]; then
    echo "[QEMU] Imagem '$IMAGE' não encontrada!"
    echo "[QEMU] Execute 'make all' primeiro."
    exit 1
fi

echo "==================================="
echo "  QEMU — Microcoop OS"
echo "==================================="
echo "  Imagem: $IMAGE"
echo "  Modo:   $MODE"
echo "==================================="

case $MODE in
    normal)
        echo "[QEMU] Iniciando QEMU..."
        echo "[QEMU] Pressione Ctrl+Alt+G para liberar o mouse"
        echo "[QEMU] Pressione Ctrl+Alt+2 para monitor QEMU"
        echo "[QEMU] Pressione Ctrl+Alt+1 para voltar à tela"
        echo ""
        qemu-system-i386 -drive format=raw,file="$IMAGE" -m 128M \
            -serial stdio $EXTRA_ARGS
        ;;
    debug)
        echo "[QEMU] Iniciando QEMU em modo debug..."
        echo "[QEMU] Monitor QEMU disponível via Ctrl+Alt+2"
        qemu-system-i386 -drive format=raw,file="$IMAGE" -m 128M \
            -d cpu_reset -no-reboot -no-shutdown -s -S $EXTRA_ARGS
        ;;
esac

echo "[QEMU] Finalizado."
