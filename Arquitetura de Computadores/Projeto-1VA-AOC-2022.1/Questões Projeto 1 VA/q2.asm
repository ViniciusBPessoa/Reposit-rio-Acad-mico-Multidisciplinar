# Projeto 1 VA Arquitetura e Organiza��o de Computadores - 2022.1
# Alunos: Vin�cius Bezerra, Irlan Farias, Apolo Albuquerque, jo�o vitor castro
# Descri��o do arquivo: C�digo .asm da quest�o 2

.data
	string: .space 100 		# Constante para armazenar a string inserida pelo usu�rio
	quebra_linha: .ascii "\n" 	# Constante que representa o valor de quebra de linha (caso o usu�rio d� enter)
.text
main:
	li $v0, 8 		# (8) C�digo de servi�o para ler strings no console
    	la $a0, string 		# Indicando o endere�o onde a string lida ser� armazenada
    	li $a1, 100 		# Reservando espa�o de 99 caracteres para string a ser inserida pelo usu�rio
    	lw $a2, quebra_linha	# Armazenando o valor de "\n" (enter)
    	syscall			# Chamada ao console (sistema)
    	
    	li $v0, 0 		# Limpa o valor que estava em $v0 para que o registrador possa ser utilizado na fun��o len
    	
    	j len			# Jump (pula) para a fun��o que conta o tamanho da string

#Fun��o que conta o tamanho da string 	
len:
	lb $t0, 0($a0)      	# Lendo o valor "cabe�a" da string 
    	beq $t0, $a2, fim	# Caso o usu�rio tenha dado enter ao terminar de digitar, o �ltimo valor da string ser� o "\n"
    	beq $t0, $0, fim	# Caso o usu�rio termine de usar todos os 99 caracteres dispon�veis, o �ltimo valor ser� o "\0"
    	addi $v0, $v0, 1	# Caso passe dos dois branch if equal, conta-se mais um para o tamanho da string
    	addi $a0, $a0, 1	# Adiciona mais um ao endere�o base da string para ir para o pr�ximo caractere
    	j len			# Jump para continuar o loop da fun��o
    	
#Fun��o que � acionada quando termina-se de ler a string
fim:
	add $s0, $v0, $0 	# (Boa pr�tica) Salvar o retorno de uma fun��o em um registrador seguro
	addi $v0, $0, 1		# (1) C�digo de servi�o para printar inteiros no console
	add $a0, $s0, $0	# Adiciona o valor a ser printado
	syscall			# Chamada ao console (sistema)
	
	addi $v0, $0, 10	# (10) C�digo de servi�o para encerrar o programa
	syscall			# Chamada ao console (sistema)
