% Atoms
% code(Id, Symbol, N)
code(joker, 'J', 0).
code(wall,  '#', 1).
code(empty, ' ', 2).
code(bonus, '*', 3).
code(white, 'W', 4).
code(black, 'B', 5).

% Board Rows Headers
% letter(N, Letter)
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

% The definition of the predicate player may change during execution - bonus changes
:- dynamic player/3. 

% player(PlayerId, Name, Points)
player(black, 'BLACK', 0). 
player(white, 'WHITE', 0).

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

% print_board(GameState) - prints the board for the GameState
print_board(GameState):-
    write('   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |'),nl,
    write('---|---|---|---|---|---|---|---|---|---|---|'),nl,
    print_matrix(GameState, 0).

% display_game - prints the board for the GameState, the player who plays next an its points
display_game(GameState, Player):-
    print_board(GameState),nl,  
    write('--------------- '),
    player(Player, PlayerString, PlayerPoints),
    format('~s\'s turn | Has ~d points', [PlayerString, PlayerPoints]),
    write(' ---------------').
