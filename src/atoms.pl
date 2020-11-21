% Atoms

% atom(?Piece, ?Symbol)
atom(joker, 'J').
atom(wall,  '#').
atom(empty, ' ').
atom(bonus, '*').
atom(white, 'O').
atom(black, 'X').


% player(+PlayerId, -Name, -Piece, -OpponentPiece)
player(1, 'BLACK', black, white). 
player(-1, 'WHITE', white, black).


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