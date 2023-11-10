# Projeto 1 VA Arquitetura e Organiza��o de Computadores - 2022.1
# Alunos: Vin�cius Bezerra, Irlan Farias, Apolo Albuquerque, jo�o vitor castro
# Descri��o do arquivo: C�digo .asm da quest�o 4 letra b

.data
# Os tipos de dados abaixo foram usados apenas como teste.
# � sabido que os endere�os de source e destination podem se interseccionar em determinado ponto ou at� mesmo serem os mesmos.
# Mas isso n�o interfere no funcionamento do programa, basta testar com diferentes tipos.

	num: .word 2			# Quantidade de bits a serem copiados (para testar bastar colocar qualquer valor aqui)
	source: .asciiz "Apolo"		# Fonte de onde ser�o tirados os bits (.asciiz foi usado somente como teste, qualquer tipo de dado pode ser colocado aqui)
	destination: .space 10		# Bloco de mem�ria destino para os bits copiados (pode colocar qualquer tamanho para o .space)
.text
main:
	la $a0, destination		# Lendo o endere�o do bloco de mem�ria destino
	la $a1, source			# Lendo o endere�o do local de fonte dos bits a serem copiados
	lw $a2, num			# Lendo a quantidade de bits a serem copiadas
	
	add $t1, $0, $0			# Por seguran�a, atribuindo o valor 0 ao reg t1 que servir� como contador
	
	j memcpy			# Jump para a fun��o

#Fun��o solicitada na quest�o
memcpy:
	beq $t1, $a2, fim		# Caso o contador chegue ao valor atribuido em num, pulamos para o fim do programa
	lb $t0, 0($a1)			# L� o byte no endere�o base da source (a ser incrementado abaixo)
	sb $t0, 0($a0)			# Armazena o byte lido no endere�o base de destination (a ser incrementado abaixo)
	addi $a1, $a1, 1		# Incrementa em 1 o endere�o base da source para ir para ler o pr�ximo byte
	addi $a0, $a0, 1		# Incrementa em 1 o endere�o base de destination para escrever no pr�ximo byte 
	addi $t1, $t1, 1		# Incrementa em 1 o contador
	j memcpy			# Jump para continuar o loop

# Fun��o que termina o programa, como foi solicitado na quest�o que o reg v0 recebesse o par�metro destination
# optei por n�o finalizar o programa via c�digo de servi�o, visto que o reg v0 � o mesmo usado nos syscall's
fim:
	la $v0, destination		# Salva o endere�o do par�metro destination no reg v0


	
