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

:- dynamic currentPieces/2.

currentPieces(wall, 8).
currentPieces(joker, 8).
currentPieces(bonus, 8).

removePiece(Id) :-
    retract(currentPieces(Id, Old)),
    New is Old - 1,
    assert(currentPieces(Id, New)),
    Old > 0.

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

lineType1(L1) :- 
    length(L1, 10), 
    maplist(getRandomElement(0,2), L1).
lineType2(L) :- 
    length(Lx, 8), 
    maplist(getRandomElement(1,4), Lx), 
    append([wall],[],L2), 
    append(L2, Lx, L3), 
    append(L3, [wall], L).

initial(r,R) :- 
    lineType1(LA), 
    lineType2(LB),
    lineType2(LC),
    lineType2(LD),
    lineType2(LG),
    lineType2(LH),
    lineType2(LI),
    lineType1(LJ),
    append(
        [LA, LB, LC, LD, 
        [wall, empty, empty, empty, black, white, empty, empty, empty, wall],
        [wall,  empty, empty, empty, white, black, empty, empty, empty, wall],
        LG, LH, LI, LJ],[],R).

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
