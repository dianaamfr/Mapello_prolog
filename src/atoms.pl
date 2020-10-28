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

% addPlayerBonus(Id)  - Adds a Bonus to the Id Player total points
addPlayerBonus(Id) :-
    retract(player(Id,String,Old)),
    New is Old + 3,
    assert(player(Id,String,New)).