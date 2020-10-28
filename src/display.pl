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

% print_board(GameState) - Prints the current GameState of the board
print_board(GameState):-
    write('   | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |'),nl,
    write('---|---|---|---|---|---|---|---|---|---|---|'),nl,
    print_matrix(GameState, 0).

% display_game - Displays the current GameState of the board, the player who plays next and its points
display_game(GameState, Player):-
    print_board(GameState),nl,  
    write('--------------- '),
    player(Player, PlayerString, PlayerPoints),
    format('~s\'s turn | Has ~d points', [PlayerString, PlayerPoints]),
    write(' ---------------').
