# Projeto 1 VA Arquitetura e Organiza��o de Computadores - 2022.1
# Alunos: Vin�cius Bezerra, Irlan Farias, Apolo Albuquerque, jo�o vitor castro
# Descri��o do arquivo: C�digo referente ao  Projeto (60% da nota) 

.data
	str_padrao: .asciiz "VIA-shell>> "	# String padr�o a ser exibida no MMIO
	terminal_cmd: .space 100			# carrega a msg que sera escrita pelo usuario
	
	
	
	str_cmd_ad_m: .asciiz "ad_morador"		# String de comando para adicionar morador
	str_cmd_rm_m: .asciiz "rm_morador"		# String de comando para remover morador
	str_cmd_ad_a: .asciiz "ad_auto"			# String de comando para adicionar automovel
	str_cmd_rm_a: .asciiz "rm_auto"			# String de comando para remover automovel
	str_cmd_lp_ap: .asciiz "limpar_ap"		# String de comando para limpar apartamento
	str_cmd_if_ap: .asciiz "info_ap"			# String de comando para informa��es de AP especifico
	str_cmd_if_g: .asciiz "info_geral"			# String de comando para informa��es dos APs em geral
	str_cmd_s: .asciiz "salvar"				# String de comando para salvar as infos num arquivo
	str_cmd_r: .asciiz "recarregar"			# String de comando para recarregar as infos do arquivo
	str_cmd_f: .asciiz "formatar"			# String de comando para formatar o arquivo
	msg_c_v: .asciiz "Comando Valido\n"		# String usada apenas para testes de comandos v�lidos digitados no MMIO
	msg_c_i: .asciiz "Comando Invalido\n"		# String usada apenas para testes de comandos inv�lidos digitados no MMIO
	
	msg_e_n_m_m:  .asciiz "Falha: AP com numero max de moradores\n"  	# carrega a string para a falha de maximo de jogadores
	msg_e_n_ap: .asciiz "Falha: AP invalido\n"  						# carrega a string para a falha de ap invalido
	msg_e_n_p_e: .asciiz "Falha: morador nao encontrado\n"  			# carrega a string para a falha de morador n�o encontrado
	msg_e_ap_s_n: .asciiz "Apartamento vazio\n"  					# carrega a string para a falha de �aprtamento vazio
	msg_e_au_s_n: .asciiz "Falha: tipo invalido\n"
	msg_e_au_s_n2: .asciiz "Falha: ap com numero max de automoveis\n"
	msg_e_au_s_n3: .asciiz "Falha: automovel n�o encontrado\n"
	
	quebra_linha: .asciiz "\n"  									# carrega o \n para pular linha
	msg_info_ap_spa: .asciiz "	"  								# carrega um espa�o 
	
########################################################################################################################
	# carregam-se todas as palavras auxiliares para prints
	
	msg_info_ap0: .asciiz "AP: "  
	msg_info_ap1: .asciiz "Moradores:"
	msg_info_ap2: .asciiz "Carro:"
	msg_info_ap3: .asciiz "Moto:"
	msg_info_ap4: .asciiz "Modelo: "
	msg_info_ap5: .asciiz "Cor: "

	msg_info_g1: .asciiz "N�o vazios: "
	msg_info_g2: .asciiz "Vazios:  "
########################################################################################################################
	apt_space: .space 7480  				#  espa�os dedicados para os apartamentos
 	localArquivo: .asciiz "C:/aps.txt"  			# local no computador onde o arquivo original se mantem


.text

awake:
         jal leArquivo                              # pula ate a fun��o qeu ira ler o aquivo
        addi $s2, $a1, 0                        # salva o space em s2
        j main
main:
	
  	li $v0, 4          				# carrega o c�digo do servi�o de impress�o de string
	la $a0, str_padrao       		# carrega o endere�o da mensagem
	syscall       				# chama o servi�o de impress�o de string

    	li $v0, 8          				# carrega o c�digo do servi�o de leitura de string
    	la $a0, terminal_cmd        		# carrega o endere�o da vari�vel para armazenar a string
    	li $a1, 100        				# define o tamanho m�ximo da string
   	syscall           				# chama o servi�o de leitura de string
   	
   	jal separador_comando
    	
    	j main


# Fun��o que compara strings para ver se s�o iguais
compara_str:  				# recebe em a1 a str do comando a ser verificada
	la $a0, terminal_cmd  		# carrega em $a0 a messagem escrita no termial
	addi $sp, $sp, -4 	 	# guarda o espa�o na memoria para salvar o ra
	sw $ra, 0($sp)  			# guarda o espa�o na memoria para salvar o ra
	jal strcmp  			# envia para o comparador de strings
	lw $ra, 0($sp)  			# guarda o espa�o na memoria para salvar o ra
	addi $sp, $sp, 4  		# guarda o espa�o na memoria para salvar o ra
	
	jr $ra					# retorna para Ra



separador_comando:			#  pega a string que foi digitada pelo ususario
	la $a0, terminal_cmd  		#  pega a string que foi digitada pelo ususario e carrega em a0
	move $t2, $a0			# move $a0 para $t2 para que o valor seja guardado
	
	loop_verificador_n:   #  verifica se o camando que o usuario escreveu continha ('-')
	
		lb $t3, 0($t2)  					# carrega a valor escrito na string sequencialmente a fim de buscar "-"
		beq $t3, 0, removedor_n 			# verifica se existe  um "-"
		addi $t2, $t2, 1  				# pula apara o proximo caractere
		j loop_verificador_n				# retorna ao loop
		
	removedor_n:  			#  caso o valor seja achado "-" o remove
		addi $t2, $t2, -1  	#  caso o valor seja achado "-" o remove
		sb $0, 0($t2) 	#  caso o valor seja achado "-" o remove
	
	loop_comparador_com:  # loop para isolar o comando dos itens a serem removidos ou inceridos 
	
		lb $t1, 0($a0)  				# carrega o que esta em a0 no tempo de execu��o para verificar se o - foi achada
		beq $t1, 45, com_enc  		# verifica se o - foi achado
		beq $t1, 0, cmd_n_enc 		# verifica se o usuario n dijitou o comando inteiro
		addi $a0, $a0, 1  			# adiciona 1 a a0 par apular para o proxim o caractere
		j loop_comparador_com  		# retorna ao loop
		
	com_enc:
		sb $0 0($a0)	
		j verifica_cmds1
	cmd_n_enc:
		j verifica_cmds2

# Fun��o que verifica se o comando digitado � v�lido    
verifica_cmds1:
	
	la $a1, str_cmd_ad_m				# L� o endere�o da string de comando para adicionar morador
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, 0, cmd_ad_m			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de adicionar morador, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_rm_m			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_rm_m			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de remover morador, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_ad_a			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	jal compara_str				# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_ad_a		# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de adicionar automovel, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_rm_a				# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio		
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_rm_a			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de remover automovel, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_lp_ap			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_lp_ap			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de limpar apartamento, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_if_ap			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio			
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_if_ap			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de informa��es de AP especifico, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_s			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio		
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_s				# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de salvar as infos num arquivo, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_r			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio	
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_r				# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de recarregar as infos do arquivo, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_f			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_f				# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de formatar o arquivo, dai pula para fun��o respons�vel
	
	j cmd_invalido					# Caso n�o entre em nenhum dos branchs significa que o comando digitado � inv�lido, da� pula para fun��o que escreve "Comando Inv�lido" no display MMIO

verifica_cmds2:
		
	la $a1, str_cmd_if_g			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio	
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_if_g			# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de informa��es dos APs em geral, dai pula para fun��o respons�vel
	
	
	la $a1, str_cmd_s			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio		
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_s				# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de salvar as infos num arquivo, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_r			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio	
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_r				# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de recarregar as infos do arquivo, dai pula para fun��o respons�vel
	
	la $a1, str_cmd_f			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	jal compara_str					# Pula para fun��o que compara strings e volta
	beq $v0, $0, cmd_f				# Caso $v0 volte da compara��o com valor 0 significa que o comando digitado � o de formatar o arquivo, dai pula para fun��o respons�vel
	
	j cmd_invalido					# Caso n�o entre em nenhum dos branchs significa que o comando digitado � inv�lido, da� pula para fun��o que escreve "Comando Inv�lido" no display MMIO

		
# Fun��o de adicionar morador	
cmd_ad_m:
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 11				# Soma 11 ao endere�o afim de ir para onde come�a o numero do AP 
        move $t1, $a0					#  ad_morador-02/0vini
        addi $t1, $t1, 2
        sb $0, 0($t1)
        addi $a1, $a0, 3				# Soma mais 2 aos 11 somados afim de ir para onde come�a o nome do morador
	
	# guarda o ra
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal inserirPessoa  # envia para inserir pessoa
	
	# recupera o ra
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
        		
inserirPessoa:  # vou considerar que o valor de $a0 apartamento e $a1 esta com o nome a ser incerrido: em $s2 esta a lista de itens em $s2 estara a posi��o inicial dos APs
# os possiveis erros est�o em $v0 sendo eles 1 ou 2, 1w = apartamento n�o encontrado
  
  addi $t7 , $s2, 0  # carrega a primeira posi��o do espa�o disponivel para o sistema de apartamneto
  addi $t2, $t7, 7480 # maior valor possivel  a ser escrito no sistema
  addi $t4, $a1, 0  #  salva o que esta em a1, para utilizar em algumas outras fun�oes
  
  # guarda todas as variaveis importantes para regata-los
  addi $sp, $sp, -16  
  sw $t7, 0($sp)
  sw $s2, 4($sp)
  sw $t4, 8($sp)
  sw $ra, 12($sp)
  
  jal verifica_andar
  
  # recupera todas as variaveis importantes para seus registradores
  lw $ra, 12($sp)
  lw $t4, 8($sp)
  lw $s2, 4($sp)
  lw $t7, 0($sp)
  addi $sp, $sp, -16 
  
  beq $v0, -1, main
  move $t7, $v0
  j ap_insere
  
  ap_insere:  								# se chegarmos aqui � porque o apartamento foi encontrado, agora vamos verificar se o ap pode receber mais uma pessoa
    
    addi $t7, $t7, 3 							# tendo recebi o apartamento vamos vasculhar jogando para a 1 posi��o das pessoas
    addi $t5, $0, 0 							# inicia meu contador de pessoas caso seja 5 o a paratamento est� cheio
    j vaga
    
    vaga:  									# inicia um loop que verifica vaga por vaga
      
      lb $t3, 0($t7)  							# carrega 1  caracter de de cada nome para saber se aquele ap esta disponivel
      beq $t3, 0, vaga_disponivel  					# pula para a area de escriata ja que a vaga esta disponivel
      addi $t7, $t7, 20  						# pula para o proximo nome a verificar
      addi $t5, $t5, 1  							# verifica se o total de pessoas daquele ap ja foi verificado
      beq $t5, 5, apt_cheio 				 		# caso todos os possiveis locais para incerir pessoas foram preenchidos
      j vaga  								# retorna ao loop

  vaga_disponivel:  # se chegarmos aqui � por que o nome pode ser incerido
    
    addi $a0, $t7, 0 # carrega em a0 o que devemos incerir no local do nome
    addi $a1, $t4, 0 # carrega o espa�o a ser incerido
    addi $t9, $ra, 0 # salva a posi��o original do arquivo
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
            
    jal strcpy  # copia a string no novo local controlando o numero de caracteres par aque o mesmo n�o utrapasse 19
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra # ja que a fun��o foi bem sucedida retorna ao inicio
    
    apt_cheio: # caso o apartamento esteja cheio retor na o erro 2
      la $a0, msg_e_n_m_m
      li $v0, 4
      syscall
      j main # acaba a fun��o


	
# Fun��o de remover morador	
cmd_rm_m:
	
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 11				# Soma 11 ao endere�o afim de ir para onde come�a o numero do AP 
        move $t1, $a0					#  ad_morador-02/0vini
        addi $t1, $t1, 2
        move $t2, $0
        sb $t2, 0($t1)
        addi $a1, $a0, 3				# Soma mais 2 aos 11 somados afim de ir para onde come�a o nome do morador
	
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal remover_pessoa
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
	remover_pessoa:  # deve receber em a0 o apartamento e em a1 o nome
  
  move $t1, $a1 # salva o nome da pessoa para utiliza��o futura
  move $a1, $s2 # recebe a posi��o inicial do meu space
  move $t9, $a0  # salva o apartamento para utiliza��o posterior
  
  # salva as variaveis utilizadas para evitar problemas 
  addi $sp, $sp, -12  # salva o espa�o em memoria par asalvar os registradores
  sw $t9, 8($sp) # salvando o apartamento na memoria
  sw $t1, 4($sp)  # salvando o nome da pessoa
  sw $ra, 0($sp)  # salvando o registrador de onde estavamos no codigo
    
  jal verifica_andar
  
  
  # carregha todas os registradores usadas
  lw $ra, 0($sp)  # resgatando o registrador de onde estavamos no codigo
  lw $t1, 4($sp)  # resgatando o nome da pessoa
  lw $t9, 8($sp)  # resgatando o apartamento na memoria
  addi $sp, $sp, 12  # resgatando o espa�o em memoria par asalvar os registradores
  
  beq $v0, -1, ap_n_encontrado  # verifica se o aptamento foi encontrado 
  addi $t2, $v0, 3  # adicionando 3 no ponteiro ele ira ate a posi��o do primeiro nome dos moradores
  addi $t3, $0, 1 # inicia um contador par asaber quantas pessoas foramverificadas
  j  remover_pessoa_ac  # se chegar aqui o anadar foi encontrado
  
  remover_pessoa_ac: #  inicializa a possivel remo��o do morador
    move $a0, $t2  # adiciona ao argumento a0 a posi��o que ele deve utilizar na busca peno nome usado no comando
    move $a1,  $t1  # adiciona ao argumento a1 a posi��o que ele deve utilizar na busca
    
    # salva as variaveis utilizadas para evitar problemas 
    addi $sp, $sp, -20  # libera espa�o na memoria para salvar os registradores antes da fun��o
    sw $t9, 16($sp)  # armazena o apartamento para verifica��o futura
    sw $t1, 12($sp)  # armazena o registrador com a posi��o do nome na fun��o ne memoria
    sw $t2, 8($sp)  # armazena o registrador com a posi��o do nome nos apartamentos
    sw $t3, 4($sp)  # armazena o registrador com a contagem de pessoas
    sw $ra, 0($sp)  # salvando o registrador de onde estavamos no codigo
    
    jal strcmp  # carregar a string a ser removida em a0 e em a1 o ponteiro no momento 
    
    #  recarrega as variaveis pos fun��o
    lw $ra, 0($sp) # recebendo o registrador de onde estavamos no codigo
    lw $t3, 4($sp)  # recebendo o registrador com a contagem de pessoas
    lw $t2, 8($sp)  # recebendo o registrador com a posi��o do nome nos apartamentos
    lw $t1, 12($sp)  # recebendo o registrador com a posi��o do nome na fun��o ne memoria
    lw $t9, 16($sp)  # resgatando o espa�o em memoria par asalvar os registradores
    addi $sp, $sp, 20  # recebendo o espa�o na memoria para salvar os registradores antes da fun��o
    
    addi $t3, $t3, 1  # adiciona um ao contador de pessoas verificadas
    beq $v0, 0, pessoa_encontrada  # verifica se o nome a ser removido � esse
    addi $t2, $t2, 20 # pula para o proximo nome
    beq $t3, 6, pessoa_n_enc  #  caso a pessoa n�o seja encontrada
    j remover_pessoa_ac  # retorna ao loop

  pessoa_n_enc:
    la $a0, msg_e_n_p_e
    li $v0, 4
    syscall
    j main # encerra a fun��o

  pessoa_encontrada:  # fun��o que vai remover a pessoa em si
    addi $t1,$0, 0  #  adiciona 0 a t1 para que o mesmo substitua o nome da pessoa
    lb $t3, 0($t2)  # carrega o qeu esta na memoria para verifica rse o mesmo ja foi removido
    beq $t3, 0, apagado  # verifica se ele foi removido | caso seja va para apagado
    sb $t1, 0($t2)  #  remove o caracter em quest�o
    addi $t2, $t2, 1  # adiciona 1 para buscar o proximo caracter
    j pessoa_encontrada  # retorna ao loop
  
  apagado:  # apagado:  deve verificar a limpesa do AP
  
    addi $sp, $sp, -8
    sw $t9, 0($sp)
    sw $ra, 4($sp)
    move $a0, $t9
    
    jal verifica_ap  # verifica se o apartamneto esta vasio
    
    lw $ra, 4($sp)
    lw $t9, 0($sp)
    addi $sp, $sp, 8
    
    beq $v0, 2, esvasia_apt_rm  # caso o ap esteja vasio, limpar ele inteiro
    jr $ra # encerra a fun��o
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de adicionar autom�vel	
cmd_ad_a:
	la $a0, terminal_cmd				# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	
	addi $a0, $a0, 8				# Soma 8 ao endere�o afim de ir para onde come�a o numero do AP 
	addi $t1, $a0, 2
	sb $0, 0($t1) 					#ad_auto-01/0c-modelo-cor
	
	addi $a1, $a0, 3				# Somando 3 � onde come�a o tipo do autom�vel
	addi $t1, $a1, 1
	sb $0, 0($t1) 					#ad_auto-01/0c/0modelo-cor
	
	addi $a2, $a1, 2				# Somando mais 2 � onde come�a o modelo do autom�vel
	move $t7, $a2
	
	addi $t4, $0, 0					#Inicia um contador para caracteres m�ximos
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal checaTraco
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a3, $a2, 1				# Soma mais 1 at� a cor do auto
	move $a2, $t7
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal inserirAuto
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	j fim_leitura
	
	checaTraco:
	    lb $t2, 0($a2)				#Carrego o caractere inicial de $a2
	    beq $t2, 45, substitui			#Checo se esse caractere � igual a -, se sim chama substituir
	    #beq $t4, 20, cmd_invalido			#Chego se passado 20 caracteres ainda n�o achou o -
      	    addi $a2, $a2, 1				#Pulo pro proximo caractere
      	    addi $t4, $t4, 1				#Incremento o contador
	    j checaTraco
	    
	    substitui:
	        sb $0, 0($a2)				#Sbstitui - por \0
	        jr $ra
      	    
inserirAuto: #$a0 AP - $a1 TIPO AUTO (C OU M) - $a2 MODELO - $a3 COR
    addi $t0, $s2, 0			#Posicao inicial do arquivo
    
    addi $t1, $a0, 0			#Carrega AP em $t1
    addi $t2, $a1, 0			#Carrega TIPO em $t2
    addi $t3, $a2, 0			#Carrega MODELO em $t3
    addi $t4, $a3, 0			#Carrega COR em $t4
    
    move $a0, $t1			#Parametro $a0 = ap
    move $a1, $t0			#Parametro $a1 = posi��o inicial
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    jal verifica_andar			#Recebe andar em $a0 e posi��o inicial em $a1
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    bne $v0, -1, verificarVaga		#Caso o andar exista, verifica se h� vaga
    
    j main				#Retorna a quem chamou inserirAuto
    
    verificarVaga:
    	add $t5, $v0, 103		#Guarda em $t5 a posi��o do andar($v0) junto a posi��o do primeiro auto($t0)
    	
    	lb $t7, 0($t5)			#Pega o tipo (se houver) do auto na vaga, caso nao houver $t7 = 0
    	lb $t8, 0($t2)			#Pega o tipo do auto passado
    	
    	beq $t8, 99,  autoValidado
    	beq $t8, 109, autoValidado
    	
    	la $a0, msg_e_au_s_n
    	addi $v0, $0, 4
    	syscall
    	jr $ra
    	
    	autoValidado:
    	    
    	    
    	    beq $t7, 99,  cancelaInsc	#Caso houver 1 carro na vaga, n�o permitir mais inser��o de auto
    	    beq $t7, 109, insereMoto	#Caso houver 1 moto na vaga, permitir inser��o de outra moto
    	    beq $t7, 0,   insereAuto	#Caso n�o huver nenhum auto, permitir inser��o de qualquer auto
    	
    	insereAuto:
    	
    	    move $a0, $t5		#Parametro em $a0 = posi��o a ser inserida
    	    move $a1, $t2		#Parametro em $a1 = tipo do auto
    	    move $a2, $t3		#Parametro em $a2 = modelo do auto
    	    move $a3, $t4		#Parametro em $a3 = cor do auto
    	    
    	    addi $sp, $sp, -4
    	    sw $ra, 0($sp)
    	    
    	    jal strcpy			
    	    
    	    addi $a0, $a0, 2		#Pula para a posi��o da vaga em que insere o modelo
    	    move $a1, $a2		#Parametro em $a1 = modelo do auto
    	    jal strcpy			
    	    
    	    addi $a0, $a0, 20		#Pula para a posi��o da vaga em que insere a cor
    	    move $a1, $a3		#Parametro em $a1 = cor do auto
    	    jal strcpy		
    	    
    	    lw $ra, 0($sp)
    	    addi $sp, $sp, 4
    	    
    	    jr $ra
    	
    	insereMoto:
    	    addi $t8, $t5, 42		#Carrega em $t8 a posi��o da pr�xima vaga
    	    lb $t9, 0($t8)		#Carrega o valor de $t8 -> tipo presente na vaga
    	    lb $t7, 0($t2)		#Carrega o valor de $t2 -> tipo a ser inserido
    	    beq $t8, 109, cancelaInsc	#Caso houver uma segunda moto, n�o permitir a inser��o de outra moto
    	    beq $t7, 99, cancelaInsc	#N�o deixa inserir carro caso j� existir uma moto
    	    
    	    move $a0, $t8		#Parametro em $a0 = posi��o a ser inserida
    	    move $a1, $t2		#Parametro em $a1 = tipo do auto
    	    move $a2, $t3		#Parametro em $a2 = modelo do auto
    	    move $a3, $t4		#Parametro em $a3 = cor do auto
    	    
    	    addi $sp, $sp, -4
    	    sw $ra, 0($sp)
    	    
    	    jal strcpy			
    	    
    	    addi $a0, $a0, 2		#Pula para a posi��o da vaga em que insere o modelo
    	    move $a1, $a2		#Parametro em $a1 = modelo do auto
    	    jal strcpy			
    	    
    	    addi $a0, $a0, 20		#Pula para a posi��o da vaga em que insere a cor
    	    move $a1, $a3		#Parametro em $a1 = cor do auto
    	    jal strcpy			
    	    
    	    lw $ra, 0($sp)
    	    addi $sp, $sp, 4
    	    
    	    jr $ra
    	    
    	cancelaInsc:
    	   	la $a0, msg_e_au_s_n2
    		addi $v0, $0, 4
    		syscall
    	   jr $ra
    	    
	
# Fun��o de remover autom�vel (falta confirmar com o professor se vai funcionar assim mesmo)	
cmd_rm_a:
	la $a0, terminal_cmd				# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	
	addi $a0, $a0, 8				# Soma 8 ao endere�o afim de ir para onde come�a o numero do AP 
	addi $t1, $a0, 2
	sb $0, 0($t1) 					#ad_auto-01/0c-modelo-cor
	
	addi $a1, $a0, 3				# Somando 3 � onde come�a o tipo do autom�vel
	addi $t1, $a1, 1
	sb $0, 0($t1) 					#ad_auto-01/0c/0modelo-cor
	
	addi $a2, $a1, 2				# Somando mais 2 � onde come�a o modelo do autom�vel
	move $t7, $a2
	
	addi $t4, $0, 0					#Inicia um contador para caracteres m�ximos
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal checaTraco2
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	addi $a3, $a2, 1				# Soma mais 1 at� a cor do auto
	move $a2, $t7
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal removerAuto
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	j fim_leitura
	
	checaTraco2:
	    lb $t2, 0($a2)				#Carrego o caractere inicial de $a2
	    beq $t2, 45, substitui2			#Checo se esse caractere � igual a -, se sim chama substituir
	    #beq $t4, 20, cmd_invalido			#Chego se passado 20 caracteres ainda n�o achou o -
      	    addi $a2, $a2, 1				#Pulo pro proximo caractere
      	    addi $t4, $t4, 1				#Incremento o contador
	    j checaTraco2
	    
	    substitui2:
	        sb $0, 0($a2)				#Sbstitui - por \0
	        jr $ra
      	    
	
	removerAuto: #a0 AP - a1 tipo - a2 modelo - a3 cor
    addi $t0, $s2, 0			#Posicao inicial dos auto

    addi $t1, $a0, 0			#Carrega AP em $t1
    addi $t2, $a2, 0			#Carrega MODELO em $t2
    addi $t6, $a1, 0			#Carrega TIPO em $t2
    addi $t7, $a3, 0			#Carrega COR em $t2
    
    move $a0, $t1			#Parametro $a0 = ap
    move $a1, $t0			#Parametro $a1 = posi��o inicial
    
    addi $sp, $sp, -24
    sw $t7, 20($sp) 
    sw $t6, 16($sp) 
    sw $t2, 12($sp)
    sw $t1, 8($sp) 
    sw $t0, 4($sp)
    sw $ra, 0($sp)
    jal verifica_andar			#Recebe andar em $a0 e posi��o inicial em $a1
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    lw $t1, 8($sp) 
    lw $t2, 12($sp)
    lw $t6, 16($sp)
    lw $t7, 20($sp)
    addi $sp, $sp, 24
    
    
    addi $t0, $v0, 0			#Acessa apartamento n recebido por verifica_andar
    
    bne $v0, -1, buscarAuto		#Caso o andar exista, verifica se h� vaga
    
    #Retorna mensagem �Falha: AP invalido"
    jr $ra				#Retorna a quem chamou inserirAuto
    
    buscarAuto:
    	addi $t3, $t0, 105 		#Pula para o modelo de auto do apartamento n
    	
    	move $a0, $t2			#Parametro para strcmp passando o modelo dado
    	move $a1, $t3			#Parametro para strcmp passando o modelo em vigor
    	move $a2, $t6			#Parametro para strcmp passando o tipo dado
    	move $a3, $t7			#Parametro para strcmp passando a cor dada
    	
    	addi $sp, $sp, -4
    	sw   $ra, 0($sp)
    	jal checaAuto
    	lw   $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	bne $s7, 0, autoInvalido 	#Checa se auto com modelo passado existe
    	bne $s6, 0, autoInvalido  	#Checa se auto com tipo passado existe
    	bne $s5, 0, autoInvalido  	#Checa se auto com cor passada existe
    	
        move $t6, $t3			#Copia a posi��o do modelo atual para t6
    	beq  $s7, $0, removeModelo	#Verefica se o auto na posicao � o auto procuradom, se sim, remova
    	
    	
    	addi $t3, $t3, 42		#Pula para prox modelo de auto do apartamento n
        
    	move $a0, $t2			#Parametro para strcmp passando o modelo dado
    	move $a1, $t3			#Parametro para strcmp passando o modelo em vigor
    	move $a2, $t1			#Parametro para strcmp passando o tipo em vigor
    	move $a3, $t4			#Parametro para strcmp passando a cor em vigor
        	
    	addi $sp, $sp, -4
    	sw   $ra, 0($sp)
    	jal checaAuto
    	lw   $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	bne $s7, 0, autoInvalido 	#Checa se auto com modelo passado existe
    	bne $s6, 0, autoInvalido  	#Checa se auto com tipo passado existe
    	bne $s5, 0, autoInvalido  	#Checa se auto com cor passada existe
    	
    	move $t6, $t3			#Copia a posi��o do modelo atual para t6
    	beq  $s7, $0, removeModelo	#Verefica se o auto na posicao � o auto procuradom, se sim, remova
    	
    	#Retorna mensagem "Falha: autom�vel nao encontrado"
    	jr $ra
    	
    checaAuto:
    	addi $sp, $sp, -20
    	sw   $t0, 16($sp)
    	sw   $t1, 12($sp)
    	sw   $t2, 8($sp)
    	sw   $t3, 4($sp)
    	sw   $ra, 0($sp)
    	
    	jal strcmp  			#Compara as strings de modelo
    	move $s7, $v0			#Salva resultado da fun��o em $s7
    	
    	move $a0, $a2			#Parametro carregando o tipo do auto
    	addi $a1, $t3, -2		#Pega a poci��o do tipo
    	jal strcmp  			#Compara o caracter de tipo	
    	move $s6, $v0			#Salva resultado da fun��o em $s6
    	
    	addi $a1, $t3, 20		#Pega a poci��o da cor
    	move $a0, $a3			#Parametro carregando a cor do auto
    	jal strcmp  			#Compara o caracter de cor
    	move $s5, $v0			#Salva resultado da fun��o em $s5	
    	
    	# recupera as variaveis salvas
    	
    	lw   $ra, 0($sp)
    	lw   $t3, 4($sp)
    	lw   $t2, 8($sp)	
    	lw   $t1, 12($sp)
    	lw   $t0, 16($sp)
    	addi $sp, $sp, 20
    	
    	jr $ra
    	
    autoInvalido:
    	la $a0, msg_e_au_s_n3
    		addi $v0, $0, 4
    		syscall
        jr $ra
    	
    removeModelo:
    	lb   $t4, 0($t6)		#Pega caractere atual em modelo
    	beq  $t4, 0,  removeTipo	#Checa se a remo��o ja foi realizada e encerra a fun��o 
    	addi $t5, $0, 0			#Instancia o valor 0, a ser substuido a cada caractere em modelo
    	sb   $t5, 0($t6)		#Substitui o caractere atual em modelo por 0
    	addi $t6, $t6, 1		#Pula para o pr�ximo caractere
    	j removeModelo			#Recursao
    	
    removeTipo:
    	move $t6, $t3			#Pega novamente o primeiro byte da posicao de modelo
    	addi $t6, $t6, -2 		#Passa ponteiro pra posi��o de tipo
    removeTipoAux:
    	lb   $t4, 0($t6)		#Pega caractere atual em tipo
    	beq  $t4, 0, removeCor		#Checa se a remo��o ja foi realizada e encerra a fun��o 
    	addi $t5, $0, 0			#Instancia o valor 0, a ser substuido a cada caractere em tipo
    	sb   $t5, 0($t6)		#Substitui o caractere atual em modelo por 0
    	addi $t6, $t6, 1		#Pula para o pr�ximo caractere
    	j removeTipoAux			#Recursao
    	
    removeCor:
    	move $t6, $t3			#Pega novamente o primeiro byte da posicao de modelo
    	addi $t6, $t6, 20		#Passa ponteiro pra posi��o de tipo
    removeCorAux:
    	lb   $t4, 0($t6)		#Pega caractere atual em tipo
    	beq  $t4, 0, autoRemovido	#Checa se a remo��o ja foi realizada e encerra a fun��o 
    	addi $t5, $0, 0			#Instancia o valor 0, a ser substuido a cada caractere em tipo
    	sb   $t5, 0($t6)		#Substitui o caractere atual em modelo por 0
    	addi $t6, $t6, 1		#Pula para o pr�ximo caractere
    	j removeCorAux			#Recursao
    
    autoRemovido:
    	jr $ra				#Sai da fun��o
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de limpar AP
cmd_lp_ap:
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 10				# Soma 10 ao endere�o afim de ir para onde come�a o numero do AP 
	
	jal esvasia_apt
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
	esvasia_apt:  # recebe em a0 o endere�o do apt e em a1 a horigem dos apartamentos
	move $a1, $s2
  addi $sp, $sp, -4  # armazena o ra para utiliza��o futura
  sw $ra, 0($sp)  # armazena o ra para utiliza��o futura
  
  jal verifica_andar
  
  lw $ra, 0($sp)  # recupera o ra para utiliza��o futura
  addi $sp, $sp, 4 # recupera o ra para utiliza��o futura
  
  beq $v0, -1, ap_n_encontrado  # verifica se o apartamento n�o foi encontrado
  addi $t3, $v0, 187  #  gera o fim da lisat do aparatamento
  addi $t1, $v0, 3  # vai ate o inicio do arrey a ser testado
  addi $t2, $0, 0  # inicia o contrador de caracteres
  
  removedor: # remove todo o apartamento em si
    sb $t2, 0($t1)  # salva /0 na memoria
    addi $t1, $t1, 1 # adiciona 1 ao contador
    bne $t1, $t3, removedor  # verifica o fim da remo��o
    jr $ra  #  velta para o fim da dun��o
	
	
# Fun��o de informa��es de um AP especifico
cmd_if_ap:
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 8				# Soma 8 ao endere�o afim de ir para onde come�a o numero do AP 
	
	jal verifica_ap   			 	#verifica se o ap esta vasio
	
	beq $v0, 2, ap_sem_n			# acaso esteja va para ap_sem_n
	
	la $a0, terminal_cmd			# L� o endere�o do espa�o que armazena o que foi digitado pelo usu�rio
	addi $a0, $a0, 8				# Soma 8 ao endere�o afim de ir para onde come�a o numero do AP 
	
	jal info_ap_esp
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
	info_ap_esp:   # recebe em a1 o numero do ap
	  
	 addi $sp, $sp, -4  		# armazena o ra para utiliza��o futura
 	 sw $ra, 0($sp)  			# armazena o ra para utiliza��o futura
  
	  jal verifica_andar		# acha o andar e seta o ponteiro para ele
	  
	 beq $v0, -1, main  		# acha o andar e seta o ponteiro para ele
  
 	 lw $ra, 0($sp)  			# recupera o ra para utiliza��o futura
  	addi $sp, $sp, 4 		# recupera o ra para utiliza��o futura
  	
  	
  	move $t1, $v0  			# move o ponteiro para t1 no intuito de gerar os prints
	
	  
	 li $v0, 4  					# carrega "AP e printa"
   	 la $a0, msg_info_ap0			# carrega "AP e printa"
   	 syscall					# carrega "AP e printa"
   	 
   	 li $v0, 4  					# printa o numero do apartamento
   	 move $a0, $t1				# printa o numero do apartamento
   	 syscall					# printa o numero do apartamento
   	 
   	 li $v0, 4					# qebra a linha com \n
   	 la $a0, quebra_linha			# qebra a linha com \n
   	 syscall					# qebra a linha com \n
   	 
   	  li $v0, 4 					# printa Moradores:
   	 la $a0, msg_info_ap1			# printa moradores
   	 syscall					# printa moradores
   	 
   	 li $v0, 4					# qebra a linha com \n
   	 la $a0, quebra_linha 			# qebra a linha com \n
   	 syscall					# qebra a linha com \n
   	 
   	 addi $t1, $t1, 3				# pula o ponteiro para o primeiro nome inserido no ap
   	 addi $t2, $0, 0				# inicia o contador de pessoas pro andar
   	 
   	 loop_info_aps_moradores:  # inicia o loop de moradores
   	 
   	 	lb $t3, 0($t1)  				# carrega o 1 item de cada andar por que se n�o for 0 deve emprimir se for 0 n�o deve imprimir
   	 	bne $t3, 0, imprime_mora  		# verifica se $t3 � igual a 0
   	 	
   	 
   	 fim_loop_aps:  				# verifica se os 5 moradores for�o verificados
   	 	addi $t2, $t2, 1			# adiciona 1 no contador de pessoas
   	 	addi $t1, $t1, 20		# pula para a prosiam pessoa
   	 	beq $t2, 5, continua_info    # verifica se a contagem ja chegou ao fim 5 pessoas
   	 	j loop_info_aps_moradores  # retorna ao loop loop_info_aps_moradores
   	 	
   	 imprime_mora:  					# imprime o morador especifico
   			li $v0, 4  					# imprime a msg morador 
   			la $a0, msg_info_ap_spa		# imprime a msg morador 
   	 		syscall					# imprime a msg morador 
   	 		
   	 		li $v0, 4					# carrega o morador na tela
   	 		move $a0, $t1				# imprime o morador na tela
   			syscall					# imprime o morador na tela
   			
   			li $v0, 4					# quebra a linha
   			la $a0, quebra_linha			# quebra a linha
   	 		syscall					# quebra a linha
   			j fim_loop_aps # retorna ao loop para imprimir o proximo morador
   	
    continua_info: 						#  continua a impre��o saindo do loop
    	lb $t3, 0($t1)  						# carrega o caractere para saber se o espa�o esta vasio ou tem um carro/ moto escrito
    	
    	beq $t3, 99, imprime_carro				# carrega o caractere para saber se o espa�o esta vasio ou tem um carro/ moto escrito
    	beq $t3, 109, imprime_moto			# carrega o caractere para saber se o espa�o esta vasio ou tem um carro/ moto escrito
    	addi $t1, $t1, 42					# caso n�o tenha nada escrito na primeira posi��o pula para a segunda afin de verificar se a segunda posi��o esta vasia
    	lb $t3, 0($t1)  						# carrega o valor para verificar se o valor � o de uma moto
    	beq $t3, 109, imprime_motof			# carrega o valor para verificar se o valor � o de uma moto
    	j main							# pula para a main
    	
    veri_m_moto:							# verifica se o ultimo espa�o para moto foi utilizado
    	addi $t1, $t1, 20					# pula para a posu��o da segunda moto	
    	lb $t3, 0($t1)
    	beq $t3, 109, imprime_motof			# verifica se o espa�o foi utilizado
    	j main							#retorna a main
    
    imprime_carro:  						#  esse comando imprime carro: na tela
    	
    	li $v0, 4
   	la $a0, msg_info_ap2
   	syscall
    	
    	li $v0, 4
   	la $a0, quebra_linha
   	syscall
   	j cont_impre  						# imprime a continua��o
   	
   imprime_moto:						# esse comando imprime carro: na tela
   	li $v0, 4
   	la $a0, msg_info_ap3
   	syscall
    	
    	li $v0, 4
   	la $a0, quebra_linha
   	syscall
   	j cont_impre
   
   imprime_motof:						# imprime a ultima moto
   	addi $t4, $0, 123 					# imprime a ultima moto enviando uma senha para encerar o loop
   	j cont_impre						# imprime a continua��o
   	
    cont_impre:  # impre��o geral de um carro
    	#  adiciona um espa�o antes da impre��o
    	li $v0, 4
   	la $a0, msg_info_ap_spa
   	syscall
   	
   	# imprime
   	li $v0, 4
   	la $a0, msg_info_ap4
   	syscall
   	
   	# imprime nome na tela
   	addi $t1, $t1, 2
   	li $v0, 4
   	move $a0, $t1
   	syscall
   	
   	# quebra linha
   	li $v0, 4
   	la $a0, quebra_linha
   	syscall
    	
    	#  adiciona um espa�o antes da impre��o
    	li $v0, 4
   	la $a0, msg_info_ap_spa
   	syscall
   	
   	#  imprime cor na tela
   	li $v0, 4
   	la $a0, msg_info_ap5
   	syscall
   	
   	addi $t1, $t1, 20  #  pula para o proxio item cor 
   	# imprime a cor na tela
   	li $v0, 4  
   	move $a0, $t1
   	syscall
   	
   	#  quebra a linha
   	li $v0, 4
   	la $a0, quebra_linha
   	syscall
   	
   	
   	lb $t3, 0($t1)  			# carrega o valor do ponteiro em $t3 
   	beq $t3, 99, main		# verifica se ja podemos encerrar os prints e enviar para a main
   	beq $t4, 123, main		# verifica se ja podemos encerrar os prints e enviar para a main
   	j veri_m_moto  			# caso chegarmos aqui deve-se verificar se devemos incerir uma nova moto
    	
    	ap_sem_n:  # caso n�o tenha nigem no ap deve enviar uma msg de erro na tela e retorna a main
    		li $v0, 4 
   		la $a0, msg_e_ap_s_n
   		syscall
   		j main  # retorna a main
   		
# Fun��o de informa��es gerais dos APs	
cmd_if_g:
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal verificador_info_geral
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        j reslt_veri
        
verificador_info_geral:  		# � responsavel por realizar a contagem das apartamentos com pessoas e sem pessoas
  move $t1, $s2  			#  pega o inicializador, como ele sempre esta em s2   
  addi $t2, $0, 0  			#  inicia os contadores
  addi $t3, $0, 0  			#  inicia os conatdores
  
  #  os contadores est�o ($t2 com a contagem dos aps cheios e $t3 com os aps sem pessoas)
  
  loop_apts:  				# loop principal que passa de ap em ap
    move $a0, $t1  			#  move a ponta do apartamento a ser verificado
    addi $t1, $t1, 187  			# pula para o proximo ap
    
    addi $sp, $sp, -16  		#  libera o espa�o na memoria para evitar problemas com conflitos
    sw $t1, 0($sp)  			#  qurda t1 contagem de aps
    sw $t2, 4($sp)  			#  qurda t2 contagem de aps vasios
    sw $t3, 8($sp)  			#  qurda t3 contagem de aps cheios
    sw $ra, 12($sp)  			#  quarda a posi��o no pc
    
    jal verifica_ap  			# verifica se o ap esta cheio
    
    lw $ra, 12($sp)  			#  recupera a posi��o no pc
    lw $t3, 8($sp)  			#  recupera t3 contagem de aps cheios
    lw $t2, 4($sp)  			#  recupera t2 contagem de aps vasios
    lw $t1, 0($sp)  			#  recupera t1 contagem de aps
    addi $sp, $sp, 16  			#  libera o espa�o na memoria para evitar problemas com conflitos
    
    beq $v0, 2, apt_va  		#  verifica se o apt esta cheio ou n�o
    beq $v0, 1, apt_ch  		#  verifica se o apt esta cheio ou n�o
    
    verificador_fim_aps: 		# verifica se a contagem chegou ao fim
      add $t4, $t2, $t3  		#  soma os contadores para fer se juntos chegam a 40
      beq $t4, 40, apts_verificados  # verifica a contagem
      j loop_apts  			# caso n�o estejam retorna ao loop

    apt_ch: 					# caso esteja cheio soma 1 em  t2
      addi $t2, $t2, 1  			# caso esteja cheio soma 1 em  t2
      j verificador_fim_aps 		#  varifica se acabarao os aps
      
    apt_va:  				# caso n�o esteja cheio soma 1 em  t3
      addi $t3, $t3, 1  			# caso n�o esteja cheio soma 1 em  t3
      j verificador_fim_aps 		#  varifica se acabarao os aps
      
    apts_verificados:  			# verifica se todos os apartamentos est�o  verificados
      move $v0, $t2  			#  caso sim coloca em v0 os aps cheios 
      move $v1, $t3  			#  caso sim coloca em v1 os n�o cheios
      jr $ra  					# retorna a antes da fun��o
	
    reslt_veri:  				# local para gerar os prints que s�o nescessarios para a contabulidade geral de vagas em apartamentos 
        
        move $t1, $v0 			# carrega o valor que vem de v0 aps vasios em $t1
        move $t2, $v1 			# carrega o valor que vem de v1 aps vasios em $t2
        
	li $v0, 4 				 #  imprime o texto vasios na tela
   	la $a0, msg_info_g1		#  imprime o texto vasios na tela
   	syscall				#  imprime o texto vasios na tela
   	
   	li $v0, 1  				# imprime o resultado de t1 em tela
   	move $a0, $t1			# imprime o resultado de t1 em tela
   	syscall				# imprime o resultado de t1 em tela
	
	li $v0, 4                             # pula para a proxima linha
   	la $a0, quebra_linha		# pula para a proxima linha
   	syscall				# pula para a proxima linha
   	
   	li $v0, 4				# imprime n�o vasios em tela
   	la $a0, msg_info_g2		# imprime n�o vasios em tela
   	syscall				# imprime n�o vasios em tela
   	
   	li $v0, 1				# imprime o resultado de t2 em tela
   	move $a0, $t2			# imprime o resultado de t2 em tela
   	syscall				# imprime o resultado de t2 em tela
	
	li $v0, 4				# pula para a proxima linha
   	la $a0, quebra_linha		# pula para a proxima linha
   	syscall				# pula para a proxima linha
	
	j main  				# retorna a main
	
# Fun��o de salvar no arquivo
cmd_s:
	
	j escreveArquivo
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de recarregar o arquivo	
cmd_r:
	
	j awake
	
	j fim_leitura					# Pula para fun��o que quebra linha e pula para a main
	
# Fun��o de formatar o arquivo	
cmd_f:
	
	formatar: # Percorre os apartamentos apagando todos os dados
	
	addi $t1, $s2, 3 			# Armazena a primeira posi��o do primeiro AP em t1
  	addi $t0, $s2, 7483 		# Armazena a �ltima posi��o dos AP's + 3 em t0
  	addi $t3, $s2, 187  		#  Armazena a �ltima posi��o do primeiro AP em t3
  	addi $t5, $0, 0 			# Armazena o /0 em t5
  
  	resetar_AP: 			# Remove todos os dados de todos os AP's
    	sb $t5, 0($t1)  			# salva /0 na memoria
    	addi $t1, $t1, 1 			# adiciona 1 ao contador
    	bne $t1, $t3, resetar_AP  	# Verifica se chegou ao fim do AP
    	addi $t1, $t1, 3 			# Pula para a primeira posi��o do pr�ximo AP
    	addi $t3, $t3, 187 		# Armazena a �ltima posi��o de cada AP em t3
    	bne $t1, $t0, resetar_AP 	# Verifica se chegou a �ltima posi��o de todos os AP's
   
  	j main  #  Retorna para a chamada da fun��o
	
# Fun��o que escreve "Comando Inv�lido" no display MMIO
	
cmd_valido:
	li $v0, 4          				# carrega o c�digo do servi�o de impress�o de string
	la $a0, msg_c_v       			# carrega o endere�o da mensagem
	syscall       				# chama o servi�o de impress�o de string
	jr $ra

cmd_invalido:
	li $v0, 4          				# carrega o c�digo do servi�o de impress�o de string
	la $a0, msg_c_i       			# carrega o endere�o da mensagem
	syscall       				# chama o servi�o de impress�o de string
	j main

# Fun��o auxiliar ao fim de leitura de um comando
fim_leitura:
	j main							# Pula para main para continuar o loop geral do programa
	
#  espa�o para fun�oes auxiliares
					
strcmp:  # inicia a fun��o comparador
    
    loop_principal: # inicia o loop principal da fun��o
      
      lb $t0, 0($a0)  		# carrega o valor a partir de a0 a ser avaliado 
      addi $a0, $a0, 1  		# incrementa para que a proxima letra seja pega.
      
      lb $t1, 0($a1)  		# carrega o valor a partir de a1 a ser avaliado 
      addi $a1, $a1, 1  		# incrementa para que a proxima letra seja pega.
      
      bne $t0, $t1, final_diferente  	#  verifica se os valores analizados s�o diferentes
      
      beq $t0, $0, filtro_1  			#  verifica se os dois valores s�o iguais
      beq $t1, $0, final_diferente  		#  chegando aqui verifica-se se a outra string tenha acabado ja que se a mesma acabou ambas s�o diferentes
      
      j loop_principal  				#  rotorna ao loop principal caso nenhum criterio de parada seja atendido
      
      filtro_1:  					#  verifica se os resultados anlizados s�o iguais a 0, ja que se � 0 significa que ambas as strings s�o iguais
        beq $t1, $0, final_igual  		# caso sej�o iguais va poara final_igual
        j final_diferente  				# sendo diferente, va para final_diferente
      
      final_diferente:  	# para os casos de 1 - uma string encerrar antes da outra, 2 - o primeiro valor diferente entre um e outro
      
        sub $v0, $t0, $t1 			# Realiza uma subtra��o entre o ultimo valor de a0 e o ultimo valor de a1, para atender as diretrizes da fun��o, alem de devolver o resultado em v0.
        jr $ra 					#  retorna a execu��o normal do programa 
        
      final_igual:  					# para o caso de as 2 strings serem iguais 
         
         addi $v0, $0, 0  			# o retorno em v0 deve ser 0
         jr $ra  					#  retorna a execu��o normal do programa 

strcpy: #espa�o na memoria em a0, a1 a mensagema ser copiada

  addi $t2, $a0, 0  			# adiciona os endere�os a t2
  addi $t3, $a1, 0  			# adiciona os endere�os as t3
  addi $t4, $0, 0  			# inicia um contador de caracteraes (19)
  
  loop:
  
    lb $t1, 0($t3)				# carrega em t1 o conteudo de a0 no momento
    addi $t3, $t3, 1  			# pula para a proxima casa de a0
    
    sb $t1, 0($t2) 			# carrega em t2 o conteudo de a1 no momento
    addi $t2, $t2, 1  			# pula para a proxima casa de a0
    addi $t4, $t4, 1			# adiciona 1 a $t4
    beq $t4, 19, fim_str		# verifica se a string ja chegou ao fim 19 espasos
    bne $t0, $t1, loop 			# cetificace de que a string ainda n�o acabou
  
  addi $t1, $0, 0 			#carrega o valor a ser incerido na copia "/0"
  sb $t1, 0($t2) 				# valor a ser incerido na copia "/0"
  addi $v0, $a0, 0  			# retorna a fun��o em v0
  jr $ra  					# rotorna ao fluxo normal
  
  fim_str:
  addi $t1, $0, 0				#carrega o valor a ser incerido na copia "/0"
  sb $t1, 0($t2) 				# valor a ser incerido na copia "/0"
  addi $v0, $a0, 0  			# retorna a fun��o em v0
  jr $ra  					# rotorna ao fluxo normal
         
verifica_ap: 				# Percorre um apartamento verificando se est� vazio - O n�mero do ap deve ser informado em a0
  addi $sp, $sp, -4  			# libera espa�o na memoria para salvar os registradores antes da fun��o
  sw $ra, 0($sp)  			# salvando o registrador de onde estavamos no codigo
  
  jal verifica_andar
  
  lw $ra, 0($sp) 				# recebendo o registrador de onde estavamos no codigo
  addi $sp, $sp, 4  			# recebendo o espa�o na memoria para salvar os registradores antes da fun��o
  
  addi $t2, $v0, 3 			# Carrega a posi��o da primeira pessoa do AP
  addi $t4, $0, 0 			# inicia meu contador de pessoas caso seja 5 o a paratamento est� cheio
  
  
  vaga_ap:
    lb $t3, 0($t2)  			# carrega 1 posi��o de cada nome para saber se aquele ap esta disponivel
    bne $t3, 0, apt_ocupado  	# pula para a area de escriata ja que a vaga esta disponivel
    addi $t2, $t2, 20  			# pula para o proximo nome a verificar
    addi $t4, $t4, 1  			# Incrementa o contador de pessoas verificadas
    beq $t4, 5, apt_vazio  		# caso todos os possiveis locais para incerir pessoas foram preenchidos
    j vaga_ap 				# Reinicia o loop
      
      
  apt_ocupado: # Caso exista uma pessoa no AP, retorna a fun��o.
    addi $v0, $0, 1 # Carrega 1 em v0 
    jr $ra # Retorna a fun��o
    
  apt_vazio: # Caso o apartamento esteja vazio, retorna a fun��o.
    addi $v0, $0, 2 # Carrega 2 em v0 
    jr $ra # Retorna a fun��o

verifica_andar: 				# Em a0 deve ser disposto o andara ser verificado e em a1 o ponteiro para o inicio do space de andares
  
  move $a1, $s2
  move $t6, $a1  			# salva a posi��o inicial de a1
  addi $t7, $0, 0  			# salva em t1 0
  addi $t7, $a1, 7480  		# t7 marca o fim doa aps
  move $t5, $a0  			# armazena o ponteiro do apartamento incerido 
  
  verificador_andara: 
    move $a0, $t5 			# passa o ponteiro do apartamento incerido 
    addi $a1, $t6, 0  			# carrega a  posi�aoo do espa�o disponivel em vigor para ser comparada
    addi $t8, $ra, 0  			# salva onde estava no codigo
    jal strcmp  				# verifica se as strings s�o iguais (caso sejam: o apartamento foi achado)
    addi $ra, $t8, 0 			# recupera onde estava no codigo
    beq $v0, 0, ap_enc  		# confere se as strings s�o iguais  se sim envia para a inser��o

    addi $t6, $t6, 187 			# pula para o numero do proximo apartamento
    beq $t6, $t7, ap_n_encontrado  # verifica se a contagem ja cobriu todos os apartamentos
    j verificador_andara  		# retorna ao inicio do loop
    
  ap_enc:  					# retorna a posi��o que dio andar
    move $v0, $t6  			#  move para v0 o retorno
    jr $ra  					# retorna para a execu��o do arquivo
    
ap_n_encontrado:  			# devolve 1 em v0 pq o ap n�o foi encontrado
    li $v0, 4          			# carrega o c�digo do servi�o de impress�o de string
    la $a0, msg_e_n_ap       		# carrega o endere�o da mensagem
    syscall       				# chama o servi�o de impress�o de string
    j main # encerra a fun��o
    
leArquivo:

  #Abre arquivo para ler

	li $v0, 13			#abrir arquivo
	la $a0, localArquivo 		#informa endereço
	li $a1, 0 			#informa parametro leitura
	syscall 			#descritor pra $v0

        move $s1, $v0 			#copia o descritor de $v0 para $s0
	move $a0, $s1 			#copia o descritor de $s0 para $a0

  #De fato lê
	
	li $v0, 14 			#ler conteudo do arquivo referenciado por $a0
	la $a1, apt_space 	#armazenamento
	li $a2, 7480 			#tamanho do armazenamento
	syscall 			#leitura realizada do conteudo guardado em $a1

  #Fecha o arquivo

        li $v0, 16 			#fecha arquivo
	move $a0, $s1 			#copia para o parametro $a0 o descritor guarado em $s0
	syscall 			#executa fun��o

	jr $ra	


esvasia_apt_rm:  # recebe em a0 o endere�o do apt e em a1 a horigem dos apartamentos

	la $a0, terminal_cmd
	addi $a0, $a0, 11
	move $a1, $s2
  addi $sp, $sp, -4  # armazena o ra para utiliza��o futura
  sw $ra, 0($sp)  # armazena o ra para utiliza��o futura
  
  jal verifica_andar
  
  lw $ra, 0($sp)  # recupera o ra para utiliza��o futura
  addi $sp, $sp, 4 # recupera o ra para utiliza��o futura
  
  beq $v0, -1, ap_n_encontrado  # verifica se o apartamento n�o foi encontrado
  addi $t3, $v0, 187  #  gera o fim da lisat do aparatamento
  addi $t1, $v0, 3  # vai ate o inicio do arrey a ser testado
  addi $t2, $0, 0  # inicia o contrador de caracteres
  
  removedor_rm: # remove todo o apartamento em si
    sb $t2, 0($t1)  # salva /0 na memoria
    addi $t1, $t1, 1 # adiciona 1 ao contador
    bne $t1, $t3, removedor_rm  # verifica o fim da remo��o
    jr $ra  #  velta para o fim da dun��o

escreveArquivo:

	#Abre arquivo para escrever
	
	li $v0, 13			#abrir arquivo
	la $a0, localArquivo 		#informa endere�o
	li $a1, 1			#informa parametro escrita
	syscall 			#descritor pra $v0
	
	#De fato escreve
	
	li $v0, 15			#escreve conteudo no arquivo referenciado em $a0
	move $a0, $s1 			#copia para o parametro $a0 o descritor guarado em $s0
	la $a1, apt_space 		#Conteudo a ser escrito
	li $a2, 7480			#Quantidade de caracteres a em escritos
	syscall				#executa a fun��o
		
	li $v0, 16 			#fecha arquivo
	move $a0, $s1 			#copia para o parametro $a0 o descritor guarado em $s0
	syscall 			#executa fun��o

	j main
