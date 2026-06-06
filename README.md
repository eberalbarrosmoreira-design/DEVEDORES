# 🖥️ Microcoop OS

**Microcoop OS** é um sistema operacional educacional desenvolvido em C e Assembly, projetado para fins de aprendizado sobre os fundamentos de sistemas operacionais: boot, modo protegido, gerenciamento de memória, drivers e chamadas de sistema.

## 📁 Estrutura do Projeto

```
MicrocoopOS/
├── bootloader/          # Código do bootloader (Assembly)
│   ├── boot.asm         # Bootloader principal
│   └── Makefile         # Compilação do bootloader
├── kernel/              # Núcleo do sistema
│   ├── kernel.c         # Código principal do kernel
│   ├── kernel.ld        # Linker script
│   ├── vga.c            # Driver de vídeo VGA
│   ├── vga.h            # Header do driver VGA
│   └── Makefile         # Compilação do kernel
├── drivers/             # Drivers de dispositivos
│   └── README.md        # Documentação dos drivers
├── libs/                # Bibliotecas auxiliares
│   └── README.md        # Documentação das libs
├── docs/                # Documentação técnica
│   └── arquitetura.md   # Arquitetura do sistema
├── tests/               # Testes automatizados
│   └── README.md        # Documentação dos testes
├── Makefile             # Makefile principal
├── .gitignore           # Arquivos ignorados pelo Git
└── README.md            # Este arquivo
```

## 🔧 Pré-requisitos

| Ferramenta | Função |
|-----------|--------|
| **NASM**  | Montador de código Assembly |
| **GCC**   | Compilador C (i686-elf cross-compiler) |
| **LD**    | Linker |
| **QEMU**  | Emulador de máquina virtual |
| **Make**  | Automação de build |
| **Git**   | Controle de versão |

### Instalação (Linux - Ubuntu/Debian)

```bash
# Instalar dependências básicas
sudo apt update
sudo apt install -y nasm qemu-system-x86 make gcc git build-essential

# Para cross-compiler i686-elf (recomendado):
# Opção 1: Usar pacote gcc-i686-linux-gnu
sudo apt install -y gcc-i686-linux-gnu binutils-i686-linux-gnu

# Opção 2 (Windows/WSL): Baixar do https://github.com/lordmilko/i686-elf-tools
```

### Instalação (Windows)

1. Baixe o **NASM**: https://www.nasm.us/
2. Baixe o **QEMU**: https://www.qemu.org/download/
3. Baixe o **MinGW** ou **WSL** para GCC
4. Ou use o **i686-elf-tools**: https://github.com/lordmilko/i686-elf-tools

## 🚀 Como Compilar

```bash
# Compilar tudo (bootloader + kernel)
make all

# Apenas o bootloader
make bootloader

# Apenas o kernel
make kernel

# Limpar arquivos compilados
make clean
```

## ▶️ Como Executar (com QEMU)

```bash
# Compilar e executar
make run

# Ou manualmente:
make all
qemu-system-i386 -drive format=raw,file=microcoop.bin
```

A saída esperada no QEMU será:
```
Microcoop OS iniciado
```

## 📚 Aprendizado

Este projeto segue a progressão clássica de desenvolvimento de SO:

1. **Bootloader** (Assembly): Código que roda no reset da CPU, configura o modo real e carrega o kernel
2. **Kernel mínimo** (C + Assembly): Modo protegido 32-bit, driver VGA para saída de texto
3. **Drivers**: Interrupções, teclado, disco, etc. (em desenvolvimento)
4. **Sistema de Arquivos**: Implementação futura
5. **Multitarefa**: Agendamento de processos (futuro)

## 🎯 Objetivos Educacionais

- Entender o processo de boot (BIOP → Bootloader → Kernel)
- Trabalhar com modo real e modo protegido da arquitetura x86
- Desenvolver drivers básicos (VGA, teclado)
- Aprender sobre linker scripts e cross-compilation
- Explorar gerenciamento de memória e interrupções

## 📄 Licença

Este projeto é distribuído sob a licença MIT. Sinta-se livre para estudar, modificar e compartilhar.

---

**Microcoop OS** — Aprendendo sistemas operacionais na prática. 🎓
