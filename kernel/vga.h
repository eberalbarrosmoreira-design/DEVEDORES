#ifndef VGA_H
#define VGA_H

/**
 * @file vga.h
 * @brief Driver de vídeo VGA para modo texto 80x25
 *
 * Microcoop OS — Driver básico para manipulação do buffer de vídeo
 * VGA no modo texto colorido (80 colunas x 25 linhas).
 */

#include "types.h"

/* Dimensões do modo texto VGA */
#define VGA_WIDTH   80
#define VGA_HEIGHT  25
#define VGA_MEMORY  (volatile uint16_t*)0xB8000

/* Cores do VGA (4 bits: fundo | frente) */
typedef enum {
    VGA_BLACK         = 0,
    VGA_BLUE          = 1,
    VGA_GREEN         = 2,
    VGA_CYAN          = 3,
    VGA_RED           = 4,
    VGA_MAGENTA       = 5,
    VGA_BROWN         = 6,
    VGA_LIGHT_GREY    = 7,
    VGA_DARK_GREY     = 8,
    VGA_LIGHT_BLUE    = 9,
    VGA_LIGHT_GREEN   = 10,
    VGA_LIGHT_CYAN    = 11,
    VGA_LIGHT_RED     = 12,
    VGA_LIGHT_MAGENTA = 13,
    VGA_LIGHT_BROWN   = 14,
    VGA_WHITE         = 15,
    VGA_YELLOW        = 14  /* Sinônimo para VGA_LIGHT_BROWN */
} vga_color_t;

/**
 * @brief Limpa a tela com uma cor específica
 * @param bg Cor de fundo
 * @param fg Cor do texto
 */
void vga_clear(vga_color_t bg, vga_color_t fg);

/**
 * @brief Escreve uma string no buffer VGA na posição atual do cursor
 * @param str Ponteiro para a string terminada em '\0'
 */
void vga_write(const char* str);

/**
 * @brief Escreve uma string com uma cor específica
 * @param str String a ser escrita
 * @param bg Cor de fundo
 * @param fg Cor do texto
 */
void vga_write_color(const char* str, vga_color_t bg, vga_color_t fg);

/**
 * @brief Move o cursor para uma posição (linha, coluna)
 * @param row Linha (0 a 24)
 * @param col Coluna (0 a 79)
 */
void vga_set_cursor(uint8_t row, uint8_t col);

/**
 * @brief Obtém a linha atual do cursor
 * @return Linha atual
 */
uint8_t vga_get_row(void);

/**
 * @brief Obtém a coluna atual do cursor
 * @return Coluna atual
 */
uint8_t vga_get_col(void);

#endif /* VGA_H */

