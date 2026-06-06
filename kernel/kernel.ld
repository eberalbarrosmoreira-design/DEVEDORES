/* ============================================================
 * kernel.ld — Linker Script do Kernel Microcoop OS
 * ============================================================
 * Define o layout de memória do kernel ELF.
 * O kernel será carregado no endereço físico 0x10000.
 * ============================================================ */

OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS
{
    /* O kernel será carregado no endereço 0x10000 (64 KB) */
    . = 0x10000;

    .text : {
        *(.text._start)     /* Entry point primeiro */
        *(.text*)           /* Todo o resto do código */
    }

    .rodata : {
        *(.rodata*)
    }

    .data : {
        *(.data*)
    }

    .bss : {
        *(COMMON)
        *(.bss*)
    }

    /* Descartar seções desnecessárias */
    /DISCARD/ : {
        *(.eh_frame)
        *(.note*)
        *(.comment*)
    }
}
