:- consult('random.pl').

% Initial Boards

% initial(-Board) -  Creates default initial board
initial([
    [wall,  wall,  wall,  wall,  joker, wall,  wall,  wall,  wall, wall],
    [wall,  wall,  empty, bonus, empty, empty, bonus, empty, wall, wall],
    [wall,  empty, empty, empty, empty, empty, wall,  empty, empty, wall],
    [joker, bonus, wall,  empty, empty, empty, empty, empty, bonus, joker],
    [joker, empty, empty, empty, black, white, empty, empty, empty, wall],
    [wall,  empty, empty, empty, white, black, empty, empty, bonus, wall],
    [wall,  bonus, empty, empty, empty, empty, empty, wall,  empty, joker],
    [joker, empty, empty, wall,  empty, empty, empty, empty, empty, wall],
    [wall,  wall,  empty, bonus, empty, empty, empty, bonus, wall,  wall],
    [wall,  wall,  wall,  joker, wall,  wall,  wall,  joker, wall,  wall]
    ]).

% initial(+Key, -Board) - Creates the initial Game State identified by Key
% Create random board
initial(random, Board) :- 
    maplist(restorePieces,[wall, joker, bonus]),
    maplist(lineType1, [LA,LJ]),
    maplist(lineType2, [LB,LI,LC,LH,LD,LG]),
    lineType3(LE, [black, white]),
    lineType3(LF, [white, black]),
    append([LA, LB, LC, LD, LE, LF, LG, LH, LI, LJ],[], Board).

% Let user set up the board
initial(user, Board) :- 
    empty(Empty),
    ask_board(Empty, Board).

ask_board(Empty, Board):-
    place_jokers(Empty, B1),
    place_walls(B1, B2),
    place_bonus(B2, Board).

place_jokers(Board, NewBoard):-
    ask_number(N,'jokers'),
    nl, print_board(Board),
    place_loop(Board, NewBoard, N, joker).

place_walls(Board, NewBoard):-
    ask_number(N,'walls'),
    nl, print_board(Board),
    place_loop(Board, NewBoard, N, wall).

place_bonus(Board, NewBoard):-
    ask_number(N,'bonus'),
    nl, print_board(Board),
    place_loop(Board, NewBoard, N, bonus).


place_loop(NewBoard, NewBoard ,0,_).
place_loop(Board, NewBoard, N, Piece) :- 
    N > 0, 
    format('\n=> Choose ~s position:\n', [Piece]),
    ask_row(Row),
    ask_col(Col),
    get_matrix_value(Board, Row, Col, ActualPiece),
    place_piece(Board, Piece, ActualPiece, Row, Col, NewBoard,N).


place_piece(Board, Piece, ActualPiece, Row, Col, NewBoard, N):-
    Piece == joker,
    ActualPiece == wall,
    set_matrix_value(Board, Row, Col, Piece, B1),
    N1 is N - 1,
    nl, print_board(B1),
    place_loop(B1, NewBoard, N1, Piece).

place_piece(Board, Piece, ActualPiece, Row, Col, NewBoard, N):-
    Piece == bonus,
    ActualPiece == empty,
    set_matrix_value(Board, Row, Col, Piece, B1),
    N1 is N - 1,
    nl, print_board(B1),
    place_loop(B1, NewBoard, N1, Piece).

place_piece(Board, Piece, ActualPiece, Row, Col, NewBoard, N):-
    Piece == wall,
    ActualPiece == empty,
    set_matrix_value(Board, Row, Col, Piece, B1),
    N1 is N - 1,
    nl, print_board(B1),
    place_loop(B1, NewBoard, N1, Piece).

place_piece(Board, Piece, _, _, _, NewBoard, N):-
    write('ERROR: Invalid position!\n'),
    place_loop(Board, NewBoard, N, Piece).

ask_number(Number, Piece):-
    format('\n=> Number of ~s (0 to 8) ', [Piece]),
    read(Input),
    validate_number(Input, Number, Piece).

validate_number(Input, Input, _):-
	integer(Input),
	Input >= 0,
	Input =< 8.
validate_number(_, Number, Piece) :-
    write('ERROR: Invalid number!\n\n'),
    ask_number(Number, Piece).

empty([
[wall,  wall,  wall,  wall,  wall, wall,  wall,  wall,  wall, wall],
[wall,  empty, empty, empty, empty, empty, empty, empty, empty, wall],
[wall,  empty, empty, empty, empty, empty, empty, empty, empty, wall],
[wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
[wall, empty, empty, empty, black, white, empty, empty, empty, wall],
[wall,  empty, empty, empty, white, black, empty, empty, empty, wall],
[wall,  empty, empty, empty, empty, empty, empty, empty,  empty, wall],
[wall, empty, empty, empty, empty, empty, empty, empty, empty, wall],
[wall,  empty, empty, empty, empty, empty, empty, empty, empty, wall],
[wall,  wall,  wall,  wall, wall,  wall,  wall,  wall, wall,  wall]
]).
    
intermediate([
[wall,  wall,  wall,  wall,  joker, wall,  wall,  wall,  wall, wall],
[wall,  wall,  empty, bonus, empty, empty, bonus, empty, wall, wall],
[wall,  empty, empty, empty, empty, empty, wall,  empty, empty, wall],
[joker, bonus, wall,  empty, empty, white, black, empty, bonus, joker],
[joker, empty, empty, empty, white, white, black, empty, white, wall],
[wall,  empty, empty, empty, black, white, black, white, bonus, wall],
[wall,  bonus, empty, empty, empty, white, white, wall,  empty, joker],
[joker, empty, empty, wall,  empty, white, black, empty, empty, wall],
[wall,  wall,  empty, bonus, empty, empty, empty, bonus, wall,  wall],
[wall,  wall,  wall,  joker, wall,  wall,  wall,  joker, wall,  wall]
]).

final([
[wall,  wall,  wall,  wall,  joker, wall,  wall,  wall,  wall, wall],
[wall,  wall,  white, white, white, black, white, white, wall, wall],
[wall,  white, black, white, black, black, wall,  white, black, wall],
[joker, black, wall,  black, white, white, white, black, black, joker],
[joker, black, white, black, white, white, black, white, black, wall],
[wall,  black, white, black, white, black, black, white, black, wall],
[wall,  black, white, white, black, black, white, wall,  white, joker],
[joker, white, black, wall,  black, black, black, white, black, wall],
[wall,  wall,  black, black, white, white, white, white, wall,  wall],
[wall,  wall,  wall,  joker, wall,  wall,  wall,  joker, wall,  wall]
]).