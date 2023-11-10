.eqv rcvr_ctrl 0xffff0000
.eqv rcvr_data 0xffff0004
.eqv trsmttr_ctrl 0xffff0008
.eqv trsmttr_data 0xffff000c

.data
	str_padrao: .asciiz "VIA-shell>> "	# String padr�o a ser exibida no MMIO
	barra_n: .byte 10					# Valor equivalente na tabela ASCII da quebra de linha (\n)
	terminal_cmd: .space 100			# Espa�o/Vari�vel para armazenar o que � digitado pelo usu�rio no MMIO
	
	str_cmd_ad_m: .asciiz "ad_morador-"		# String de comando para adicionar morador
	str_cmd_rm_m: .asciiz "rm_morador-"		# String de comando para remover morador
	str_cmd_ad_a: .asciiz "ad_auto-"		# String de comando para adicionar automovel
	str_cmd_rm_a: .asciiz "rm_auto-"		# String de comando para remover automovel
	str_cmd_lp_ap: .asciiz "limpar_ap-"		# String de comando para limpar apartamento
	str_cmd_if_ap: .asciiz "info_ap-"		# String de comando para informa��es de AP especifico
	str_cmd_if_g: .asciiz "info_geral"		# String de comando para informa��es dos APs em geral
	str_cmd_s: .asciiz "salvar"				# String de comando para salvar as infos num arquivo
	str_cmd_r: .asciiz "recarregar"			# String de comando para recarregar as infos do arquivo
	str_cmd_f: .asciiz "formatar"			# String de comando para formatar o arquivo
	msg_c_v: .asciiz "Comando Valido"		# String usada apenas para testes de comandos v�lidos digitados no MMIO
	msg_c_i: .asciiz "Comando Invalido"		# String usada apenas para testes de comandos inv�lidos digitados no MMIO

.text
main:
	la $s0, msg_c_v					# L� o endere�o da string teste de comando v�lido
	la $s1, msg_c_i					# L� o endere�o da string teste de comando inv�lido
	la $a1, str_padrao				# L� o endere�o da string padr�o a ser exibida no MMIO
	jal shell_str_loop				# Pula para a fun��o que escreve a string padr�o no MMIO e volta
	la $a1, terminal_cmd			# L� o endere�o da vari�vel que armazena o que foi digitado no MMIO
	j rcvr_loop						# Pula para o loop que aguarda as inser��es no MMIO
	
# Fun��o que compara strings para ver se s�o iguais
compara_str:
	lb $t0, 0($a0)					# L� o byte da string 1
	lb $t1, 0($a1)					# L� o byte da string 2
	bne $t0, $t1, str_diferente		# Caso sejam diferentes, pula pra fun��o que lida com isso
	beq $t0, $0, filtro_str0		# Caso a string 1 acabe, vai para o filtro que verifica se a string 2 acabou tamb�m.
	beq $t1, $0, filtro_str1		# Caso a string 2 acabe, vai para o filtro que verifica se a string 1 acabou tamb�m.
	addi $a0, $a0, 1				# Adiciona 1 ao endere�o da string 1 para ir para o pr�ximo caractere
	addi $a1, $a1, 1				# Adiciona 1 ao endere�o da string 2 para ir para o pr�ximo caractere
	j compara_str					# Jump para continuar o loop

# Fun��o que trata as strings caso sejam diferentes
str_diferente:
	addi $v0, $0, 1					# Retorna 1 em v0
	jr $ra							# Volta a execu��o do topo da pilha
	
# Fun��o que trata as strings caso sejam iguais
str_igual:
	move $v0, $0					# Retorna 0 em v0
	jr $ra							# Volta a execu��o do topo da pilha

# Filtro da string 1
filtro_str0:
	beq $t1, $0, str_igual			# Caso a string 2 tenha terminado tamb�m � porque s�o iguais, da� vai para fun��o correspondente
	j str_diferente					# Caso n�o, vai para fun��o de strings diferentes

# Filtro da string 2	
filtro_str1:
	beq $t0, $0, str_igual			# Caso a string 1 tenha terminado tamb�m � porque s�o iguais, da� vai para fun��o correspondente
	j str_diferente					# Caso n�o, vai para fun��o de strings diferentes
	
# Fun��o que escreve a string padr�o do shell a ser exibinda no MMIO toda vez h� quebra de linha (e na primeira execu��o tamb�m)
shell_str_loop:
	lw $t0, trsmttr_ctrl		# L� o conteudo escrito no transmitter control no reg t0		
    andi $t1, $t0, 1        	# Faz a opera��o AND entre o valor contido no reg t0 e 1 a fim de isolar o �ltimo bit (bit "pronto")       		
    beq $t1, $zero, shell_str_loop		# Caso seja 0, o transmissor n�o est� pronto para receber valores: continua o loop
	lb $t2, 0($a1)						# Carrega um byte da string padr�o a ser impressa no MMIO
	beq $t2, $zero, go_back				# Caso seja 0: a string terminou, vai para fun��o que volta pra main
	sb $t2, trsmttr_data				# Caso n�o seja: escreve o byte no transmitter do MMIO
	addi $a1, $a1, 1					# Soma 1 ao endere�o da string padr�o para ir para o pr�ximo byte a ser escrito
	j shell_str_loop					# Jump para continuar o loop
	
# Fun��o auxiliar para voltar pra main (no momento s� serve pra isso)
go_back:
	jr $ra						# Pula para o topo da pilha de execu��o
	
# Fun��o que faz o loop do receiver (recebendo o que foi digitado pelo usu�rio no MMIO)
rcvr_loop:	
    lw $t0, rcvr_ctrl				# L� o conteudo escrito no receiver control no reg t0			          
    andi $t1, $t0, 1            	# Faz a opera��o AND entre o valor contido no reg t0 e 1 a fim de isolar o �ltimo bit (bit "pronto")	
    beq $t1, $zero, rcvr_loop		# Caso seja 0, n�o est� pronto: o caractere ainda n�o foi completamente lido no Receiver Data
    lb $a0, rcvr_data				# Caso seja 1, est� pronto: aqui o caractere escrito no terminal � lido no Receiver Data
    sb $a0, 0($a1)					# Guarda o caractere lido no espa�o de mem�ria "terminal_cmd" que ser� usado para verificar se o comando escrito � aceito
    lb $t0, barra_n					# L� o valor do "\n" (10 na tabela ASCII) para saber se o usu�rio deu um "enter"
    beq $a0, $t0, verifica_cmds		# Caso o usu�rio d� "enter" vai para fun��o que verifica se o comando � v�lido
    j trsmttr_loop					# Pula para fun��o que faz o loop do transmitter (para escrever no MMIO o que foi digitado)

# Fun��o que quebra a linha no display do MMIO
quebra_linha:
	lw $t0, trsmttr_ctrl			# L� o conteudo escrito no transmitter control no reg t0		
    andi $t1, $t0, 1               	# Faz a opera��o AND entre o valor contido no reg t0 e 1 a fim de isolar o �ltimo bit (bit "pronto") 
    beq $t1, $zero, quebra_linha    # Caso seja 0, o transmissor n�o est� pronto para receber valores: continua o loop
	lb $t0, barra_n					# L� o valor do "\n" (10 na tabela ASCII) para inserir no display do MMIO
	sb $t0, trsmttr_data			# Escreve o "\n" ("enter") no display do MMIO
	jr $ra							# Pula para o topo da pilha de execu��o

# Fun��o que faz o loop do transmitter (para escrever no MMIO o que foi digitado)
trsmttr_loop:
    lw $t0, trsmttr_ctrl			# L� o conteudo escrito no transmitter control no reg t0		
    andi $t1, $t0, 1               	# Faz a opera��o AND entre o valor contido no reg t0 e 1 a fim de isolar o �ltimo bit (bit "pronto")	
    beq $t1, $zero, trsmttr_loop	# Caso seja 0, o transmissor n�o est� pronto para receber valores: continua o loop
    sb $a0, trsmttr_data			# Escreve o caractere no display do MMIO
    addi $a1, $a1, 1				# Soma 1 ao endere�o do espa�o de mem�ria "terminal_cmd" (usado para guardar o que usu�rio digitou)
    j rcvr_loop						# Pula para fun��o que faz o loop do receiver (para ler o pr�ximo caractere que foi digitado)
    
# Fun��o que verifica se o comando digitado � v�lido    
verifica_cmds:
	jal quebra_linha				# Jump  para fun��o que quebra linha no display do MMIO
	
	sb $0, 0($a1)					# Subistitui o ultimo caractere digitado no MMIO ("\n") por 0, afim de determinar o fim do comando
	
	la $a0, str_cmd_ad_m			# L� o endere�o da string de comando para adicionar morador
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_ad_m			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de adicionar morador, dai pula para fun��o respons�vel
	
	la $a0, str_cmd_rm_m			# L� o endere�o da string de comando para remover morador
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_rm_m			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de remover morador, dai pula para fun��o respons�vel
	
	la $a0, str_cmd_ad_a			# L� o endere�o da string de comando para adicionar automovel
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_ad_a			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de adicionar automovel, dai pula para fun��o respons�vel
	
	la $a0, str_cmd_rm_a			# L� o endere�o da string de comando para remover automovel
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_rm_a			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de remover automovel, dai pula para fun��o respons�vel
	
	la $a0, str_cmd_lp_ap			# L� o endere�o da string de comando para limpar apartamento
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_lp_ap			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de limpar apartamento, dai pula para fun��o respons�vel
	
	la $a0, str_cmd_if_ap			# L� o endere�o da string de comando para informa��es de AP especifico
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_if_ap			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de informa��es de AP especifico, dai pula para fun��o respons�vel
	
	la $a0, str_cmd_if_g			# L� o endere�o da string de comando para informa��es dos APs em geral
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_if_g			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de informa��es dos APs em geral, dai pula para fun��o respons�vel
	
	la $a0, str_cmd_s				# L� o endere�o da string de comando para salvar as infos num arquivo
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_s				# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de salvar as infos num arquivo, dai pula para fun��o respons�vel
	
	la $a0, str_cmd_r				# L� o endere�o da string de comando para recarregar as infos do arquivo
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_r				# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de recarregar as infos do arquivo, dai pula para fun��o respons�vel
	
	la $a0, str_cmd_f				# L� o endere�o da string de comando para formatar o arquivo
	la $a1, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_f				# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de formatar o arquivo, dai pula para fun��o respons�vel
	
	j cmd_invalido					# Caso n�o entre em nenhum dos branchs significa que o comando digitado � inv�lido, da� pula para fun��o que escreve "Comando Inv�lido" no display MMIO
	
# Fun��o de adicionar morador	
cmd_ad_m:
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 11				# Soma 11 ao endere�o afim de ir para onde come�a o numero do AP 
	addi $a1, $a0, 3				# Soma mais 2 aos 11 somados afim de ir para onde come�a o nome do morador
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de remover morador	
cmd_rm_m:
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 11				# Soma 11 ao endere�o afim de ir para onde come�a o numero do AP 
	addi $a1, $a0, 3				# Soma mais 3 aos 11 somados afim de ir para onde come�a o nome do morador
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de adicionar autom�vel	
cmd_ad_a:
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 8				# Soma 8 ao endere�o afim de ir para onde come�a o numero do AP 
	addi $a1, $a0, 3				# Somando 3 � onde come�a o tipo do autom�vel
	addi $a2, $a1, 2				# Somando mais 2 � onde come�a o tipo do autom�vel
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever. Lembrar que ainda � preciso chegar na cor do auto
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de remover autom�vel	
cmd_rm_a:
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 8				# Soma 8 ao endere�o afim de ir para onde come�a o numero do AP 
	addi $a1, $a0, 3				# Somando 3 � onde come�a o modelo do autom�vel
	addi $a2, $a1, 2				# Somando mais 2 � onde come�a o tipo do autom�vel
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever. Lembrar que ainda � preciso chegar na cor do auto
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de limpar AP
cmd_lp_ap:
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 10				# Soma 10 ao endere�o afim de ir para onde come�a o numero do AP 
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de informa��es de um AP especifico
cmd_if_ap:
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 8				# Soma 8 ao endere�o afim de ir para onde come�a o numero do AP 
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de informa��es gerais dos APs	
cmd_if_g:
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de salvar no arquivo
cmd_s:
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de recarregar o arquivo	
cmd_r:
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de formatar o arquivo	
cmd_f:
	
	# Espa�o para colocar a fun��o ou um jump para a fun��o, whatever
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o que escreve "Comando Inv�lido" no display MMIO
cmd_invalido:
	lw $t0, trsmttr_ctrl			# L� o conteudo escrito no transmitter control no reg t0							
    andi $t1, $t0, 1        		# Faz a opera��o AND entre o valor contido no reg t0 e 1 a fim de isolar o �ltimo bit (bit "pronto")       		               		
    beq $t1, $zero, cmd_invalido	# Caso seja 0, o transmissor n�o est� pronto para receber valores: continua o loop
	lb $t2, 0($s1)					# Carrega um byte da string "Comando Invalido" para ser impresso no MMIO					
	beq $t2, $zero, fim_leitura		# Caso o byte carregado seja 0, significa que a string terminou, da� vai para fun��o que quebra linha e pula para a main
	sb $t2, trsmttr_data			# Escreve o caractere no display do MMIO	
	addi $s1, $s1, 1				# Soma 1 ao endere�o da string "Comando Invalido" afim de ir para o proximo byte
	j cmd_invalido					# Jump para continuar o loop

# Fun��o auxiliar ao fim de leitura de um comando
fim_leitura:
	jal quebra_linha				# Pula para fun��o quebra_linha e volta
	j main							# Pula para main para continuar o loop geral do programa
					

