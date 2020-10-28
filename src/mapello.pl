:- use_module(library(lists)).
:- use_module(library(random)).

% Atoms
code(joker, 'J', 0).
code(wall,  '#', 1).
code(empty, ' ', 2).
code(bonus, '*', 3).
code(white, 'W', 4).
code(black, 'B', 5).

getElement(X,E) :- code(E,_,X).
getRandomElement(Bg,End,Elem) :- random(Bg,End,X), getElement(X,Elem).

letter(0, 'A').
letter(1, 'B').
letter(2, 'C').
letter(3, 'D').
letter(4, 'E').
letter(5, 'F').
letter(6, 'G').
letter(7, 'H').
letter(8, 'I').
letter(9, 'J').

:- dynamic player/3.

player(black, 'BLACK', 0). 
player(white, 'WHITE', 0).

addPlayerBonus(Id) :-
    retract(player(Id,String,Old)),
    New is Old + 3,
    assert(player(Id,String,New)).

:- dynamic localPieces/2.
:- dynamic globalPieces/2.

localPieces(wall, 0).
localPieces(joker, 0).
localPieces(bonus, 0).
globalPieces(wall, 8).
globalPieces(joker, 8).
globalPieces(bonus, 8).

restorePieces(Id) :-
    retract(globalPieces(Id, _)),
    assert(globalPieces(Id, 8)),
    retract(localPieces(Id, _)),
    assert(localPieces(Id, 8)).

setLocalPieces(Id,N) :-
    retract(localPieces(Id, _)),
    assert(localPieces(Id, N)).

removeLocalPiece(Id) :-
    retract(localPieces(Id, Old)),
    New is Old - 1,
    assert(localPieces(Id, New)),
    Old > 0.

removeGlobalPiece(Id) :-
    retract(globalPieces(Id, Old)),
    New is Old - 1,
    assert(globalPieces(Id, New)),
    Old > 0.

getOuterWallOrJoker(Elem) :-
    getRandomElement(0,2,Elem), 
    Elem == joker, 
    localPieces(joker,N), 
    N > 0, 
    globalPieces(joker, Nm),
    Nm > 0,
    !, removeLocalPiece(joker), removeGlobalPiece(joker).
getOuterWallOrJoker(Elem) :- 
    Elem = wall.

getInnerWallBonusEmpty(Elem) :- 
    getRandomElement(1,4,Elem), 
    Elem == wall, 
    localPieces(wall,N), 
    N > 0, 
    globalPieces(wall, Nm),
    Nm > 0,
    !, removeLocalPiece(wall), removeGlobalPiece(wall).
getInnerWallBonusEmpty(Elem) :- 
    localPieces(bonus,N), 
    N > 0, 
    globalPieces(bonus, Nm),
    Nm > 0,
    !, removeLocalPiece(bonus), Elem = bonus, removeGlobalPiece(bonus).
getInnerWallBonusEmpty(Elem) :- 
    Elem = empty.

randomReverse(L,Lr) :-
    random(0,2,X),
    X == 0, !,
    reverse(L,Lr).

randomReverse(L,Lr) :- Lr = L.    

lineType1(L1) :- 
    setLocalPieces(joker, 2),
    length(La, 10), 
    maplist(getOuterWallOrJoker, La),
    randomReverse(La, L1).

setLineT2T3Outer(E1, E10) :-
    maplist(setLocalPieces,[joker, wall, bonus],[1,1,1]),
    getOuterWallOrJoker(E1),
    getOuterWallOrJoker(E10).

lineType2(L2) :- 
    setLineT2T3Outer(E1,E10),
    length(Li,8),
    maplist(getInnerWallBonusEmpty, Li),
    append([E1],Li,L3),
    append(L3,[E10],La),
    randomReverse(La, L2).

lineType3(L3, LP) :-
    setLineT2T3Outer(E1,E10),
    length(Li1, 3),
    maplist(getInnerWallBonusEmpty, Li1),
    randomReverse(Li1, Lir1),
    length(Li2, 3),
    maplist(getInnerWallBonusEmpty, Li2),
    randomReverse(Li2, Lir2),
    append([[E1], Lir1, LP, Lir2, [E10]],L3).

initial(r,R) :- 
    maplist(restorePieces,[wall, joker, bonus]),
    maplist(lineType1, [LA,LJ]),
    maplist(lineType2, [LB,LI,LC,LH,LD,LG]),
    lineType3(LE, [black, white]),
    lineType3(LF, [white, black]),
    append([LA, LB, LC, LD, LE, LF, LG, LH, LI, LJ],[],R).

%Board -  Hard Coded Board
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

% Draw Functions
print_line([]).

print_line([C|L]):-
    write(' '),
    code(C,P,_), write(P),
    write(' |'),
    print_line(L).

print_matrix([],10).
print_matrix([L|T], N):-
    N < 10,
    write(' '),
    letter(N, Letter), write(Letter),
    write(' |'),
    N1 is N + 1,
    print_line(L), nl,
    write('---|---|---|---|---|---|---|---|---|---|---|'),nl,
    print_matrix(T, N1).

print_board(GameState):-
    write('   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |'),nl,
    write('---|---|---|---|---|---|---|---|---|---|---|'),nl,
    print_matrix(GameState, 0).

play:-
    initial(GameState),
    display_game(GameState, black).

play(r):-
    initial(r,R),
    display_game(R, black).

display_game(GameState, Player):-
    print_board(GameState),nl,  
    write('--------------- '),
    player(Player, PlayerString, PlayerPoints),
    format('~s\'s turn | Has ~d points', [PlayerString, PlayerPoints]),
    write(' ---------------').
