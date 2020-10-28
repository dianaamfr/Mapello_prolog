# PLOG_TP1_RI_T6_Mapello_1

----
### Identificação
* Jogo: Mapello
* Turma: 6
* Grupo: Mapello_1
* Elementos:
  * Diana Cristina Amaral de Freitas, up201806230
  * Eduardo Ribas Brito, up201806271
----
### Descrição
 #### Regras:
 
  O jogo Mapello é destinado a 2 jogadores, sendo cada um identificado por uma cor - **preto** ou **branco**.
  As peças utilizadas são discos reversíveis pretos e brancos, sendo a metade voltada para cima a que identifica uma peça de um jogador no tabuleiro.
  O tabuleiro, que tem uma configuração quadrangular de dimensões 10x10, é delimitado por **paredes** e por até **8 jokers**, que funcionam como peças do jogador que está a jogar.
  Na área de jogo, no centro do tabuleiro com dimensões 8x8, são colocadas 2 peças de cada cor nas células centrais e até **8 paredes** extra e **8 bónus** nas restantes céluas. As restantes células do tabuleiro ficam vazias.

  Os jogadores jogam alternadamente, começando o jogador de cor preta. 
  O jogador posiciona uma peça adjacente(na vertical, diagonal ou horizontal) a uma peça do adversário. Todas as peças do adversário que estejam entre a nova peça e uma peça que já estava no tabuleiro do jogador que está a jogar(ou um joker), seja na diagonal, vertical ou horizontal, são viradas ao contrário, ficando da cor de quem está a jogar. Uma jogada válida tem que fazer com que pelo menos uma das peças do adversário seja virada. Se o jogador não conseguir realizar uma jogada válida, a vez passa para o seu adversário.
  Se o jogador posicionar uma peça sobre um bónus ganha 3 pontos.

  O jogo termina quando nenhum dos jogadores pode realizar jogadas válidas, sendo o vencedor aquele que que tiver mais peças no tabuleiro com a sua cor voltada para cima, adicionando os pontos relativos aos bónus capturados.


* Fontes usadas para a recolha de informação:
  * [Página Oficila](https://nestorgames.com/#mapello_detail)
  * [Livro de Regras](https://nestorgames.com/rulebooks/MAPELLO_EN.pdf)
----
### Representação (Interna)
1. Tabuleiro: Lista de listas
2. Átomos para as Peças: 
  * Peça Preta - 'B'
  * Peça Branca - 'W
  * Paredes - '#'
  * Jokers - 'J'
  * Célula Vazia - ' '
3. Jogador atual: é indicado a cada jogada quem deve jogar, após ser mostrada a representação do tabuleiro.
4. Bónus: os pontos conquistados pelo jogador atual através da captura de bónus são escritos no ecrã depois da representação do tabuleiro.

#### Exemplos da representação 

##### Estados de jogo iniciais

* Tabuleiro inicial

O tabuleiro inicial é devolvido pelo predicato initial/1 (initial(-GameState)).

```pl
initial([
[wall,  wall,  wall,  wall,  joker, wall,  wall,  wall,  wall, wall],
[wall,  wall,  empty, bonus, empty, empty, bonus, empty, wall, wall],
[wall,  empty, empty, empty, empty, empty, wall,  empty, empty, wall],
[joker, bonus, wall,  empty, empty, empty, empty, empty, bonus, joker],
[joker, empty, empty, empty, black, white, empty, empty, empty, wall],
[wall,  empty, empty, empty, white, black, empty, empty, bonus, wall],
[wall,  bonus, empty, empty, empty, empty, empty, wall,  empty, joker],
[joker, empty, empty, wall,  empty, empty, empty, empty, empty, wall],
[wall,  wall,  empty, bonus, empty, empty, empty, bonus, wall,  wall],
[wall,  wall,  wall,  joker, wall,  wall,  wall,  joker, wall,  wall]
]).
```

* Tabuleiro inicial Random

No ficheiro 'random.pl' foram implementados predicados que permitem gerar um tabuleiro inicial random, respeitando o número máximo de peças de cada tipo utilizadas no jogo. 
O predicado que devolve o estado inicial random do jogo, initial/2 (initial(r,-R)) está, tal como os restantes estados de jogo, codificado no ficheiro 'boards.pl'. São utilizados alguns predicados das livrarias lists e random, assim como predicados dinamicos. 

```pl
initial(r,R) :- 
  maplist(restorePieces,[wall, joker, bonus]),
  maplist(lineType1, [LA,LJ]),
  maplist(lineType2, [LB,LI,LC,LH,LD,LG]),
  lineType3(LE, [black, white]),
  lineType3(LF, [white, black]),
  append([LA, LB, LC, LD, LE, LF, LG, LH, LI, LJ],[],R).
```

##### Estado de jogo intermédio

```pl
intermediate([
[wall,  wall,  wall,  wall,  joker, wall,  wall,  wall,  wall, wall],
[wall,  wall,  empty, bonus, empty, empty, bonus, empty, wall, wall],
[wall,  empty, empty, empty, empty, empty, wall,  empty, empty, wall],
[joker, bonus, wall,  empty, empty, white, black, empty, bonus, joker],
[joker, empty, empty, empty, white, white, black, empty, white, wall],
[wall,  empty, empty, empty, black, white, black, white, bonus, wall],
[wall,  bonus, empty, empty, empty, white, white, wall,  empty, joker],
[joker, empty, empty, wall,  empty, white, black, empty, empty, wall],
[wall,  wall,  empty, bonus, empty, empty, empty, bonus, wall,  wall],
[wall,  wall,  wall,  joker, wall,  wall,  wall,  joker, wall,  wall]
]).
```

##### Estado de jogo final

```pl
final([
[wall,  wall,  wall,  wall,  joker, wall,  wall,  wall,  wall, wall],
[wall,  wall,  white, white, white, black, white, white, wall, wall],
[wall,  white, black, white, black, black, wall,  white, black, wall],
[joker, black, wall,  black, white, white, white, black, black, joker],
[joker, black, white, black, white, white, black, white, black, wall],
[wall,  black, white, black, white, black, black, white, black, wall],
[wall,  black, white, white, black, black, white, wall,  white, joker],
[joker, white, black, wall,  black, black, black, white, black, wall],
[wall,  wall,  black, black, white, white, white, white, wall,  wall],
[wall,  wall,  wall,  joker, wall,  wall,  wall,  joker, wall,  wall]
]).
```

----
### Visualização

