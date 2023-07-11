;   Calculadora INTEL-32
;   Arquivo de funcoes de SOMA
;

section .data
    msg1        db      "Digite o primeiro numero: ", 0
    size_msg1   equ     $-msg1

    msg2        db      "Digite o segundo numero: ", 0
    size_msg2   equ     $-msg2


section .bss



section .text
    
    global  _SOMA

    extern  _print
    extern  _toInt
    extern  _inputStr
    extern  _inputN16
    extern  _inputN32

_SOMA:

    push    msg1
    push    size_msg1
    call    _print



    ; Terminar o programa
    mov     eax, 1        ; Número da chamada de sistema para sair
    xor     ebx, ebx      ; Código de retorno (0)
    int     80h           ; Chamar a interrupção 80h