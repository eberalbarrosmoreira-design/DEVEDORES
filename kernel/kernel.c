/**
 * @file kernel.c
 * @brief Kernel principal do Microcoop OS
 *
 * Microcoop OS — Ponto de entrada do kernel em modo protegido 32 bits.
 * Inicializa os subsistemas básicos e exibe a mensagem de boas-vindas.
 *
 * Arquitetura: i386 (x86) modo protegido
 * Compilador: i686-elf-gcc (cross-compiler)
 */

#include "vga.h"

/* Protótipo da função de entrada */
void kernel_main(void);

/**
 * @brief Ponto de entrada do kernel (chamado pelo bootloader)
 *
 * Esta função é o entry point definido no linker script (kernel.ld).
 * O bootloader transfere o controle para cá após configurar o modo
 * protegido e a GDT.
 */
void kernel_main(void) {
    /* Inicializa o driver VGA: limpa a tela com fundo azul e texto branco */
    vga_clear(VGA_BLUE, VGA_WHITE);

    /* Exibe o cabeçalho do sistema */
    vga_set_cursor(0, 0);
    vga_write_color("==============================================",
                    VGA_BLUE, VGA_WHITE);
    vga_set_cursor(1, 0);
    vga_write_color("          Microcoop OS iniciado               ",
                    VGA_BLUE, VGA_LIGHT_CYAN);
    vga_set_cursor(2, 0);
    vga_write_color("==============================================",
                    VGA_BLUE, VGA_WHITE);

    /* Mensagens informativas */
    vga_set_cursor(4, 0);
    vga_write_color("Modo Protegido 32-bit ativado.", VGA_BLUE, VGA_LIGHT_GREEN);

    vga_set_cursor(5, 0);
    vga_write_color("Kernel carregado em 0x10000.", VGA_BLUE, VGA_LIGHT_GREEN);

    vga_set_cursor(6, 0);
    vga_write_color("Driver VGA inicializado (80x25).", VGA_BLUE, VGA_LIGHT_GREEN);

    vga_set_cursor(8, 0);
    vga_write_color("Microcoop OS v0.1 - Sistema Operacional Educacional",
                    VGA_BLUE, VGA_WHITE);

    vga_set_cursor(9, 0);
    vga_write_color("Projeto: github.com/microcoop/microcoop-os",
                    VGA_BLUE, VGA_LIGHT_GREY);

    vga_set_cursor(11, 0);
    vga_write_color("Pressione qualquer tecla para continuar...",
                    VGA_BLUE, VGA_YELLOW);

    /* Loop principal do kernel (futuramente: escalonador de processos) */
    while (1) {
        /* HLT instruction: pausa a CPU até a próxima interrupção */
        __asm__ volatile("hlt");
    }

    /* Nunca deve chegar aqui */
}
