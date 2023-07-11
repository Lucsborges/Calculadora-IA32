;   Calculadora INTEL-32
;   Arquivo principal, onde são chamadas as principais funções do programa
;

section .data

    msg_bem_vindo       db      "Bem-vindo. Digite seu nome: ", 0
    size_msg_bem_vindo  equ     $-msg_bem_vindo

    msg_hola1           db      "Hola, ", 0
    size_hola1          equ     $-msg_hola1
    msg_hola2           db      ", bem-vindo ao programa de CALC IA-32", 0xA,0
    size_hola2          equ     $-msg_hola2

    msg_precisao        db      "Vai  trabalhar  com  16  ou  32  bits  (digite  0  para  16,  e  1  para  32): "
    size_msg_precisao   equ     $-msg_precisao

    msg_menu            db      "ESCOLHA  UMA  OPÇÃO: ",0xA,"-  1:  SOMA",0xA,"-  2:  SUBTRACAO",0xA,"-  3:  MULTIPLICACAO",0xA,"-  4:  DIVISAO ",0xA,"-  5:  EXPONENCIACAO",0xA,"-  6:  MOD",0xA,"-  7:  SAIR",0xA,0
    size_msg_menu       equ     $-msg_menu


    ent                 db      0xA,0
    size_enter          equ     $-ent

section .bss
    ; As únicas variáveis globais podem ser os ponteiros para os strings de texto das mensagens,
    user_name   resb    256     ;uma variável para receber o nome do usuário,
    precisao    resd    1       ;uma variável para receber a resposta de precisão
                                ; e
    input       resd    1       ;uma variável para receber a opção do menu 
                                ;TODAS as outras variáveis DEVEM ser LOCAIS NA PILHA.


section .text
    global  _start
    global  _print
    global  _inputStr
    global  _inputN16
    global  _inputN32
    global  _toInt
    global  _SAIR
    global  _MENU
    
    extern  _SOMA
    ;extern  _SUBTRACAO
    ;extern  _MULTIPLICACAO
    ;extern  _DIVISAO
    ;extern  _EXPONENCIACAO
    ;extern  _MOD


_start: ; Main program

; O programa principal deve UNICAMENTE chamar funções, e receber as saídas das funções que podem 
; ser utilizadas como entrada de outras (se necessário). O programa principal NÃO deve 
; processar dados nem fazer nenhuma operação de entrada e saída de dados diretamente. 
; As funções de entrada e saída de dados podem ser chamadas pelo programa principal e 
; outras funções.
    
    ; "Bem-vindo. Digite seu nome: "
    push    msg_bem_vindo              
    push    size_msg_bem_vindo        
    call    _print

    ; Ler o nome do usuário
    push    user_name                  
    push    255                        
    call    _inputStr

    ; "Hola, "
    push    msg_hola1
    push    size_hola1
    call   _print

    ; Escrever o nome do usuário
    push    user_name
    push    255
    call    _print
    
    ; ", bem-vindo ao programa de CALC IA-32"
    push    msg_hola2
    push    size_hola2
    call   _print


    ; ============= Escolha da precisão ======================
    ; "Vai  trabalhar  com  16  ou  32  bits  (digite  0  para  16,  e  1  para  32):"
    push    msg_precisao
    push    size_msg_precisao
    call   _print

    ; Ler a precisão
    push    input
    push    255
    call    _inputStr

    ; Converter o valor lido da precisão para inteiro
    push    precisao
    push    10
    call    _toInt
   
_MENU:
    ; ============= Escolha da operação ======================
    ; ESCOLHA  UMA  OPÇÃO: 
    ; -  1:  SOMA
    ; -  2:  SUBTRACAO
    ; -  3:  MULTIPLICACAO 
    ; -  4:  DIVISAO
    ; -  5:  EXPONENCIACAO 
    ; -  6:  MOD
    ; -  7:  SAIR
    push    msg_menu
    push    size_msg_menu
    call   _print


    ; Ler a opção
    push    input
    push    255
    call    _inputStr

    ; Converter o valor lido da opção para inteiro
    ;push    input
    ;push    10
    ;call    _toInt

    cmp     WORD [input], 1
    je      _SOMA
    cmp     WORD [input], 2
    ;je      _SUBTRACAO
    cmp     WORD [input], 3
    ;je      _MULTIPLICACAO
    cmp     WORD [input], 4
    ;je      _DIVISAO
    cmp     WORD [input], 5
    ;je      _EXPONENCIACAO
    cmp     WORD [input], 6
    ;je      _MOD
    cmp     WORD [input], 7
    je      _SAIR




_SAIR:
    ; Terminar o programa
    mov     eax, 1        ; Número da chamada de sistema para sair
    xor     ebx, ebx      ; Código de retorno (0)
    int     80h           ; Chamar a interrupção 80h


_toInt:
    mov     eax, 0
    mov     edx, 0
    mov     ecx, [esp+4]
    mov     ebx, [esp+8]
    int     80h
    mov     [ebx], eax
    ret     8

; A função principal e funções de entrada e saída de dados devem estar no mesmo arquivo 
; CALCULADORA.ASM.

;Todas as mensagens de TEXTO devem ser mostradas usando uma ÚNICA função de saída 
;de dados de string. Esta função deve receber pela pilha o ponteiro da variável global que 
;contém o string e a quantidade de bytes a serem escritos. Não deve ter retorno.
_print:

    mov     eax, 4          ; Número da chamada de sistema para escrever
    mov     ebx, 1          ; Descritor de arquivo (1 para a saída padrão - STDOUT)
    mov     ecx, [esp+8]    ; Colocar o endereço da string em ecx 
    mov     edx, [esp+4]    ; Colocar o número de bytes a serem escritos em edx
    int     80h             ; Chamar a interrupção 80h
    ret     8


_inputStr:
    mov     eax, 3          ; Número da chamada de sistema para ler
    mov     ebx, 0          ; Descritor de arquivo (0 para a entrada padrão - STDIN)
    mov     ecx, [esp+8]    ; Colocar o endereço do buffer em ecx
    mov     edx, [esp+4]    ; Colocar o número de bytes a serem lidos em edx
    int     80h             ; Chamar a interrupção 80h
    ret     8

_inputN16:
    mov     eax, 3
    mov     ebx, 0
    mov     cx, [esp+6]
    mov     dx, 2
    int     80h
    ret     4

_inputN32:
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, [esp+8]
    mov     edx, 4
    int     80h
    ret     8








; ================= Coisas para fazer ainda =================

; Arrumar a linha de Hola, para "Hola, <nome> bem-vindo ao programa de CALC IA-32"

; Fazer a parte de escolha da precisão

; Fazer todas as operações