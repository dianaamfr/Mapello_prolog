:- consult('input.pl').
:- consult('utils.pl').
:- use_module(library(random)).

% player_piece(?Piece, ?Player) - Associates a Piece to its Player
player_piece(black, 1).
player_piece(white, -1).

% opponent_piece(?Piece, ?Opponent) - Associates a Piece to the Opponent of its Player
opponent_piece(white, 1).
opponent_piece(black, -1).

game_loop(GameState, P1, P2):- game_loop(GameState, 1, 0, 0, P1, P2).

game_loop(GameState, Player, BlackPoints, WhitePoints, P1, P2):-
	\+game_over(GameState, Player, _),
	display_game(GameState, Player),
	display_points(BlackPoints, WhitePoints),
	catch(ask_move(GameState, Player, P1, P2, Row, Col),_,ask_move(GameState, Player, P1, P2, Row, Col)),
	move(GameState, [Player, Row, Col, BlackPoints, WhitePoints, NewBP, NewWP], NewGameState),
	NewPlayer is -Player, 
	game_loop(NewGameState, NewPlayer, NewBP, NewWP, P1, P2).

game_loop(GameState, Player, BlackPoints, WhitePoints, P1, P2):-
	NewPlayer is -Player,
	\+game_over(GameState, NewPlayer, _),
	game_loop(GameState, NewPlayer, BlackPoints, WhitePoints, P1, P2).

game_loop(GameState, _Player, BlackPoints, WhitePoints, _P1, _P2):-
	print_board(GameState),
	game_over(GameState-BlackPoints-WhitePoints, Winner),
	write('Game Over!\n'),
	write(Winner).


game_over(GameState, Player, _):-
	value(GameState, Player, 0).

game_over(GameState-BlackPoints-WhitePoints, Winner):-
	get_total_points(GameState-BlackPoints-WhitePoints, TotalBp, TotalWp),
	write('Final Points: '), nl,
	display_points(TotalBp, TotalWp),nl,
	get_winner(TotalBp, TotalWp, Winner).


get_total_points(GameState-BlackPoints-WhitePoints, TotalBp, TotalWp):-
	count_pieces(GameState, black, Bp),
	count_pieces(GameState, white, Wp),
	TotalBp is BlackPoints + Bp,
	TotalWp is WhitePoints + Wp.


% get_winner(+TotalBlackPoints, +TotalWhitePoints, -WinnerMessage) - Gets the message for the winner by comparing the total points of the players
get_winner(TotalBp, TotalWp, 'Black Player has won!\n') :-
	TotalBp > TotalWp.

get_winner(TotalBp, TotalWp, 'White Player has won!\n') :-
	TotalWp > TotalBp.

get_winner(_, _, 'It is a draw!\n').


% ask_move(+GameState, +Player, +Player1Mode, +Player2Mode, -Row, -Col) - Gets Move from user input or from the computer

% get move from the computer if the Player2 is a computer and it is is turn to play
ask_move(GameState, -1, _P1, P2, Row, Col):-
	P2 > 0, !,
	choose_move(GameState, -1, P2, [Row,Col]).

% get move from the computer if the Player1 is a computer and it is is turn to play
ask_move(GameState, 1, P1, _P2, Row, Col):-
	P1 > 0, !,
	choose_move(GameState, 1, P1, [Row,Col]).

% ask move if the user is the one playing
ask_move(_GameState, _Player , _P1, _P2, Row, Col):-
	write('\n Choose next move:\n'),
	ask_row(Row),
	ask_col(Col).


% choose_move(+GameState, +Player, +Level, -Move) - Gets the Move from the computer depending on the level
choose_move(GameState, Player, 1, [Row,Col]):-
	valid_moves(GameState, Player, ListOfMoves),
	% get a random valid move
	random_member(_-Row-Col, ListOfMoves).

choose_move(GameState, Player, 2, [Row,Col]):-
	valid_moves(GameState, Player, ListOfMoves),
	% get the move that turns more pieces if the level is 2
	last(ListOfMoves, _-Row-Col).


% move(+GameState, +Move, -NewGameState) - Validates and executes a move, returning the new game state
move(GameState, [Player, Row, Col, BlackPoints, WhitePoints, NewBP, NewWP], NewGameState):-
	% cell is within limits
	within_limits(Row, Col),
	% validate the move
	valid_move(GameState, Player, Row, Col, _-WouldTurn), !,
	% get the piece to be moved
	player_piece(Piece, Player),
	% place the piece
	set_matrix_value(GameState, Row, Col, Piece, NGS1),
	% turn opponent's pieces
	turn_pieces(NGS1, WouldTurn, Piece, NewGameState),
	% finally update points
	update_points(GameState, Row, Col, Player, BlackPoints, WhitePoints, NewBP, NewWP).

% If move is invalid then ask for another
move(GameState, [Player, _, _, BlackPoints, WhitePoints, NewBP, NewWP], NewGameState):-
	write('\n ERROR: Invalid move!\n'),
	catch(ask_move(GameState, Player, 0, 0, Row, Col),_,ask_move(GameState,Player,0, 0, Row, Col)),
	move(GameState, [Player, Row, Col, BlackPoints, WhitePoints, NewBP, NewWP], NewGameState).


% within_limits(+Row, +Col) - Check if a cell is within the playable area
within_limits(Row, Col):-
	Row > 0, Row < 9,
	Col > 0, Col < 9.

% value(+GameState, +Player, -Value) - evaluate GameState: get number of valid moves the Player
value(GameState, Player, Value):-
	valid_moves(GameState, Player, ListOfMoves),
	length(ListOfMoves, Value).


% valid_moves(+GameState, +Player, -ListOfMoves) - Get the list of possible moves
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


/* valid_move(+GameState, +Player, +Move, -WouldTurn) - 
Check if a move is valid and return the pieces that it turns.
A Move is valid if:
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
	check_right(GameState, Row, Col, [OpponentPiece]),
	Right is Col + 1, Right =< 9,
	append(Acc, [[Row, Right]], NewAcc),
	% check right pieces
	would_turn_right(GameState, Row, Right, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_right(GameState, Row, Col, PlayerPiece, _, Acc, Acc):-
	% check right for a joker or player piece
	check_right(GameState, Row, Col, [joker, PlayerPiece]).

would_turn_right(GameState, Row, Col, _, _, _, []):-
	% right is a wall, bonus or empty
	check_right(GameState, Row, Col, [empty, wall, bonus]).


/* would_turn_left(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the left of [Row,Col] */
would_turn_left(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check left for an opponent
	check_left(GameState, Row, Col, [OpponentPiece]),
	Left is Col - 1, Left >= 0,
	append(Acc, [[Row, Left]], NewAcc),
	% check left pieces
	would_turn_left(GameState, Row, Left, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_left(GameState, Row, Col, PlayerPiece, _, Acc, Acc):-
	% check left for a joker or player piece
	check_left(GameState, Row, Col, [joker, PlayerPiece]).

would_turn_left(GameState, Row, Col, _, _, _,[]):-
	% left is a wall, bonus or empty
	check_left(GameState, Row, Col, [empty, wall, bonus]).


/* would_turn_top(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the top of [Row,Col] */
would_turn_top(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check top for an opponent
	check_top(GameState, Row, Col, [OpponentPiece]),
	Top is Row - 1, Top >= 0,
	append(Acc, [[Top, Col]], NewAcc),
	% check top pieces
	would_turn_top(GameState, Top, Col, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_top(GameState, Row, Col, PlayerPiece, _, Acc, Acc):-
	% check top for a joker or player piece
	check_top(GameState, Row, Col, [joker, PlayerPiece]).

would_turn_top(GameState, Row, Col, _, _, _, []):-
	% top is a wall, bonus or empty
	check_top(GameState, Row, Col, [empty, wall, bonus]).

/* would_turn_bottom(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the bottom of [Row,Col] */
would_turn_bottom(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check bottom for an opponent
	check_bottom(GameState, Row, Col, [OpponentPiece]),
	Bottom is Row + 1, Bottom =< 9,
	append(Acc, [[Bottom, Col]], NewAcc),
	% check bottom pieces
	would_turn_bottom(GameState, Bottom, Col, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_bottom(GameState, Row, Col, PlayerPiece, _, Acc, Acc):-
	% check bottom for a joker or player piece
	check_bottom(GameState, Row, Col, [joker, PlayerPiece]).

would_turn_bottom(GameState, Row, Col, _, _, _, []):-
	% bottom is a wall, bonus or empty
	check_bottom(GameState, Row, Col, [empty, wall, bonus]).


/* would_turn_top_right(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the top_right of [Row,Col] */
would_turn_top_right(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check top_right for an opponent
	check_top_right(GameState, Row, Col, [OpponentPiece]),
	Top is Row - 1, Top >= 0,
	Right is Col + 1, Right =< 9,
	append(Acc, [[Top, Right]], NewAcc),
	% check top_right pieces
	would_turn_top_right(GameState, Top, Right, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_top_right(GameState, Row, Col, PlayerPiece, _, Acc, Acc):-
	% check top_right for a joker or player piece
	check_top_right(GameState, Row, Col, [joker, PlayerPiece]).

would_turn_top_right(GameState, Row, Col, _, _, _, []):-
	% top_right is a wall, bonus or empty
	check_top_right(GameState, Row, Col, [empty, wall, bonus]).


/* would_turn_top_left(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the top_left of [Row,Col] */
would_turn_top_left(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check top_left for an opponent
	check_top_left(GameState, Row, Col, [OpponentPiece]),
	Top is Row - 1, Top >= 0,
	Left is Col - 1, Left >= 0,
	append(Acc, [[Top, Left]], NewAcc),
	% check top_left pieces
	would_turn_top_left(GameState, Top, Left, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_top_left(GameState, Row, Col, PlayerPiece, _, Acc, Acc):-
	% check top_left for a joker or player piece
	check_top_left(GameState, Row, Col, [joker, PlayerPiece]).

would_turn_top_left(GameState, Row, Col, _, _, _, []):-
	% top_left is a wall, bonus or empty
	check_top_left(GameState, Row, Col, [empty, wall, bonus]).


/* would_turn_bottom_right(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the bottom_right of [Row,Col] */
would_turn_bottom_right(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check bottom_right for an opponent
	check_bottom_right(GameState, Row, Col, [OpponentPiece]),
	Bottom is Row + 1, Bottom =< 9,
	Right is Col + 1, Right =< 9,
	append(Acc, [[Bottom, Right]], NewAcc),
	% check bottom_right pieces
	would_turn_bottom_right(GameState, Bottom, Right, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_bottom_right(GameState, Row, Col, PlayerPiece, _, Acc, Acc):-
	% check bottom_right for a joker or player piece
	check_bottom_right(GameState, Row, Col, [joker, PlayerPiece]).

would_turn_bottom_right(GameState, Row, Col, _, _, _, []):-
	% bottom_right is a wall, bonus or empty
	check_bottom_right(GameState, Row, Col, [empty, bonus, wall]).


/* would_turn_bottom_left(+GameState, +Row, +Col, +PlayerPiece, +OpponentPiece, -WouldTurn) - 
get all the cells that would be turned on the bottom_left of [Row,Col] */
would_turn_bottom_left(GameState, Row, Col, PlayerPiece, OpponentPiece, Acc, WouldTurn):-
	% check bottom_left for an opponent
	check_bottom_left(GameState, Row, Col, [OpponentPiece]),
	Bottom is Row + 1, Bottom =< 9,
	Left is Col - 1, Left >= 0,
	append(Acc, [[Bottom, Left]], NewAcc),
	% check bottom_left pieces
	would_turn_bottom_left(GameState, Bottom, Left, PlayerPiece, OpponentPiece, NewAcc, WouldTurn).

would_turn_bottom_left(GameState, Row, Col, PlayerPiece, _, Acc, Acc):-
	% check bottom_left for a joker or player piece
	check_bottom_left(GameState, Row, Col, [joker, PlayerPiece]).

would_turn_bottom_left(GameState, Row, Col, _, _, _, []):-
	% bottom left is a wall, bonus or empty
	check_bottom_left(GameState, Row, Col, [empty, wall, bonus]).


/* turn_pieces(+GameState, +WouldTurn, +Piece, -NewGameState) - 
turn all pieces in WouldTurn by giving them their new value(Piece); return new board*/
turn_pieces(GameState, [], _, GameState).
turn_pieces(GameState, [[Row,Col]|WouldTurn], Piece, NewGameState):-
	set_matrix_value(GameState, Row, Col, Piece, NGS1),
	turn_pieces(NGS1, WouldTurn, Piece, NewGameState).