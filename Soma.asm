;   Calculadora INTEL-32
;   Arquivo de funcoes de SOMA
;
%define    numero1_16   [ebp-4]
%define    numero2_16   [ebp-6]

%define    numero1_32   [ebp-4]
%define    numero2_32   [ebp-8]

%define    N16bits       0x30
%define    N32bits       0x31



section .data
    msgn1        db      "Digite o primeiro numero: ", 0
    size_msgn1   equ     $-msgn1

    msgn2        db      "Digite o segundo numero: ", 0
    size_msgn2   equ     $-msgn2

    extern precisao

section .text
 
    global  _SOMA

    extern  _MENU
    extern  _print
    extern  _toInt
    extern  _inputStr
    extern  _inputN
    extern  _inputN16
    extern  _inputN32
    extern  _SAIR

_SOMA:
    push    ebp
    mov     ebp, esp

    ; "Digite o primeiro numero: "
    push    msgn1
    push    size_msgn1
    call    _print

    call _inputN

    ; "Digite o segundo numero: "
    push    msgn2
    push    size_msgn2
    call    _print

    call _inputN

    mov     AL, [precisao]
    cmp     AL, N16bits
    je      _SOMA16
    cmp     AL, N32bits
    je      _SOMA32
    jmp    _SAIR

_SOMA16:
    xor     eax, eax
    mov     ax, numero1_16
    add     ax, numero2_16
    push    eax
    push    dword 2
    call    _print





add     esp, 4      ; volta o esp para o valor anterior
pop     ebp
jmp     _MENU
_SOMA32:

add     esp, 8
pop     ebp
jmp     _MENU