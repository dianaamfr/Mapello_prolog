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
	valid_moves(GameState, Player, ListOfMoves),
	length(ListOfMoves, N), N > 0,
	
	display_game(GameState, Player),
	display_points(BlackPoints, WhitePoints),
	ask_move(Row, Col),
	move(GameState, [Player, Row, Col], NewGameState),
	update_points(GameState, Row, Col, Player, BlackPoints, WhitePoints, NewBP, NewWP),
	NewPlayer is -Player,
	game_loop(NewGameState, NewPlayer, NewBP, NewWP).

game_loop(GameState, Player, BlackPoints, WhitePoints):-
	NewPlayer is -Player,
	valid_moves(GameState, NewPlayer, ListOfMoves),
	length(ListOfMoves, N), N > 0,
	game_loop(GameState, NewPlayer, BlackPoints, WhitePoints).

game_loop(_, _, BlackPoints, WhitePoints):-
	write('\33\[2J'),
	write('Game Over!\n'),
	BlackPoints > WhitePoints,
	write('Black Player has won!\n').

game_loop(_, _, BlackPoints, WhitePoints):-
	write('\33\[2J'),
	write('Game Over!\n'),
	WhitePoints > BlackPoints,
	write('White Player has won!\n').

game_loop(_, _, _, _):-
	write('\33\[2J'),
	write('Game Over!\n'),
	write('It is a draw!\n').

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
	valid_move(GameState, Player, Row, Col, _-WouldTurn),
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
	L = [1,2,3,4,5,6,7,8],
	findall(Val-Row-Col, 
		(member(Row, L), member(Col, L), 
		get_bonus_at(GameState,Row,Col,Bonus),
		valid_move(GameState, Player, Row, Col, S-_), 
		Val is S + Bonus), 
		ListOfMoves1),
	remove_dups(ListOfMoves1,ListOfMovesU),
	sort(ListOfMovesU, ListOfMoves).

/* valid_move(+GameState, +Player, +Move) - 
Check if a move is valid: 
1. the cell is empty or has a bonus
2. the cell has an opponent's piece adjacent to it
3. placing the cell will turn at least one piece
*/
valid_move(GameState, Player, Row, Col, WouldTurn):-
	% cell is empty or with bonus
	(empty_cell(GameState, Row, Col); bonus_cell(GameState, Row, Col)),
	% gets the player's piece
	player_piece(PlayerPiece, Player),
	% gets the opponent's piece
	opponent_piece(OpponentPiece, Player),
	% get moves that would make at least a piece turn
	would_turn(GameState, Row, Col, PlayerPiece, OpponentPiece, WouldTurnList),
	% one piece would turn at least
	length(WouldTurnList, N),  N > 0,
	WouldTurn = N-WouldTurnList.


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


/* would_turn(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned if the player put his piece in the position [Row,Col] */
would_turn(GameState, Row, Col, PlayerPiece, OpponentPiece, WouldTurn):-
	would_turn_right(GameState, Row, Col, PlayerPiece, OpponentPiece, [], WouldTurnR),
	would_turn_left(GameState, Row, Col, PlayerPiece, OpponentPiece, [], WouldTurnL),
	would_turn_top(GameState, Row, Col, PlayerPiece, OpponentPiece, [], WouldTurnT),
	would_turn_bottom(GameState, Row, Col, PlayerPiece, OpponentPiece, [], WouldTurnB),
	would_turn_top_right(GameState, Row, Col, PlayerPiece, OpponentPiece, [], WouldTurnTR),
	would_turn_top_left(GameState, Row, Col, PlayerPiece, OpponentPiece, [], WouldTurnTL),
	would_turn_bottom_right(GameState, Row, Col, PlayerPiece, OpponentPiece, [], WouldTurnBR),
	would_turn_bottom_left(GameState, Row, Col, PlayerPiece, OpponentPiece, [], WouldTurnBL),
	append([WouldTurnR, WouldTurnL, WouldTurnT, WouldTurnB, WouldTurnTR, WouldTurnTL, WouldTurnBR, WouldTurnBL], WouldTurn).

/* would_turn_right(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the right of [Row,Col] */
would_turn_right(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check right for an opponent
	check_right(GameState, Row, Col, OpponentPiece),
	Right is Col + 1, Right =< 9,
	append(Acc, [[Row, Right]], NewAcc),
	% check right pieces
	would_turn_right(GameState, Row, Right, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_right(GameState, Row, Col, PlayerPiece, _, Acc, WouldTurn):-
	% check right for a joker or player piece
	(check_right(GameState, Row, Col, joker);
	check_right(GameState, Row, Col, PlayerPiece)),
	WouldTurn = Acc.

would_turn_right(_, _, _, _, _, _, WouldTurn):-
	% right is a wall, bonus or empty
	WouldTurn = [].


/* would_turn_left(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the left of [Row,Col] */
would_turn_left(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check left for an opponent
	check_left(GameState, Row, Col, OpponentPiece),
	Left is Col - 1, Left >= 0,
	append(Acc, [[Row, Left]], NewAcc),
	% check left pieces
	would_turn_left(GameState, Row, Left, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_left(GameState, Row, Col, PlayerPiece, _, Acc, WouldTurn):-
	% check left for a joker or player piece
	(check_left(GameState, Row, Col, joker);
	check_left(GameState, Row, Col, PlayerPiece)),
	WouldTurn = Acc.

would_turn_left(_, _, _, _, _, _, WouldTurn):-
	% left is a wall, bonus or empty
	WouldTurn = [].


/* would_turn_top(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the top of [Row,Col] */
would_turn_top(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check top for an opponent
	check_top(GameState, Row, Col, OpponentPiece),
	Top is Row - 1, Top >= 0,
	append(Acc, [[Top, Col]], NewAcc),
	% check top pieces
	would_turn_top(GameState, Top, Col, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_top(GameState, Row, Col, PlayerPiece, _, Acc, WouldTurn):-
	% check top for a joker or player piece
	(check_top(GameState, Row, Col, joker);
	check_top(GameState, Row, Col, PlayerPiece)),
	WouldTurn = Acc.

would_turn_top(_, _, _, _, _, _, WouldTurn):-
	% top is a wall, bonus or empty
	WouldTurn = [].


/* would_turn_bottom(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the bottom of [Row,Col] */
would_turn_bottom(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check bottom for an opponent
	check_bottom(GameState, Row, Col, OpponentPiece),
	Bottom is Row + 1, Bottom =< 9,
	append(Acc, [[Bottom, Col]], NewAcc),
	% check bottom pieces
	would_turn_bottom(GameState, Bottom, Col, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_bottom(GameState, Row, Col, PlayerPiece, _, Acc, WouldTurn):-
	% check bottom for a joker or player piece
	(check_bottom(GameState, Row, Col, joker);
	check_bottom(GameState, Row, Col, PlayerPiece)),
	WouldTurn = Acc.

would_turn_bottom(_, _, _, _, _, _, WouldTurn):-
	% bottom is a wall, bonus or empty
	WouldTurn = [].


/* would_turn_top_right(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the top_right of [Row,Col] */
would_turn_top_right(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check top_right for an opponent
	check_top_right(GameState, Row, Col, OpponentPiece),
	Top is Row - 1, Top >= 0,
	Right is Col + 1, Right =< 9,
	append(Acc, [[Top, Right]], NewAcc),
	% check top_right pieces
	would_turn_top_right(GameState, Top, Right, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_top_right(GameState, Row, Col, PlayerPiece, _, Acc, WouldTurn):-
	% check top_right for a joker or player piece
	(check_top_right(GameState, Row, Col, joker);
	check_top_right(GameState, Row, Col, PlayerPiece)),
	WouldTurn = Acc.

would_turn_top_right(_, _, _, _, _, _, WouldTurn):-
	% top_right is a wall, bonus or empty
	WouldTurn = [].


/* would_turn_top_left(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the top_left of [Row,Col] */
would_turn_top_left(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check top_left for an opponent
	check_top_left(GameState, Row, Col, OpponentPiece),
	Top is Row - 1, Top >= 0,
	Left is Col - 1, Left >= 0,
	append(Acc, [[Top, Left]], NewAcc),
	% check top_left pieces
	would_turn_top_left(GameState, Top, Left, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_top_left(GameState, Row, Col, PlayerPiece, _, Acc, WouldTurn):-
	% check top_left for a joker or player piece
	(check_top_left(GameState, Row, Col, joker);
	check_top_left(GameState, Row, Col, PlayerPiece)),
	WouldTurn = Acc.

would_turn_top_left(_, _, _, _, _, _, WouldTurn):-
	% top_left is a wall, bonus or empty
	WouldTurn = [].


/* would_turn_bottom_right(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the bottom_right of [Row,Col] */
would_turn_bottom_right(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check bottom_right for an opponent
	check_bottom_right(GameState, Row, Col, OpponentPiece),
	Bottom is Row + 1, Bottom =< 9,
	Right is Col + 1, Right =< 9,
	append(Acc, [[Bottom, Right]], NewAcc),
	% check bottom_right pieces
	would_turn_bottom_right(GameState, Bottom, Right, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_bottom_right(GameState, Row, Col, PlayerPiece, _, Acc, WouldTurn):-
	% check bottom_right for a joker or player piece
	(check_bottom_right(GameState, Row, Col, joker);
	check_bottom_right(GameState, Row, Col, PlayerPiece)),
	WouldTurn = Acc.

would_turn_bottom_right(_, _, _, _, _, _, WouldTurn):-
	% bottom_right is a wall, bonus or empty
	WouldTurn = [].

/* would_turn_bottom_left(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the bottom_left of [Row,Col] */
would_turn_bottom_left(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check bottom_left for an opponent
	check_bottom_left(GameState, Row, Col, OpponentPiece),
	Bottom is Row + 1, Bottom =< 9,
	Left is Col - 1, Left >= 0,
	append(Acc, [[Bottom, Left]], NewAcc),
	% check bottom_left pieces
	would_turn_bottom_left(GameState, Bottom, Left, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_bottom_left(GameState, Row, Col, PlayerPiece, _, Acc, WouldTurn):-
	% check bottom_left for a joker or player piece
	(check_bottom_left(GameState, Row, Col, joker);
	check_bottom_left(GameState, Row, Col, PlayerPiece)),
	WouldTurn = Acc.

would_turn_bottom_left(_, _, _, _, _, _, WouldTurn):-
	% bottom left is a wall, bonus or empty
	WouldTurn = [].


/* turn_pieces(+GameState, +WouldTurn, +Piece, -NewGameState) - 
turn all pieces in WouldTurn by giving them their new value(Piece); return new board*/
turn_pieces(GameState, [], _, GameState).
turn_pieces(GameState, [[Row,Col]|WouldTurn], Piece, NewGameState):-
	set_matrix_value(GameState, Row, Col, Piece, NGS1),
	turn_pieces(NGS1, WouldTurn, Piece, NewGameState).