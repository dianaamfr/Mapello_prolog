% Atoms
code(empty,' ').
code(bonus, '*').
code(joker,'J').
code(wall,'#').
code(white, 'W').
code(black, 'B').

%Board -  Hard Coded Board
initial([
[wall, wall, wall, joker, wall, wall, joker, wall, wall, wall],
[wall, wall, empty, bonus, empty, bonus, empty, empty, wall, wall],
[wall, empty, empty, empty, empty, empty, wall, empty, bonus, joker],
[wall, bonus, wall, empty, empty, empty, empty, empty, empty, wall],
[wall, empty, empty, empty, black, white, empty, empty, empty, wall],
[joker, empty, empty, empty, white, black, empty, empty, empty, wall],
[wall, bonus, empty, empty, empty, empty, empty, wall, bonus, joker],
[wall, empty, empty, wall, empty, empty, empty, empty, empty, wall],
[wall, wall, empty, bonus, empty, empty, bonus, empty, wall, wall],
[wall, wall, wall, joker, joker, wall, wall, joker, wall, wall]
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
