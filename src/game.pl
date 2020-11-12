:- consult('input.pl').
:- consult('utils.pl').

% player_piece(?Piece, ?Player) - Associates a Piece to its Player
player_piece(black, 1).
player_piece(white, -1).

% opponent_piece(?Piece, ?Opponent) - Associates a Piece to the Opponent of its Player
opponent_piece(white, 1).
opponent_piece(black, -1).

game_loop(GameState):- game_loop(GameState, 1, 0, 0).

game_loop(GameState, Player, BlackPoints, WhitePoints):-
	write('\33\[2J'),
	display_game(GameState, Player),
	display_points(BlackPoints, WhitePoints),
	ask_move(Row, Col),
	move(GameState, [Player, Row, Col], NewGameState),
	update_points(GameState, Row, Col, Player, BlackPoints, WhitePoints, NewBP, NewWP),
	NewPlayer is -Player,
	game_loop(NewGameState, NewPlayer, NewBP, NewWP).


% ask_move(-Row, -Col) - Gets Move from user input
ask_move(Row, Col):-
	write('\n Choose next move:\n'),
	ask_row(Row),
	ask_col(Col).


% move(+GameState, +Move, -NewGameState) - Validates and executes a move, returning the new game state
move(GameState, [Player, Row, Col], NewGameState):-
	% validate the move
	valid_move(GameState, Player, [Row, Col]),
	% get the piece to be moved
	player_piece(Piece, Player),
	% place the piece
	set_matrix_value(GameState, Row, Col, Piece, NewGameState).
	% turn opponent's pieces
	% turn_pieces(Row, Col, NewGameState).

% If move is invalid then ask for another
move(GameState, [Player, _, _], NewGameState):-
	write('\n ERROR: Invalid move!\n'),
	ask_move(Row,Col),
	move(GameState, [Player, Row, Col], NewGameState).


% valid_moves(+GameState, +Player, -ListOfMoves) - Get the list of possible moves (NOT CONFIRMED)
valid_moves(GameState, Player, ListOfMoves):-
	findall(Move, valid_move(GameState, Player, Move), ListOfMoves).


/* valid_move(+GameState, +Player, +Move) - 
Check if a move is valid: 
1. the cell is empty or has a bonus
2. the cell has an opponent's piece adjacent to it
3. placing the cell will turn at least one piece
*/
valid_move(GameState, Player, [Row, Col]):-
	% cell is empty or with bonus
	(empty_cell(GameState, Row, Col); bonus_cell(GameState, Row, Col)),
	% gets the opponent's piece
	opponent_piece(OpponentPiece, Player),
	% cell is adjacent to opponent's piece 
	valid_surrounding(GameState, Player, OpponentPiece, Row, Col).

% TODO
update_points(GameState, Row, Col, Player, BlackPoints, WhitePoints, NewBP, NewWP) :-
	bonus_cell(GameState, Row, Col),
	update_points(Player, BlackPoints, WhitePoints, NewBP, NewWP).

update_points(GameState, Row, Col, Player, BlackPoints, WhitePoints, NewBP, NewWP) :- 
	NewWP is WhitePoints, NewBP is BlackPoints.

update_points(Player, BlackPoints, WhitePoints, NewBP, NewWP) :-
	Player = 1,
	NewBP is BlackPoints + 3, NewWP is WhitePoints.

update_points(Player, BlackPoints, WhitePoints, NewBP, NewWP) :-
	NewWP is WhitePoints + 3, NewBP is BlackPoints.


/* valid_surrounding(+GameState, +Player, + OpponentPiece, +Row, +Col) - 
Check if a move is valid by checking surrounding pieces: 
1. the cell has an opponent's piece adjacent to it in a specific direction
*/	
valid_surrounding(GameState, Player, OpponentPiece, Row, Col):-
	% left piece is an opponent's piece
	check_left(GameState, Row, Col, OpponentPiece);
	% right piece is an opponent's piece
	check_right(GameState, Row, Col, OpponentPiece);
	% top piece is an opponent's piece
	check_top(GameState, Row, Col, OpponentPiece);
	% bottom piece is an opponent's piece
	check_bottom(GameState, Row, Col, OpponentPiece);
	% top left piece is an opponent's piece
	check_top_left(GameState, Row, Col, OpponentPiece);
	% top right is an opponent's piece
	check_top_right(GameState, Row, Col, OpponentPiece);
	% bottom left is an opponent's piece
	check_bottom_left(GameState, Row, Col, OpponentPiece);
	% bottom right is an opponent's piece
	check_bottom_right(GameState, Row, Col, OpponentPiece).

% TODO - walls inside the game area are not being considered in the next predicates... I forgot they existed

% turns_row(+GameState, +Player, +Start, +End, +Row) 
%- Search row from Start to End to find a piece that makes at least one piece turn
turns_row(GameState, Player, Start, End, Row):-
	% get the row of index Row from the board
	nth0(Row, GameState, RowList),
	% check for a piece from the player that limits opponent's pieces
	turns(RowList, Start, End, Player).

% turns_col(+GameState, +Player, +Start, +End, +Col) 
%- Search col from Start to End to find a piece that makes at least one piece turn
turns_col(GameState, Player, Start, End, Col):-
	% get the col of index Col from the board
	get_col(Col, GameState, ColList),
	% check for a piece from the player that limits opponent's pieces
	turns(ColList, Start, End, Player).

% turns(+List, +Start, +End, +Player) - Search for joker or player piece in a list
turns(List, Start, End, Player):-
	% get col sublist from Start to End
	get_sublist(List, Start, End, SubList),
	% check if it has a joker or a piece from the player
	player_piece(Piece, Player),
	(member(joker, SubList); member(Piece, SubList)).


% turn_pieces(Row, Col, NewGameState). - Makes the turns caused by placing the piece at [Row,Col]
