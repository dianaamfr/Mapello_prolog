:- consult('atoms.pl').
:- consult('display.pl').
:- consult('boards.pl').

% play - Starts the game with the hard coded initial board
play:-
    initial(GameState),
    display_game(GameState, black).

% play(r) - Starts the game with an initial random board
play(r):-
    initial(r,R),
    display_game(R, black).
