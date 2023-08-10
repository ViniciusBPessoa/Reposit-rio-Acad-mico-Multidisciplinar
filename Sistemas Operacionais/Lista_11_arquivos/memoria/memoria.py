from prettytable import PrettyTable
import Ajudadores.utilitarios as utilitarios
class Memoria:
    def __init__(self, tamanhp_t, tamanho_i) -> None:
        self.memoria = []
        self.tamanho_total = tamanhp_t
        self.tamanho_bloco = tamanho_i
        self.inicializador_memoria()
        self.table = PrettyTable()
        
    def inicializador_memoria(self):
        aux = self.tamanho_total // self.tamanho_bloco
        
        for c in range(0, aux):
            self.memoria.append(None)
            
    
    def adicionar_memoria(self, dado):
        aux_tamanho = dado.tamanho
        posicao = None
        achado = False
        
        for c in self.memoria:
            if c == None:
                aux_tamanho -= self.tamanho_bloco
                if posicao == None:
                    posicao = self.memoria.index(c)
                if aux_tamanho == 0:
                    achado = True
                    break
                elif aux_tamanho < self.tamanho_bloco and aux_tamanho != 0:
                    if self.memoria[self.memoria.index(c) + 1] == None:
                        achado = True
                        break
                    else:
                        aux_tamanho = dado.tamanho
                        achado = False
                        posicao = None
                        continue
                
                else:
                    aux_tamanho = dado.tamanho
                    posicao = None
                    continue
    
    def adicionar_memoria(self, item):
        
        verificador = False
        localizador = 0
        aux_tam = item.tamanho
        
        
        for c in self.memoria:
            if c != None:
                localizador = self.memoria.index(c) + 1
                verificador = False
                aux_tam = item.tamanho
            elif aux_tam == 0:
                verificador = True
                break
            else:
                if aux_tam <= self.tamanho_bloco:
                    verificador = True
                    break
                else:
                    aux_tam -= self.tamanho_bloco
        
        if verificador == False:
            self.desquebrar() 
            verificador = False
            localizador = 0
            aux_tam = item.tamanho
            
            
            for c in self.memoria:
                if c != None:
                    localizador = self.memoria.index(c) + 1
                    verificador = False
                    aux_tam = item.tamanho
                elif aux_tam == 0:
                    verificador = True
                    break
                else:
                    if aux_tam <= self.tamanho_bloco:
                        verificador = True
                        break
                    else:
                        aux_tam -= self.tamanho_bloco
        
        if verificador == True:
            aux_tam = item.tamanho
            while True:
                if aux_tam <= self.tamanho_bloco:
                    self.memoria[localizador] = (item, aux_tam)
                    break
                
                else:
                    aux_tam -= self.tamanho_bloco
                    self.memoria[localizador] = (item, self.tamanho_bloco)
                    
                localizador += 1
        
        return verificador
               
    def remover_memoria(self, dado):
        
        nome_classe = dado.__class__.__name__
        if nome_classe == "Diretorio":
            if len(dado.arquivos) > 0:
                for c in dado.arquivos:
                    self.remover_memoria(c)
        
        itens_removiveis = []
        for c in self.memoria:
            if c != None:
                if c[0] == dado:
                    itens_removiveis.append(c)
        
        for c in itens_removiveis:
            posi = self.memoria.index(c)
            self.memoria[posi] = None
    
    def desquebrar(self):
        novo_memoria = []
        i = 0

        while i < len(self.memoria):
            if self.memoria[i] is None:
                tamanho_bloco_vazio = 0
                while i < len(self.memoria) and self.memoria[i] is None:
                    tamanho_bloco_vazio += 1
                    i += 1

                if i < len(self.memoria):
                    novo_memoria.append(None)
            else:
                novo_memoria.append(self.memoria[i])
                i += 1

        self.memoria = novo_memoria
    
    def printar(self):

        utilitarios.titulo_modelo("Estado atual da memória")
        
        self.table.clear_rows()
        self.table.field_names = ["ID", "Nome do item", "Oculpado", "Fragmentação interna?", "espaço"]
        
        posicao = 1
        
        for x in self.memoria:
            if x == None:
                self.table.add_rows([[posicao, "vazio", "vazio", "Não", 0]])
            
            else:
                
                if x[1] != self.tamanho_bloco:
                    self.table.add_rows([[posicao, x[0].nome, "Sim", "Sim", x[1]]])
                
                else:
                    self.table.add_rows([[posicao, x[0].nome, "Sim", "Não", self.tamanho_bloco]])
            
            posicao += 1

        print(self.table)
        self.table.clear_rows()
