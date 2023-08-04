# Projeto 1 VA Arquitetura e Organiza��o de Computadores - 2022.1
# Alunos: Vin�cius Bezerra, Irlan Farias, Apolo Albuquerque, jo�o vitor castro
# Descri��o do arquivo: C�digo .asm da quest�o 1
# Substituir caracteres em uma string em MIPS Assembly

.data

mensagem1: .asciiz "Digite uma string: "
string: .space 100

mensagem2: .asciiz "Digite o caractere a ser substitu�do (C1): "
caractere1: .byte 0

mensagem3: .asciiz "Digite o caractere substituto (C2): "
caractere2: .byte 0

mensagem4: .asciiz "A string com as substitui��es: "

linebreak: .asciiz "\n"

.text
    
    la $a0, mensagem1 					#Carrega o endere�o de 'mensagem1' em $a0
    jal imprime_string 					#Chama o procedimento imprime_string

    #i. Recebe uma string (string) do usu�rio
    
    li $v0, 8						#Chama a fun��o ler string
    la $a0, string					#Carrega o endere�o de 'string' em a0
    li $a1, 100						#Par�metro da fun��o ler string, quantidade m�xima de bytes que ser�o lidos
    syscall						#Executa a fun��o

    la $a0, mensagem2					#Carrega o endere�o de 'mensagem2' em $a0
    jal imprime_string 					#Chama o procedimento imprime_string

    #ii. Recebe um char (caractere1) do usu�rio

    li $v0, 12						#Chama a fun��o ler caractere
    syscall						#Executa a fun��o	
    sb $v0, caractere1					#Guarda o caractere de 'caractere1' em $v0

    jal quebralinha     				#Chama o procedimento de quebra de linha (Em console)

    la $a0, mensagem3					#Carrega o endere�o de 'mensagem3' em $a0
    jal imprime_string 					#Chama o procedimento imprime_string

    #iii. Recebe um char (caractere2) do usu�rio

    li $v0, 12						#Chama a fun��o ler caractere
    syscall						#Executa a fun��o	
    sb $v0, caractere2					#Guarda o caractere de 'caractere2' em $v0

    jal quebralinha     				#Chama o procedimento de quebra de linha (Em console)

    #iv. Substituir caractere 1 por caractere 2 na string
    #v. Imprime a nova string com os caracteres substitu�dos
    
    la $s0, string        				#Carrega o endere�o de 'string' em $s0
    lb $s1, caractere1    				#Carrega o caractere de 'caractere1' em $s1
    lb $s2, caractere2    				#Carrega o caractere de 'caractere2' em $s2

    jal loop						#Chama o procedimento que vai realizar a troca de caracteres
    
le_caractere:
    li $v0, 12						#Chama a fun��o ler caractere
    syscall						#Executa a fun��o	
    sb $v0, caractere1					#Guarda o caractere de 'caractere1' em $v0

imprime_string:						#Recebe a string a ser lida em $a0
    li $v0, 4						#Chama a fun��o imprimir string
    syscall						#Executa a fun��o
    jr $ra						#Retorna pra quem chamou o procedimento

quebralinha:							
    li $v0, 4						#Chama a fun��o imprimir string
    la $a0, linebreak					#Carrega o endere�o de 'linebreak' em $a0
    syscall						#Executa a fun��o
    jr $ra						#Retorna pra quem chamou o procedimento

loop:
    lb $t0, 0($s0)        				#Carrega o pr�ximo caractere da string em $t0
    beq $t0, $0, fim      				#Se o caractere for nulo, encerra o loop
    bne $t0, $s1, next    				#Se o caractere n�o for igual ao caractere 1, ir para o pr�ximo
    sb $s2, 0($s0)        				#Substitui o caractere 1 pelo caractere 2

next:
    addi $s0, $s0, 1      				#Avan�a para o pr�ximo caractere
    j loop						#Chama o procedimento que vai continuar realizando a troca de caracteres

fim:
    la $a0, string					#Carrega o endere�o 'string' em $a0
    jal imprime_string					#Chama o procedimento que vai imprimir a string

    li $v0, 10						#Chama a fun��o sair
    syscall						#Executa a fun��o
