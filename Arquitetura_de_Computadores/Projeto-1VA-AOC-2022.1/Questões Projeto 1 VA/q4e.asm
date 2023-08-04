# Projeto 1 VA Arquitetura e Organiza��o de Computadores - 2022.1
# Alunos: Vin�cius Bezerra, Irlan Farias, Apolo Albuquerque, jo�o vitor castro
# Descri��o do arquivo: C�digo .asm da quest�o 4 letra e

# Os tamanos do .spaces usados aqui foram arbitr�rios, podem ser mudados para testes
# Os .asciiz foram usados aqui apenas para testes, tamb�m podem ser alterados
.data
	destination: .space 20			# Espa�o reservado na mem�ria para string destino (usando .space, garantimos que n�o ser� sobreposta)
	source: .space 20			# Espa�o reservado na mem�ria para string fonte (usando .space, garantimos que n�o ser� sobreposta)
	
	str_test_dest: .asciiz "Apolo "		# String destino para teste
	str_test_src: .asciiz "ama MIPS."	# String fonte para teste
.text
main:
	la $a0, str_test_dest			# Lendo o endere�o da string destino de teste para copi�-la para o space reservado
	la $a1, destination			# Lendo o endere�o de destino reservado
	jal copia_string			# Jump and link para a fun��o que copia a string teste para o espa�o reservado (teste)
	
	la $a0, str_test_src			# Lendo o endere�o da string fonte de teste para copi�-la para o space reservado
	la $a1, source				# Lendo o endere�o de fonte reservado
	jal copia_string			# Jump and link para a fun��o que copia a string teste para o espa�o reservado (teste)
	
	la $a0, destination			# Lendo o endere�o de destino reservado
	la $a1, source				# Lendo o endere�o de fonte reservado
	
	j acha_final				# Jump para fun��o que encontra o final (\0) da string destino
	
strcat:
	lb $t0, 0($a1)				# L� o byte no endere�o base da fonte (a ser incrementado abaixo)
	beq $t0, $0, fim			# Caso seja 0 (chegou ao final), pular para a fun��o que finaliza o programa
	sb $t0, 0($a0)				# Caso n�o seja, armazena o byte exatamente, onde foi encontrado na fun��o anterior, no final da string destino
	addi $a1, $a1, 1			# Incrementa em 1 o endere�o base da fonte para ler o pr�ximo byte
	addi $a0, $a0, 1			# Incrementa em 1 o endere�o base do destino para escrever no pr�ximo byte
	j strcat				# Jump para continuar 

# Fun��o que encontra o final (\0) da string destino, o objetivo aqui � saber onde come�ar a escrever o conte�do da string fonte
acha_final:
	lb $t0, 0($a0)				# L� o byte no endere�o base do destino (a ser incrementado abaixo)
	beq $t0, $0, strcat			# Caso seja 0 (chegou ao final), pular para a fun��o que concatena de fato
	addi $a0, $a0, 1			# Caso n�o seja, incrementa mais um no endere�o base
	j acha_final				# Jump para continuar o loop
	
# Fun��o que copia as strings de teste para os espa�os reservados (feita somente para testar o programa)
copia_string:
	lb $t0, 0($a0)				# L� o byte no endere�o base da string (a ser incrementado abaixo)
	beq $t0, $0, fim_copia_string		# Caso seja 0 (chegou ao final), pular para a fun��o que volta para main
	sb $t0, 0($a1)				# Caso n�o, armazena o byte no espa�o reservado em mem�ria para string
	addi $a0, $a0, 1			# Incrementa em 1 o endere�o base da string para ler o pr�ximo byte
	addi $a1, $a1, 1			# Incrementa em 1 o endere�o base do espa�o reservado para escrever no pr�ximo byte
	j copia_string				# Jump para continuar o loop

# Fun��o de aux�lio de copia_string para voltar para onde foi linkado no jal
fim_copia_string:
	jr $ra					# O reg $ra salva o endere�o de onde estavamos ao fazer o jal, aqui fazemos um jump register para l�

# Fun��o que termina o programa, como foi solicitado na quest�o que o reg v0 recebesse o par�metro destination
# optei por n�o finalizar o programa via c�digo de servi�o, visto que o reg v0 � o mesmo usado nos syscall's
fim:
	la $v0, destination			# Salva o endere�o do par�metro destination no reg v0
	
	
	
	
