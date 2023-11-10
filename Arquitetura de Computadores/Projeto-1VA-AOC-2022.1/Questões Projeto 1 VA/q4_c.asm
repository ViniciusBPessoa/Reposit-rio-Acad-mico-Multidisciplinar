# Projeto 1 VA Arquitetura e Organiza��o de Computadores - 2022.1
# Alunos: Vin�cius Bezerra, Irlan Farias, Apolo Albuquerque, jo�o vitor castro
# Descri��o do arquivo: C�digo .asm da quest�o 4 letra c

.data

  mensagem1: .asciiz "a vida � foda irmao" # Carrega a 1� messagem a ser comparada
  mensagem2: .asciiz "a vida � foda irmao" # Carrega a 2� messagem a ser comparada
  
.text
  
  la $a0, mensagem1 #carrega em a0 a mensagema ser copiada
  la $a1, mensagem2 #carrega em a1 a mensagema ser copiada
  
  jal strcmp  # Inicia o comparador para que vai verificar as duas strings
  addi $a0, $v0, 0 # coloca o resultado em a0 para que possa ser impre�o em um teste
  jal imprime_inteiro # envia para a fun��o de impre��o
  
  j fim  # encerra o codigo
  
  
  strcmp:  # inicia a fun��o comparador
    
    loop_principal: # inicia o loop principal da fun��o
      
      lb $t0, 0($a0)  # carrega o valor a partir de a0 a ser avaliado 
      addi $a0, $a0, 1  # incrementa para que a proxima letra seja pega.
      
      lb $t1, 0($a1)  # carrega o valor a partir de a1 a ser avaliado 
      addi $a1, $a1, 1  # incrementa para que a proxima letra seja pega.
      
      bne $t0, $t1, final_diferente  #  verifica se os valores analizados s�o diferentes
      
      beq $t0, $0, filtro_1  #  verifica se os dois valores s�o iguais
      beq $t1, $0, final_diferente  #  chegando aqui verifica-se se a outra string tenha acabado ja que se a mesma acabou ambas s�o diferentes
      
      j loop_principal  #  rotorna ao loop principal caso nenhum criterio de parada seja atendido
      
      filtro_1:  #  verifica se os resultados aanlizados s�o iguais a 0, ja que se o 2 s�o 0 significa que ambas as strings s�o iguais
        beq $t1, $0, final_igual  # caso sej�o iguais va poara final_igual
        j final_diferente  # sendo diferente, va para final_diferente
      
      final_diferente:  # para os casos de 1 - uma string encerrar antes da outra, 2 - o primeiro valor diferente entre um e outro
      
        sub $v0, $t0, $t1 # Realiza uma subtra��o entre o ultimo valor de a0 e o ultimo valor de a1, para atender as diretrizes da fun��o, alem de devolver o resultado em v0.
        jr $ra #  retorna a execu�a� normal do programa 
        
      final_igual:  # para o caso de as 2 strings serem iguais 
         
         addi $v0, $0, 0  # o retorno em v0 deve ser 0
         jr $ra  #  retorna a execu�a� normal do programa 

imprime_inteiro:	#Recebe a string a ser lida em $a0
    addi $v0, $0, 1  #Chama a fun��o imprimir string
    syscall	#Executa a fun��o
    jr $ra  #Retorna pra quem chamou o procedimento

fim: # finaliza o codigo
  addi $v0, $0,  10   # Armazena o c�digo da syscall para finalizar o codigo
  syscall
