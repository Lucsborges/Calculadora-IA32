;   Calculadora INTEL-32
;   Arquivo de funcoes de MOD

%define    numero1_16   [ebp-4]
%define    numero2_16   [ebp-11]

%define    numero1_32   [ebp-4]
%define    numero2_32   [ebp-16]

%define    Prec16bits   0x30
%define    Prec32bits   0x31

%define    size_16Bits  8   ; 5 bits pra caber um 16bits, 1 bit pro enter, 1 pro sinal
%define    size_32Bits  12 ; 10 bits pra caber um 32bits, 1 bit pro enter, 1 pro sinal


section .data
    msgn1        db      "Digite o primeiro numero: ", 0
    size_msgn1   equ     $-msgn1

    msgn2        db      "Digite o segundo numero: ", 0
    size_msgn2   equ     $-msgn2

    msgMOD16    db      "=========== MOD de 16 bits ===========",0xA, 0
    size_msgMOD16   equ     $-msgMOD16

    msgMOD32    db      "=========== MOD de 32 bits ===========",0xA, 0
    size_msgMOD32   equ     $-msgMOD32

    msgResultado db      "Resultado: ", 0
    size_msgResultado equ $-msgResultado

    msgOVERFLOW db      "OCORREU OVERFLOW", 0xA, 0
    size_msgOVERFLOW equ $-msgOVERFLOW

    extern precisao
    extern input

section .text
 
    global  _MOD

    extern _MENU
    extern _print
    extern _toInt
    extern _toStr
    extern _inputStr
    extern _inputN
    extern _inputN16
    extern _inputN32
    extern _SAIR
    global break

_MOD:
    push    ebp
    mov     ebp, esp


    mov     AL, [precisao]
    cmp     AL, Prec32bits
    je      _MOD32
    cmp     AL, Prec16bits
    je      _MOD16

    jmp     _SAIR

_MOD16:
    enter  16,0     ; alocando espaço para duas strings de numeros de 16 bits
    ; Cada numero  de 16bits pode ter no máximo: 5 digitos + 1 sinal + 1 enter = 7 bytes, arredondando para 8

    ; "=========== MOD de 16 bits ==========="
    push    msgMOD16
    push    size_msgMOD16
    call    _print

    ; "Digite o primeiro numero: "
    push    msgn1
    push    size_msgn1
    call    _print

    ; Input do primeiro numero de 16 bits
    mov     eax, ebp
    sub     eax, 8
    push    eax       ; push ebp-8 (endereço do primeiro numero em string)
    call    _inputN


    ; "Digite o segundo numero: "
    push    msgn2
    push    size_msgn2
    call    _print


    ; Input do segundo numero de 16 bits
    mov     eax, ebp
    sub     eax, 16
    push    eax        ; push ebp-16 (endereço do segundo numero em string)
    call    _inputN


    ; Transformar para inteiro N1
    mov     eax, ebp
    sub     eax, 8
    push    eax             ; push ebp-8 (endereço do primeiro numero em string)
    call    _toInt

    push    eax                ; push eax (primeiro numero em inteiro)       

    ; Transformar para inteiro N2
    mov     eax, ebp
    sub     eax, 16
    push    eax             ; push ebp-16 (endereço do segundo numero em string)
    call    _toInt

    mov     ebx, eax        ; segundo numero
    ; Realizar a MOD N1 = N1 / N2
    pop     eax       ; pega o primeiro numero

    and     eax, 0x0000FFFF
    and     ebx, 0x0000FFFF

breakmod:
    cwd
    xor     edx, edx

    idiv    bx        ; MOD os dois numeros


    ; Transformar o resultado para string
    push    edx             ; push eax (resultado da MOD)
   
    mov     eax, ebp
    sub     eax, 8
    push    eax             ; push ebp-8 (endereço que vai ser gravado o resultado em string)


    call    _toStr
    push    eax             ; tamanho da string do resultado

    ; "Resultado: "
    push    msgResultado
    push    size_msgResultado
    call    _print

    ; Print do resultado
    pop     eax             ; tamanho da string do resultado
    mov     ebx, ebp
    sub     ebx, 8
    push    ebx             ; push ebp-4 (endereço do resultado em string)
    push    eax             ; tamanho da string do resultado
    call    _print

    ; Print Enter
    push    "0xA"
    push    1
    call    _print

    ; Esperar o usuario apertar enter
    push input
    push 2
    call    _inputStr

    leave
    jmp     _MENU

_MOD32:

    enter  24,0

    ; "=========== MOD de 32 bits ==========="
    push    msgMOD32
    push    size_msgMOD32
    call    _print

    ; "Digite o primeiro numero: "
    push    msgn1
    push    size_msgn1
    call    _print

    ; Input do primeiro numero de 32 bits
    mov     eax, ebp
    sub     eax, 12
    push    eax       ; push ebp-12 (endereço do primeiro numero em string)
    call    _inputN

    ; "Digite o segundo numero: "
    push    msgn2
    push    size_msgn2
    call    _print

    ; Input do segundo numero de 32 bits
    mov     eax, ebp
    sub     eax, 24
    push    eax        ; push ebp-24 (endereço do segundo numero em string)
    call    _inputN

    ; Transformar para inteiro N1
    mov     eax, ebp
    sub     eax, 12
    push    eax             ; push ebp-12 (endereço do primeiro numero em string)
    call    _toInt

    push    eax                ; push eax (primeiro numero em inteiro)

    ; Transformar para inteiro N2
    mov     eax, ebp
    sub     eax, 24
    push    eax             ; push ebp-24 (endereço do segundo numero em string)
    call    _toInt

    mov     ebx, eax        ; segundo numero
    ; Realizar a MOD N1 = N1 / N2
    pop     eax       ; pega o primeiro numero

    xor     edx, edx
    idiv    bx        ; MOD os dois numeros

    ; Transformar o resultado para string
    push    edx             ; push eax (resultado da MOD)

    mov     eax, ebp
    sub     eax, 12
    push    eax             ; push ebp-12 (endereço que vai ser gravado o resultado em string)


    call    _toStr
    push    eax             ; tamanho da string do resultado

    ; "Resultado: "
    push    msgResultado
    push    size_msgResultado
    call    _print

    ; Print do resultado
    pop     eax             ; tamanho da string do resultado
    mov     ebx, ebp
    sub     ebx, 12
    push    ebx             ; push ebp-12 (endereço do resultado em string)
    push    eax             ; tamanho da string do resultado
    call    _print

    ; Print Enter
    push    "0xA"
    push    1
    call    _print

    ; Esperar o usuario apertar enter
    push input
    push 2
    call    _inputStr


    leave
    jmp     _MENU

