# Projeto 1 VA Arquitetura e Organiza��o de Computadores - 2022.1
# Alunos: Vin�cius Bezerra, Irlan Farias, Apolo Albuquerque, jo�o vitor castro
# Descri��o do arquivo: C�digo .asm da quest�o 3

.data
    texto: .asciiz "O fibonacci do seu n�mero � de: "
.text

    li $v0, 5						#Chama fun��o de ler inteiro
    syscall						#Executa fun��o

    move $a0, $v0					#Copia o valor de $v0 para $a0
    jal fibonacci					#Chama o procedimento fibonacci
    move $s0, $v0					#Copia o valor de $v0 para $s0
    
    li $v0, 4						#Chama a fun��o de imprimir string
    la $a0, texto					#Carrega o endere�o de 'texto' em $a0
    syscall						#Executa a fun��o
    
    li $v0, 1						#Chama a fun��o imprimir inteiro
    la $a0, ($s0)					#Carrega o endere�o de $s0 em $$a0
    syscall						#Executa a fun��o

    jal sair						#Chama o procedimento sair
    
fibonacci:
    addi $sp, $sp, -12					#Aloca 3 espa�os na pilha
    sw $ra, 8($sp)					#Armazena $ra na pilha
    sw $t1, 4($sp)					#Armazena $t1 na pilha
    sw $t2, 0($sp)					#Armazena $t2 na pilha
    move $t1, $a0					#Copia o valor de $a0 para $t1

    li $v0, 1 						#Carrega o valor 1 em $v0 de forma que F(1) = 1 seja somado aos proximos F(n....1)
    
    ble $t1, 2, fibonacciaux 					#Se o valor em $t1 for menor que 2, entra no procedimento sairf
		
    addi $t3, $t1, -1					#Soma $t1 + (-1) e guarda em $t3 / F(n-1)
    la $a0, ($t3) 					#Carrega o endere�o de $t3 em $a0
    
    jal fibonacci					#Recurss�o
    
    move $t2, $v0 					#Copia o valor de $v0 para $t2
    
    addi $t3, $t1, -2					#Soma $t1 + (-2) e guarda em $t3 / F(n-2)
    la $a0, ($t3)					#Carrega o endere�o de $t3 em $a0
    
    jal fibonacci					#Recurss�o

    add $v0, $t2, $v0					#Soma $t2 + $v0 e guarda em $v0 / F(n-1) + F(n-2)

fibonacciaux:

    lw $ra, 8($sp)					#Recupera na pilha			
    lw $t1, 4($sp)					#Recupera na pilha
    lw $t2, 0($sp)					#Recupera na pilha
    addi $sp, $sp, 12					#Remove o espa�o que foi alocado na pilha
    jr $ra						#Retorna para quem chamou o procedimento
    
sair:
    li $v0, 10						#Chama fun��o sair
    syscall						#Executa fun��o

