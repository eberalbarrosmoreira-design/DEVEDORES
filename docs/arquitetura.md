# Arquitetura do Microcoop OS

## Visão Geral

Microcoop OS é um sistema operacional educacional para arquitetura x86 (32 bits).

```
┌─────────────────────────────────────┐
│         Aplicações (futuro)         │
├─────────────────────────────────────┤
│   System Calls / Interface do SO   │
├─────────────────────────────────────┤
│          Kernel (C + ASM)           │
│  ┌───────────┬──────────┬────────┐  │
│  │ Gestão    │ Drivers  │ Syscalls│ │
│  │ Memória   │          │        │  │
│  └───────────┴──────────┴────────┘  │
├─────────────────────────────────────┤
│          Bootloader (ASM)           │
├─────────────────────────────────────┤
│              Hardware               │
└─────────────────────────────────────┘
```

## Mapa de Memória

```
Endereço      | Tamanho | Conteúdo
--------------|---------|--------------------------
0x00000000    | 1 KB    | IVT (Interrupt Vector Table)
0x00000400    | 256 B   | BDA (BIOS Data Area)
0x00000500    | ~30 KB  | Área livre
0x00007C00    | 512 B   | Bootloader
0x00007E00    | ~32 KB   | Stack
0x00010000    | ~64 KB  | Kernel
0x000A0000    | 128 KB  | VRAM (VGA graphics)
0x000B8000    | 32 KB   | VRAM (VGA text mode)
0x00100000    | 1 MB+   | High memory (>1MB)
```

## Flow de Inicialização

1. **BIOS** → Carrega bootloader do setor 0 para 0x7C00
2. **Bootloader** → Configura modo real, carrega kernel do disco para 0x10000
3. **Bootloader** → Configura GDT, entra em modo protegido (32 bits)
4. **Bootloader** → Salta para o kernel em 0x10000
5. **Kernel** → Inicializa drivers (VGA), exibe mensagem, loop principal

## Modos de Operação

### Modo Real (16 bits)
- Acesso limitado a 1 MB de memória
- Segmentação real: endereço = segment × 16 + offset
- Sem proteção de memória
- Usado apenas pelo bootloader

### Modo Protegido (32 bits)
- Acesso a 4 GB de memória
- Proteção de memória via GDT/segmentação
- Privilégios (Ring 0 a Ring 3)
- Modo principal do kernel

## Ferramentas de Build

```
[ boot.asm ] ──NASM──→ [ bootloader.bin ]
                                  │
[ kernel.c  ] ──i686-elf-gcc──→ [ kernel.o   ] ──┐
[ vga.c     ] ──i686-elf-gcc──→ [ vga.o      ] ──┼──LD──→ [ kernel.elf ] ──objcopy──→ [ kernel.bin ]
                                  │                                          │
                                  └──────────────────────────────────────────┘
                                                                              │
                                                          ┌───────────────────┘
                                                          ▼
                                            [ microcoop.bin (boot + kernel) ]
```
