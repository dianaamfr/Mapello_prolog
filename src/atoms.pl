% Atoms

% code(+Id, ?Symbol, ?N)
code(joker, 'J', 0).
code(wall,  '#', 1).
code(empty, ' ', 2).
code(bonus, '*', 3).
code(white, 'O', 4).
code(black, 'X', 5).


% letter(?N, ?Letter)
letter(0, 'a').
letter(1, 'b').
letter(2, 'c').
letter(3, 'd').
letter(4, 'e').
letter(5, 'f').
letter(6, 'g').
letter(7, 'h').
letter(8, 'i').
letter(9, 'j').


% player(+PlayerId, -Name)
player(1, 'BLACK'). 
player(-1, 'WHITE').


% player_piece(?Piece, ?Player) - Associates a Piece to its Player
player_piece(black, 1).
player_piece(white, -1).


% opponent_piece(?Piece, ?Opponent) - Associates a Piece to the Opponent of the Player
opponent_piece(white, 1).
opponent_piece(black, -1).