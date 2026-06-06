# Bibliotecas — Microcoop OS

Bibliotecas auxiliares para o kernel e drivers do Microcoop OS.

## Biblioteca Padrão

Como estamos em um ambiente **freestanding** (sem libc), precisamos
implementar nossas próprias funções padrão:

| Função | Descrição | Status |
|--------|-----------|--------|
| `memset` | Preenche memória com um byte | ⏳ Pendente |
| `memcpy` | Copia bloco de memória | ⏳ Pendente |
| `strlen` | Tamanho de string | ⏳ Pendente |
| `strcmp` | Comparação de strings | ⏳ Pendente |
| `itoa` | Inteiro para string | ⏳ Pendente |
| `printf` | Formatação de saída (simplificada) | ⏳ Pendente |

## Estrutura

```
libs/
├── string.h    — Funções de string
├── string.c
├── memory.h    — Funções de memória
├── memory.c
├── stdio.h     — Entrada/Saída simplificada
├── stdio.c
└── README.md
```
