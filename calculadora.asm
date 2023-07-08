;   Calculadora INTEL-32
;   Nome: 

section .data
    msg_bem_vindo       db      "Bem-vindo. Digite seu nome: ", 0
    size_msg_bem_vindo  equ     $-msg_bem_vindo

    msg_hola1           db      "Hola, ", 0
    size_hola1          equ     $-msg_hola1
    msg_hola2           db      ", bem-vindo ao programa de CALC IA-32", 0
    size_hola2          equ     $-msg_hola2

    msg_precisao        db      "Vai  trabalhar  com  16  ou  32  bits  (digite  0  para  16,  e  1  para  32): "
    size_msg_precisao   equ     $-msg_precisao

    msg_menu            db      "ESCOLHA  UMA  OPÇÃO: \n-  1:  SOMA\n-  2:  SUBTRACAO\n-  3:  MULTIPLICACAO",0
    size_msg_menu       equ     $-msg_menu



    ent                 db      0xA,0
    size_enter          equ     $-ent

section .bss
    user_name   resb    256
    input       resb    256
    precisao    resd    1

section .text
    global _start

_start:
; ============= Mensagens de Bem vindo ======================
    ; "Bem-vindo. Digite seu nome: "
    mov eax, 4                      ; Número da chamada de sistema para escrever
    mov ebx, 1                      ; Descritor de arquivo (1 para a saída padrão - STDOUT)
    mov ecx, msg_bem_vindo          ; Endereço da string a ser escrita
    mov edx, size_msg_bem_vindo     ; Número de bytes a serem escritos
    int 80h                         ; Chamar a interrupção 80h

    ; Ler o nome do usuário
    mov eax, 3                      ; Número da chamada de sistema para ler
    mov ebx, 0                      ; Descritor de arquivo (0 para a entrada padrão - STDIN)
    mov ecx, user_name              ; Endereço do buffer de destino
    mov edx, 255                    ; Número máximo de bytes a serem lidos
    int 80h                         ; Chamar a interrupção 80h

    ; "Hola, "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_hola1
    mov edx, size_hola1
    int 80h

    ; Escrever o nome do usuário
    mov eax, 4
    mov ebx, 1
    mov ecx, user_name
    mov edx, 255
    int 80h
    ; ", bem-vindo ao programa de CALC IA-32"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_hola2
    mov edx, size_hola2
    int 80h

    ; Escrever mensagem de enter
    mov eax, 4
    mov ebx, 1
    mov ecx, ent
    mov edx, size_enter
    int 80h

    ; ============= Escolha da precisão ======================
    ; "Vai  trabalhar  com  16  ou  32  bits  (digite  0  para  16,  e  1  para  32):"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_precisao
    mov edx, size_msg_precisao
    int 80h

    ; Ler a precisão
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 255
    int 80h

    ; Converter o valor lido para inteiro
    mov eax, 0
    mov ebx, input
    mov ecx, 10
    mov edx, 0
    int 80h

    ; Salvar o valor lido em uma variável
    mov [precisao], eax

    ; ============= Escolha da operação ======================
    ; "Escolha a operação: "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_menu
    mov edx, size_msg_menu
    int 80h
    

    ; printar na tela a precisao
    mov eax, 4
    mov ebx, 1
    mov ecx, precisao
    mov edx, 1
    int 80h
    















_exit:
    ; Terminar o programa
    mov eax, 1        ; Número da chamada de sistema para sair
    xor ebx, ebx      ; Código de retorno (0)
    int 80h           ; Chamar a interrupção 80h

