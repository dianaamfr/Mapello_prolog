% Atoms
code(wall,'/').
code(empty,'.').
code(bonus, '*').
code(joker,'J').
code(border,'#').
code(white, 'o').
code(black, 'B').

%Board -  Hard Coded Board
initial([
[border, border, border, joker, border, border, joker, border, border, border],
[border, wall, empty, bonus, empty, bonus, empty, empty, wall, border],
[border, empty, empty, empty, empty, empty, wall, empty, bonus, joker],
[border, bonus, wall, empty, empty, empty, empty, empty, empty, border],
[border, empty, empty, empty, black, white, empty, empty, empty, border],
[joker, empty, empty, empty, white, black, empty, empty, empty, border],
[border, bonus, empty, empty, empty, empty, empty, wall, bonus, joker],
[border, empty, empty, wall, empty, empty, empty, empty, empty, border],
[border, wall, empty, bonus, empty, empty, bonus, empty, wall, border],
[border, border, border, joker, joker, border, border, joker, border, border]
]).

% Draw Functions
print_line([]).
print_line([C|L]):-
    code(C,P), write(P),
    write('|'),
    print_line(L).

print_matrix([]).
print_matrix([L|T]):-
    print_line(L), nl,
    print_matrix(T).

% Display Game State
% display_game(GameState, Player).

play:-
    initial(Board),
    print_matrix(Board).  
