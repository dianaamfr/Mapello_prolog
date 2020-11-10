:- consult('atoms.pl').
:- consult('display.pl').
:- consult('boards.pl').
:- consult('game.pl').

% play - Starts the game with the hard coded initial board
play:-
    initial(GameState),
    game_loop(GameState).

% play(r) - Starts the game with an initial random board
play(r):-
    initial(r,R),
    game_loop(R).

