# Testes — Microcoop OS

Esta pasta contém testes automatizados e scripts para validação do sistema.

## Tipos de Teste

| Teste | Descrição | Ferramenta |
|-------|-----------|-----------|
| **Unitários** | Testes de funções C individuais | Minha própria framework |
| **Boot** | Verifica se o bootloader compila e é válido (assinatura 0xAA55) | NASM + script |
| **QEMU** | Testa se o sistema boota corretamente no emulador | QEMU + expect |

## Como Executar

```bash
# Testar se o bootloader é válido
make test-boot

# Executar no QEMU (teste visual)
make run

# Testar compilação completa
make test-build
```

## Estrutura

```
tests/
├── README.md           — Este arquivo
├── test_boot.sh        — Script para validar bootloader
├── test_kernel.sh      — Script para validar kernel
└── test_qemu.sh        — Script para teste no QEMU
```
