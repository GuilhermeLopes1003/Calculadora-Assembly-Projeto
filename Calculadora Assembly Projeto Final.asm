TITLE Guilherme Lopes SIlva - 22019085 // João Victor Vasconcelos Junqueira Crisculo - 22024547
.model small
.data 

cima DB 10, "'''''''''''''''''''''''''''''''''''''''''''''", '$'
abertura db 10, "Calculadora Assembly basica - Projeto!!!$"
baixo DB 10, "'''''''''''''''''''''''''''''''''''''''''''''", '$'
selecionar db 10,"Selecione a operacao desejada: + - / *:$"
num1 db 10,"Selecione o primeiro numero:$"
num2 db 10,"Selecione o segundo numero:$"
result db 10,"Resultado:$"
error db 10,"Erro, tente novamente.$"



.code
main proc 

MOV AX,@DATA           ;inicializa o segmento de data
MOV DS,AX 
         
inicio:
MOV AH,09H
LEA DX,cima             ;linha em cima
INT 21H

MOV AH,09h
LEA dx,abertura        ;le a abertura 
INT 21h

MOV AH,09H
LEA DX,baixo            ; linha em baixo
INT 21H

MOV AH,09h
LEA DX,selecionar ; seleciona a operação
INT 21h

MOV ah,01h         ;seleciona no teclado
INT 21h
MOV CH,AL 

 CMP CH,"+"
 jz cont
 CMP CH,"-"
 jz cont       ;verifica se selecionou as operações certas
 CMP CH,"/"
 jz cont
 CMP CH,"*"
 jz cont
 jnz erro     ;caso seja diferente as operações, pula para o erro


cont:
MOV AH,09h
LEA DX,num1        ;entrada do primeiro numero
INT 21h

MOV AH,01h
INT 21h
MOV BH,AL          ; salva em bl
AND BH,0fh     ;transforma bh em numeral

MOV AH,09h
LEA DX,num2          ;entrada do segundo numero
INT 21h

MOV AH,01h
INT 21h
MOV BL,AL           ;salva em bl
AND BL,0fh        ;transforma bl em numeral


CMP CH,"+"            ;inicia para a soma
jnz nsoma
CALL soma              ;chama a soma 
nsoma:

CMP CH,"-"           ;inicia para a subtração
jnz nsub
CALL subt           ;chama a subtracao
nsub:

CMP CH,"*"         ;inicia para multiplicação
jnz nmult
CALL mult          ;chama a multiplicação multiplicacao
nmult: 

CMP CH,"/"         ;incia para divisao
jnz ndiv
CALL divi          ;chama a divisao
ndiv:

print:
CALL printar ;chama para printar

Saida:
MOV AH,4ch      ;encerra o programa
INT 21h

erro:
MOV AH,09h
LEA DX,error ;printa a frase avisando o erro 
INT 21h
jmp inicio

main endp 

soma proc   ; procedimento da soma

    ADD bh,bl
    MOV cl,bh ;armazena em cl
    MOV bl,"+" ;printa o sinal
    jmp print ;printa o valor

soma endp

subt proc  ; procedimento da subtracao

    SUB bh,bl
    MOV cl,bh
    MOV bl,"+"
    jmp print ;printa o numero
   

subt endp

mult proc  ; procedimento da multiplicacao

    
    XOR  CL,CL         ; zera o cl
    MULTI:                       
    SHR  BH,1   ; deslocamento para direita
    JNC BIT_ZERO_MUL         
    ADD  CL,BL              ; add bl em cl
    BIT_ZERO_MUL:            
    SHL  BL,1             ; deslocamento para esquerda (multiplica)
    CMP  BH,0                
    JNE MULTI               ;   - Repete até que todos os digitos do multiplicador sejam percorridos
    MOV  BH ,CL          
    mov bl,"+"  
    jmp print                    ; pula para printar   

mult endp

divi proc
    XOR  CL,CL                 ;zera o cl
    XOR  DX,DX
    MOV  CH,BL                 ;        DIVISÃO        ;   CH = Dividendo / BH = Divisor  
    MOV  AH,8                 
    DIVIS:                       
    ROL  CX,1              ; rotacao para esquerda (divide)
    CMP  CL,BH             ;subtrai bh de cl
    JL  NSUB_DIV          ;    Se não, não subtrai e DH fica 0
    SUB  CL,BH             ;  
    MOV  DH,80H            ;   repete 8 vezes
    NSUB_DIV:              
    ROL  DX,1          
    DEC  AH            
    JNZ DIVIS           
    MOV  BH,DL               
    MOV  BL,CL                   
    mov bl,"+"                          
    jmp print                           

divi endp

printar proc

    XOR CH,CH              ;zera ch
    MOV AX,CX
    MOV CH,10
    DIV CH           ;al = cosciente ah = resto
    
    MOV CL,AL   ;cl com cosciente
    MOV CH,AH   ;ch com resto

    MOV AH,09h
    LEA DX,result         ;printa o resultado
    INT 21h

    MOV AH,02h         ;printa o sinal do numero
    MOV DL,BL 
    int 21h

    MOV AH,02h          ;printa o cosciente
    OR CL,30h            ;transforma o numeral em caractere
    MOV DL,CL               ;printa o resultado
    INT 21h

    MOV AH,02h             ;printa o resto
    OR CH,30h         ;transforma o numeral em caractere
    MOV DL,CH             ;printa o resultado
    INT 21h
    
    jmp Saida            ; pula para o fim do programa
printar endp

end main 