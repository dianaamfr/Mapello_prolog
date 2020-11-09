:- consult('input.pl').

game_loop(GameState, Player, BlackPoints, WhitePoints):-
	display_game(GameState, Player),
	display_points(BlackPoints, WhitePoints),
	askMove(Move),
	move(GameState, Move, NewGameState),
	NewPlayer is -Player,
	game_loop(NewGameState, NewPlayer, BlackPoints, WhitePoints).
	
askMove(Move):-
	write('\n Choose next move:\n'),
	ask_row(Row),
	ask_col(Col).

move(GameState, Move, NewGameState):- NewGameState = GameState.
	%valid_moves(GameState, Player, ListOfMoves),
	%make_move()

valid_move(GameState, Player, ListOfMoves).
	% cell is empty or with bonus
	% check if any surrounding piece is of opposite color
	% check every direction to see if there is a joker or piece of the same color
	