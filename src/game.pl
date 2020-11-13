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
	update_points(NewGameState, Row, Col, Player, BlackPoints, WhitePoints, NewBP, NewWP),
	NewPlayer is -Player,
	game_loop(NewGameState, NewPlayer, NewBP, NewWP).


% ask_move(-Row, -Col) - Gets Move from user input
ask_move(Row, Col):-
	write('\n Choose next move:\n'),
	ask_row(Row),
	ask_col(Col).


% move(+GameState, +Move, -NewGameState) - Validates and executes a move, returning the new game state
move(GameState, [Player, Row, Col], NewGameState):-
	% cell is within limits
	within_limits(Row, Col),
	% validate the move
	valid_move(GameState, Player, Row, Col, WouldTurn),
	% get the piece to be moved
	player_piece(Piece, Player),
	% place the piece
	set_matrix_value(GameState, Row, Col, Piece, NGS1),
	% turn opponent's pieces
	turn_pieces(NGS1, WouldTurn, Piece, NewGameState).

% If move is invalid then ask for another
move(GameState, [Player, _, _], NewGameState):-
	write('\n ERROR: Invalid move!\n'),
	ask_move(Row,Col),
	move(GameState, [Player, Row, Col], NewGameState).

% within_limits(+Row, +Col) - Check if a cell is within the playable area
within_limits(Row, Col):-
	Row > 0, Row < 9,
	Col > 0, Col < 9.

% valid_moves(+GameState, +Player, -ListOfMoves) - Get the list of possible moves (NOT CONFIRMED)
valid_moves(GameState, Player, ListOfMoves):-
	findall(Move, valid_move(GameState, Player, Move), ListOfMoves).

/* valid_move(+GameState, +Player, +Move) - 
Check if a move is valid: 
1. the cell is empty or has a bonus
2. the cell has an opponent's piece adjacent to it
3. placing the cell will turn at least one piece
*/
valid_move(GameState, Player, Row, Col, WouldTurn):-
	% cell is empty or with bonus
	(empty_cell(GameState, Row, Col); bonus_cell(GameState, Row, Col)),
	% gets the opponent's piece
	opponent_piece(OpponentPiece, Player),
	% check if the cell is adjacent to the opponent's piece 
	valid_surrounding(GameState, OpponentPiece, Row, Col),
	% get moves that would make at least a piece turn
	player_piece(PlayerPiece, Player),
	would_turn(GameState, Row, Col, PlayerPiece, OpponentPiece, WouldTurn),
	% one piece would turn at least
	length(WouldTurn, N),  N > 0.


update_points(GameState, Row, Col, Player, BlackPoints, WhitePoints, NewBP, NewWP) :-
	bonus_cell(GameState, Row, Col),
	update_points(Player, BlackPoints, WhitePoints, NewBP, NewWP).

update_points(_, _, _, _, BlackPoints, WhitePoints, NewBP, NewWP) :- 
	NewWP is WhitePoints, NewBP is BlackPoints.

update_points(Player, BlackPoints, WhitePoints, NewBP, NewWP) :-
	Player = 1,
	NewBP is BlackPoints + 3, NewWP is WhitePoints.

update_points(_, BlackPoints, WhitePoints, NewBP, NewWP) :-
	NewWP is WhitePoints + 3, NewBP is BlackPoints.


/* valid_surrounding(+GameState, +Player, + OpponentPiece, +Row, +Col) - 
Check if a move is valid by checking surrounding pieces: 
1. the cell has an opponent's piece adjacent to it in a specific direction
*/	
valid_surrounding(GameState, OpponentPiece, Row, Col):-
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


/* would_turn(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned if the player put his piece in the position [Row,Col] */
would_turn(GameState, Row, Col, PlayerPiece, OpponentPiece, WouldTurn):-
	would_turn_right(GameState, Row, Col, PlayerPiece, OpponentPiece, WouldTurn).

/* would_turn_right(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the right of [Row,Col] */
would_turn_right(GameState, Row, Col, PlayerPiece, OpponentPiece, WouldTurn):-
	% check right for an opponent
	check_right(GameState, Row, Col, OpponentPiece),
	Right is Col + 1, Right =< 9,
	% check right pieces
	right_turns(GameState, Row, Right, PlayerPiece, OpponentPiece, WouldTurn, []).

/* right_turns(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn, +Acc) - 
get all the cells that would be turned on the right of [Row,Col] by lopping through 
until a wall, a piece of the player or a joker is found */
% right is opponent - add actual cell and keep looping
right_turns(GameState, Row, Col, PlayerPiece, OpponentPiece, WouldTurn, Acc):-
	check_right(GameState, Row, Col, OpponentPiece),
	Right is Col + 1, Right =< 9,
	append(Acc, [[Row, Col]], NewAcc),
	right_turns(GameState, Row, Right, PlayerPiece, OpponentPiece, WouldTurn, NewAcc).

% right is player/joker - stop looping; add actual cell and return turned pieces
right_turns(GameState, Row, Col, PlayerPiece, _, NewAcc, Acc):-
	(check_right(GameState, Row, Col, joker);
	check_right(GameState, Row, Col, PlayerPiece)),
	append(Acc, [[Row, Col]], NewAcc).

% right is empty/bonus - continue without saving the cell
right_turns(GameState, Row, Col, PlayerPiece, OpponentPiece, WouldTurn, Acc):-
	(check_right(GameState, Row, Col, empty);
	check_right(GameState, Row, Col, bonus)),
	Right is Col + 1, Right =< 9,
	right_turns(GameState, Row, Right, PlayerPiece, OpponentPiece, WouldTurn, Acc).

% right is wall - no cells should be turned
right_turns(_, _, _, _, [], _).


/* turn_pieces(+GameState, +WouldTurn, +Piece, -NewGameState) - 
turn all pieces in WouldTurn by giving them their new value(Piece); return new board*/
turn_pieces(GameState, [], _, GameState).
turn_pieces(GameState, [[Row,Col]|WouldTurn], Piece, NewGameState):-
	set_matrix_value(GameState, Row, Col, Piece, NGS1),
	turn_pieces(NGS1, WouldTurn, Piece, NewGameState).