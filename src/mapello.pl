:- consult('atoms.pl').
:- consult('display.pl').
:- consult('boards.pl').
:- consult('game.pl').

% play - Starts the game with the hard coded initial board
play:-
    initial(GameState),
    game_loop(GameState, 1, 0, 0).

% play(r) - Starts the game with an initial random board
play(r):-
    initial(r,R),
    display_game(R, 1).

