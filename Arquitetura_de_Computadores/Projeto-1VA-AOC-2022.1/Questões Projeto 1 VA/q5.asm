# Projeto 1 VA Arquitetura e Organiza��o de Computadores - 2022.1
# Alunos: Vin�cius Bezerra, Irlan Farias, Apolo Albuquerque, jo�o vitor castro
# Descri��o do arquivo: C�digo .asm da quest�o 5

.eqv rec_ctrl 0xffff0000
.eqv rec_data 0xffff0004
.eqv tran_ctrl 0xffff0008
.eqv tran_data 0xffff000c

.text
receiver_loop:	
    lw $t0, rec_ctrl			# Armazena o valor contido no endere�o representado por "rec_ctrl" em t0           
    
    andi $t1, $t0, 1            	# Faz a opera��o AND entre o valor contido no reg t0 e 1 a fim de isolar o �ltimo bit (bit "pronto")
    beq $t1, $zero, receiver_loop	# Caso seja 0, n�o est� pronto: o caractere ainda n�o foi completamente lido no Receiver Data
    
    lb $a0, rec_data			# Caso seja 1, est� pronto: aqui o caractere escrito no terminal � lido no Receiver Data
    
    j transmitter_loop			# Jump para o loop do Transmitter	

transmitter_loop:
    lw $t0, tran_ctrl			# Armazena o valor contido no endere�o representado por "tran_ctrl" em t0 
    
    andi $t1, $t0, 1               	# Faz a opera��o AND entre o valor contido no reg t0 e 1 a fim de isolar o �ltimo bit (bit "pronto")
    beq $t1, $zero, transmitter_loop   	# Caso seja 0, n�o est� pronto: o caractere ainda n�o foi completamente escrito no Transmitter Data
    
    sb $a0, tran_data			# Caso seja 1, est� pronto: aqui o caractere lido no terminal � escrito no Transmitter Data
    
    j receiver_loop			# Jump para o loop do Receiver (para ler o pr�ximo caractere escrito no terminal)
