:- consult('input.pl').
:- consult('utils.pl').

game_loop(GameState, Player, BlackPoints, WhitePoints):-
	display_game(GameState, Player),
	display_points(BlackPoints, WhitePoints),
	ask_move(Row, Col),
	move(GameState, [Player, Row, Col], NewGameState),
	NewPlayer is -Player,
	game_loop(NewGameState, NewPlayer, BlackPoints, WhitePoints).
	
ask_move(Row, Col):-
	write('\n Choose next move:\n'),
	ask_row(Row),
	ask_col(Col).

move(GameState, [Player, Row, Col], NewGameState):-
	valid_move(GameState, Player, Row, Col),
	make_move(GameState, Player, Row, Col, NewGameState).

move(GameState, [Player, _, _], NewGameState):-
	write('\n ERROR: Invalid move!\n'),
	ask_move(Row,Col),
	move(GameState, [Player, Row, Col], NewGameState).
	

valid_moves(GameState, Player, ListOfMoves):-
	findall(Move, valid_move(GameState, Player, Move), ListOfMoves).

valid_move(GameState, Player, Row, Col):-
	% cell is empty or with bonus
	empty_cell(GameState, Row, Col).
	% check if any surrounding piece is of opposite color
	%adjacent_opponent_piece(GameState, Player, Row, Col, AdjacentRow, AdjacentCol).
	% check every direction to see if there is a joker or piece of the same color
	%check_directions(AdjacentRow, AdjacentCol,).

empty_cell(GameState, Row, Col) :-
    get_matrix_value(GameState, Row, Col, Value),
    Value == empty.

adjacent_opponent_piece(GameState, Player, Row, Col, AdjacentRow, AdjacentCol):-
	% check surrounding cells

	get_matrix_value(GameState, AdjacentRow, AdjacentCol, AdjacentValue),
	Opponent is -Player,
	player_piece(AdjacentValue, Opponent).

make_move(GameState, Player, Row, Col, NewGameState):-
	player_piece(Piece, Player),
	set_matrix_value(GameState, Row, Col, Piece, NewGameState).

	