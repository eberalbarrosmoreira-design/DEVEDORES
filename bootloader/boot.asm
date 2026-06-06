; ============================================================
; boot.asm — Bootloader do Microcoop OS
; ============================================================
; Função: Inicializa o sistema em modo real, carrega o kernel
;         da memória e transfere o controle para o modo protegido.
; ============================================================

[org 0x7C00]                ; Endereço onde o bootloader é carregado pelo BIOS
[bits 16]                   ; Modo real (16 bits)

; ============================================================
; Constantes
; ============================================================
KERNEL_LOAD_SEG  equ 0x1000 ; Segmento onde o kernel será carregado
KERNEL_LOAD_OFF  equ 0x0000 ; Offset dentro do segmento
KERNEL_SECTORS   equ 20     ; Número de setores a carregar (máx ~10KB)
SECTOR_SIZE      equ 512    ; Tamanho de um setor

; ============================================================
; Início
; ============================================================
start:
    ; Configura segmentos de dados e pilha
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00          ; Pilha logo abaixo do bootloader

    ; Salva o número do drive de boot (passado pelo BIOS em DL)
    mov [boot_drive], dl

    ; Limpa a tela (modo texto VGA)
    mov ax, 0x0003
    int 0x10

    ; Exibe mensagem de boot
    mov si, msg_boot
    call print_string

    ; Carrega o kernel do disco
    call load_kernel

    ; Exibe mensagem de sucesso
    mov si, msg_loading
    call print_string

    ; Pula para o modo protegido e executa o kernel
    jmp enter_protected_mode

; ============================================================
; load_kernel — Carrega o kernel do disco para a memória
; ============================================================
load_kernel:
    mov ah, 0x02            ; Função: ler setores do disco
    mov al, KERNEL_SECTORS  ; Quantidade de setores
    mov ch, 0x00            ; Cilindro 0
    mov dh, 0x00            ; Cabeça 0
    mov cl, 0x02            ; Setor inicial (setor 2, após o bootloader)
    mov dl, [boot_drive]    ; Drive de boot
    mov bx, KERNEL_LOAD_SEG ; Segmento de destino
    mov es, bx
    xor bx, bx              ; Offset 0

    int 0x13                ; Interrupção de disco

    jc disk_error           ; Se houver erro (CF=1), pula para tratamento

    ret

; ============================================================
; disk_error — Tratamento de erro de leitura do disco
; ============================================================
disk_error:
    mov si, msg_error
    call print_string

    ; Aguarda tecla para reiniciar
    xor ax, ax
    int 0x16

    ; Reinicia o sistema
    mov ax, 0x0001
    int 0x19

    jmp $                   ; Fallback: loop infinito

; ============================================================
; print_string — Exibe uma string terminada em 0 na tela
; Entrada: SI = ponteiro para a string
; ============================================================
print_string:
    push ax
    push bx

    mov ah, 0x0E            ; Função: escrever caractere (teletype)
    mov bx, 0x0007          ; Página 0, atributo branco sobre preto

.loop:
    lodsb                   ; Carrega byte de [SI] em AL, incrementa SI
    or al, al               ; Verifica se é zero (terminador)
    jz .done                ; Se for zero, termina
    int 0x10                ; Exibe caractere
    jmp .loop

.done:
    pop bx
    pop ax
    ret

; ============================================================
; enter_protected_mode — Configura e entra no modo protegido
; ============================================================
enter_protected_mode:
    cli                     ; Desabilita interrupções

    ; Carrega a GDT (Global Descriptor Table)
    lgdt [gdt_descriptor]

    ; Habilita o bit de modo protegido (PE) no CR0
    mov eax, cr0
    or eax, 0x01
    mov cr0, eax

    ; Far jump para limpar pipeline e carregar CS com seletor da GDT
    jmp 0x08:protected_mode_entry

    ; Nunca deve chegar aqui
    jmp $

; ============================================================
; Dados
; ============================================================
boot_drive:  db 0
msg_boot:    db "[Microcoop OS] Inicializando bootloader...", 0x0D, 0x0A, 0
msg_loading: db "[Microcoop OS] Kernel carregado. Entrando em modo protegido...", 0x0D, 0x0A, 0
msg_error:   db "[ERRO] Falha ao ler o disco! Pressione qualquer tecla para reiniciar.", 0x0D, 0x0A, 0

; ============================================================
; GDT (Global Descriptor Table) — Mínima para modo protegido
; ============================================================
; Entry 0: NULL descriptor (obrigatório)
gdt_start:
    dq 0x0000000000000000

; Entry 1: Código (Code segment) — Base 0, Limit 4GB, Ring 0
gdt_code:
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0000       ; Base (bits 0-15)
    db 0x00         ; Base (bits 16-23)
    db 10011010b    ; Acesso: Present, Ring 0, Code, Executável, Readable
    db 11001111b    ; Flags: 4KB granularity, 32-bit mode; Limit (bits 16-19)
    db 0x00         ; Base (bits 24-31)

; Entry 2: Dados (Data segment) — Base 0, Limit 4GB, Ring 0
gdt_data:
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0x0000       ; Base (bits 0-15)
    db 0x00         ; Base (bits 16-23)
    db 10010010b    ; Acesso: Present, Ring 0, Data, Readable/Writable
    db 11001111b    ; Flags: 4KB granularity, 32-bit mode; Limit (bits 16-19)
    db 0x00         ; Base (bits 24-31)

gdt_end:

; Descritor da GDT (tamanho e endereço)
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Tamanho da GDT - 1
    dd gdt_start                ; Endereço da GDT

; ============================================================
; Modo Protegido (32 bits)
; ============================================================
[bits 32]
protected_mode_entry:
    ; Configura segmentos de dados
    mov ax, 0x10          ; Seletor do segmento de dados (gdt_data)
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Configura pilha no topo da memória disponível
    mov esp, 0x90000

    ; Transfere controle para o kernel (endereço linear = segment:offset)
    ; Segmento 0x1000, offset 0x0000 → endereço linear 0x10000
    jmp 0x08:0x10000

    ; Nunca deve retornar
    hlt

; ============================================================
; Preenchimento e assinatura de boot (512 bytes, magic 0xAA55)
; ============================================================
times 510 - ($ - $$) db 0
dw 0xAA55
