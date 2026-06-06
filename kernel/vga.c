/**
 * @file vga.c
 * @brief Implementação do driver de vídeo VGA
 *
 * Microcoop OS — Gerencia o buffer de vídeo VGA no modo texto 80x25,
 * permitindo escrita de caracteres coloridos na tela.
 */

#include "vga.h"

/** Ponteiro para o buffer de vídeo VGA (endereço físico 0xB8000) */
static volatile uint16_t* const vga_buffer = (uint16_t*)0xB8000;

/** Posição atual do cursor */
static uint8_t cursor_row = 0;
static uint8_t cursor_col = 0;

/** Cor atual (fundo e frente combinados em um byte) */
static uint8_t current_color;

/**
 * @brief Cria um byte de atributo de cor VGA
 * @param bg Cor de fundo (bits 4-6)
 * @param fg Cor do texto (bits 0-3)
 * @return Byte de atributo combinado
 */
static inline uint8_t make_color(vga_color_t bg, vga_color_t fg) {
    return (bg << 4) | fg;
}

/**
 * @brief Cria uma entrada VGA (caractere + atributo)
 * @param c Caractere ASCII
 * @param color Byte de atributo de cor
 * @return Palavra de 16 bits no formato VGA
 */
static inline uint16_t make_vga_entry(char c, uint8_t color) {
    return (uint16_t)c | ((uint16_t)color << 8);
}

void vga_clear(vga_color_t bg, vga_color_t fg) {
    current_color = make_color(bg, fg);

    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = make_vga_entry(' ', current_color);
    }

    cursor_row = 0;
    cursor_col = 0;
}

void vga_write(const char* str) {
    vga_write_color(str, current_color >> 4, current_color & 0x0F);
}

void vga_write_color(const char* str, vga_color_t bg, vga_color_t fg) {
    current_color = make_color(bg, fg);

    for (int i = 0; str[i] != '\0'; i++) {
        char c = str[i];

        switch (c) {
            case '\n':  // Nova linha
                cursor_row++;
                cursor_col = 0;
                break;

            case '\r':  // Retorno de carro
                cursor_col = 0;
                break;

            case '\t':  // Tabulação
                cursor_col = (cursor_col + 4) & ~3;  // Alinha a 4
                break;

            default:    // Caractere normal
                if (cursor_col >= VGA_WIDTH) {
                    cursor_col = 0;
                    cursor_row++;
                }
                break;
        }

        // Rolagem de tela quando atinge o final
        while (cursor_row >= VGA_HEIGHT) {
            // Move todas as linhas uma para cima
            for (int row = 1; row < VGA_HEIGHT; row++) {
                for (int col = 0; col < VGA_WIDTH; col++) {
                    vga_buffer[(row - 1) * VGA_WIDTH + col] =
                        vga_buffer[row * VGA_WIDTH + col];
                }
            }
            // Limpa a última linha
            for (int col = 0; col < VGA_WIDTH; col++) {
                vga_buffer[(VGA_HEIGHT - 1) * VGA_WIDTH + col] =
                    make_vga_entry(' ', current_color);
            }
            cursor_row--;
        }

        if (c >= ' ' && c <= '~') {  // Caractere imprimível
            uint16_t index = cursor_row * VGA_WIDTH + cursor_col;
            vga_buffer[index] = make_vga_entry(c, current_color);
            cursor_col++;
        }
    }
}

void vga_set_cursor(uint8_t row, uint8_t col) {
    if (row < VGA_HEIGHT && col < VGA_WIDTH) {
        cursor_row = row;
        cursor_col = col;
    }
}

uint8_t vga_get_row(void) {
    return cursor_row;
}

uint8_t vga_get_col(void) {
    return cursor_col;
}

