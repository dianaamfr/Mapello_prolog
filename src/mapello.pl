:- consult('boards.pl').
:- consult('display.pl').

% addPlayerBonus(Id)  - Changes the definition from player(adds a bonus)
addPlayerBonus(Id) :-
    retract(player(Id,String,Old)),
    New is Old + 3,
    assert(player(Id,String,New)).

% play - starts the game with the hard coded initial board
play:-
    initial(GameState),
    display_game(GameState, black).

% play(r) - starts the game with an initial random(r) board
play(r):-
    initial(r,R),
    display_game(R, black).
