# Drivers — Microcoop OS

Esta pasta contém os drivers de dispositivos do sistema.

## Drivers Implementados

| Driver | Descrição | Status |
|--------|-----------|--------|
| VGA    | Vídeo modo texto 80x25 | ✅ Implementado (no kernel/) |

## Próximos Drivers

- **Teclado** (8042/PS2): Leitura de teclas via porta I/O
- **PIT** (Programmable Interval Timer): Timer do sistema
- **ATA/PATA**: Leitura/escrita em disco
- **Serial**: Depuração via porta serial (COM1)

## Arquitetura

Cada driver segue a seguinte estrutura:
```
drivers/<nome>/
├── <nome>.h    — Interface pública
├── <nome>.c    — Implementação
└── README.md   — Documentação específica
```
