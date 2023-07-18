;   Calculadora INTEL-32
;   Arquivo principal, onde são chamadas as principais funções do programa
;


%define    Prec16bits   0x30
%define    Prec32bits   0x31

%define    size_16Bits  7 
%define    size_32Bits  12

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


section .bss
    ; As únicas variáveis globais podem ser os ponteiros para os strings de texto das mensagens,
    user_name   resb    256     ;uma variável para receber o nome do usuário,
    user_len    equ     $-user_name

    precisao    resb    2       ;uma variável para receber a resposta de precisão
                                ; e
    input       resb    255     ;uma variável para receber a opção do menu 
                                ;TODAS as outras variáveis DEVEM ser LOCAIS NA PILHA.

    global precisao
    global input
section .text
    global _start
    global _print
    global _inputStr
    global _inputN
    global _inputN16
    global _inputN32
    global _toInt
    global _toStr
    global _SAIR
    global _MENU
    extern break
    
    extern  _SOMA
    extern  _SUBTRACAO
    extern  _MULTIPLICACAO
    extern  _DIVISAO
    ;extern  _EXPONENCIACAO
    extern  _MOD

_start: ; Main program

; O programa principal deve UNICAMENTE chamar funções, e receber as saídas das funções que podem 
; ser utilizadas como entrada de outras (se necessário). O programa principal NÃO deve 
; processar dados nem fazer nenhuma operação de entrada e saída de dados diretamente. 
; As funções de entrada e saída de dados podem ser chamadas pelo programa principal e 
; outras funções.
    
    ; "Bem-vindo. Digite seu nome: "
    ;push    msg_bem_vindo              
    ;push    size_msg_bem_vindo        
    ;call    _print

    ; Ler o nome do usuário
    ;push    user_name                  
    ;push    255                        
    ;call    _inputStr
    

    

    ; "Hola, "
    ;push    msg_hola1
    ;push    size_hola1
    ;call   _print

    ; Escrever o nome do usuário
    ;push    user_name
    ;push    user_len
    ;call    _print
    
    ; ", bem-vindo ao programa de CALC IA-32"
    ;push    msg_hola2
    ;push    size_hola2
    ;call   _print


    ; ============= Escolha da precisão ======================
    ; "Vai  trabalhar  com  16  ou  32  bits  (digite  0  para  16,  e  1  para  32):"
    push    msg_precisao
    push    size_msg_precisao
    call   _print

    ; Ler a precisão
    push    precisao
    push    2
    call    _inputStr

    ; Converter o valor lido da precisão para inteiro
    ;push    precisao
    ;call    _toInt

   
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
    push    2
    call    _inputStr


    
    mov     AL, [input]

    cmp     AL, '1'
    je      _SOMA
    cmp     AL, '2'
    je      _SUBTRACAO
    cmp     AL, '3'
    je      _MULTIPLICACAO
    cmp     AL, '4'
    je      _DIVISAO
    cmp     AL, '5'
    ;je      _EXPONENCIACAO
    cmp     AL, '6'
    je      _MOD
    cmp     AL, '7'
    je      _SAIR



_SAIR:
    ; Terminar o programa
    mov     eax, 1        ; Número da chamada de sistema para sair
    xor     ebx, ebx      ; Código de retorno (0)
    int     80h           ; Chamar a interrupção 80h


_toInt: ; Converte uma string de numero para inteiro e retorna em EAX
    enter 0,0

    mov     ecx, [ebp+8]    ; Endereço da string em eax

    xor     eax, eax         ; Zerar eax
    xor     ebx, ebx         ; Zerar ebx
    xor     edx, edx         ; Zerar edx

    cmp     BYTE [ecx], 0x2D     ;se for negativo
    je      .negativo
    jmp     .loop

.negativo:
    mov     esi, 1
    inc     ecx
    jmp     .loop

.loop:
    cmp     BYTE [ecx], 0xA     ;se for enter
    je      .end
    movzx   ebx, byte [ecx]     ;coloca o valor do byte em bx
    sub     ebx, 0x30           ;subtrai 30h para transformar em numero
    
    imul    eax, 10             ;multiplica eax por 10
    add     eax, ebx            ;adiciona o proximo valor

    inc     ecx
    jmp     .loop

.negativo2:
    neg     eax
    mov     esi, 0
    leave
    ret    4

.end:
    cmp     esi, 1     ;se for negativo
    je      .negativo2
    leave   
    ret     4

; A função principal e funções de entrada e saída de dados devem estar no mesmo arquivo 
; CALCULADORA.ASM.

;Todas as mensagens de TEXTO devem ser mostradas usando uma ÚNICA função de saída 
;de dados de string. Esta função deve receber pela pilha o ponteiro da variável global que 
;contém o string e a quantidade de bytes a serem escritos. Não deve ter retorno.
_print:

    mov     eax, 4          ; Número da chamada de sistema para escrever
    mov     ebx, 1          ; (1 : saída padrão - STDOUT)
    mov     ecx, [esp+8]    ; Endereço da string em ecx 
    mov     edx, [esp+4]    ; Número de bytes a serem escritos em edx
    int     80h             ; Chamar a interrupção 80h 
    ret     8


_inputStr:
    mov     eax, 3          ; Número da chamada de sistema para ler
    mov     ebx, 0          ; Descritor de arquivo (0 para a entrada padrão - STDIN)
    mov     ecx, [esp+8]    ; Guardar a string no ponteiro que esta em ecx
    mov     edx, [esp+4]    ; Colocar o número de bytes a serem lidos em edx
    int     80h             ; Chamar a interrupção 80h
    mov     BYTE [ecx+eax-1], 0  ; retira o enter da string
    ret     8

_inputN:

    mov     AL, [precisao]
    cmp     AL, Prec16bits
    je      _inputN16
    cmp     AL, Prec32bits
    je      _inputN32

_inputN16:

    mov     eax, 3
    mov     ebx, 0
    mov     ecx, [esp+4]
    mov     edx, size_16Bits
    int     80h
    ret     4

_inputN32:
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, [esp+4]
    mov     edx, size_32Bits
    int     80h
    ret     4

; DIV ->   EAX = EAX / source. Resto em DX, resultado em EAX
_toStr: ; Função que recebe um número inteiro e retorna uma string
    enter 12,0

    mov     eax, [ebp+12]    ; numero inteiro em eax
.continuaStr:
    mov     ecx, ebp        ; endereço da string localmente reservada
    xor     ebx, ebx
    mov     bx, 10          ; divisor em bx

    xor     edi, edi        ; zera o contador do tamanho da string
    cmp     eax, 0          ; testa se é negativo ou zero
    je      .zero
    jge     .loop
    jnge    .negativo

.negativo:
    mov     esi, 1          ;seta a flag de numero negativo
    neg     eax
    jmp     .loop
.zero:          ;resultado é zero
    dec     ecx
    mov     BYTE [ecx], 0x30     ;coloca 0
    inc     edi
    jmp     .preenche
.loop:
    cmp     eax, 0          ; testa se é zero
    je      .testaneg
    xor     edx, edx    ; limpa o resto da divisão
    div     ebx          ; divide eax = eax / 10  ; DX = eax mod 10
    
    dec    ecx             ; incrementa o endereço da string
    add    DL, 0x30     ; soma 30h para transformar em ascii
    mov    [ecx], DL    ; coloca o valor do resto na string     
    
    inc     edi             ; incrementa o contador do tamanho da string

    jmp     .loop

.testaneg:
    cmp     esi, 1     ;se for negativo vai pra .negativo2
    jne     .preenche
.negativo2:
    dec     ecx
    mov     BYTE [ecx], 0x2D     ;coloca o sinal negativo na string
    inc     edi

.preenche:
    mov     eax, edi        ; coloca o tamanho da string em eax    
    mov     edx, [ebp+8]          ; coloca o endereço da string a ser salvada em edx
.loop_preenche:
    cmp     edi, 0          ; testa se é zero
    je      .end
    mov     BL, [ecx]       ; coloca o valor da string em DL
    mov     [edx], BL       ; coloca o valor da string no endereço de destino
    inc     edx             ; incrementa o endereço de destino
    inc     ecx             
    dec     edi             ; decrementa o tamanho da string
    jmp     .loop_preenche

.end:
    leave
    ret     8



; ================= Coisas para fazer ainda =================
; Fazer as operações de Multiplicacao, divisao, exponenciacao e modulo

; Consertar divisao em 32 bits com numeros negativos