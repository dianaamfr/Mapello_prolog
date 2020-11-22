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
    empty(Empty),
    random_jokers(Empty, B1, 8), 
    random_walls(B1, B2, 8), 
    random_bonus(B2, Board, 8).

% Let user set up the board
initial(user, Board) :- 
    empty(Empty),
    place_jokers(Empty, B1),
    print_board(B1),
    place_walls(B1, B2),
    print_board(B2),
    place_bonus(B2, Board).

% random_jokers(+Board, -NewBoard, +N) - Places N random jokers in Board, returning a NewBoard
random_jokers(Board, Board, 0).

random_jokers(Board, NewBoard, N) :-
    N > 0,
    findall(Row-Col,(between(0,9,Row), between(0,9,Col), get_matrix_value(Board, Row, Col, wall)), Walls),
    random_member(Row-Col, Walls),
    set_matrix_value(Board, Row, Col, joker, B1),
    N1 is N - 1,
    random_jokers(B1, NewBoard, N1).

% random_walls(+Board, -NewBoard, +N) - Places N random walls in Board, returning a NewBoard
random_walls(Board, Board, 0).

random_walls(Board, NewBoard, N) :-
    N > 0,
    findall(Row-Col,(between(1,8,Row), between(1,8,Col), get_matrix_value(Board, Row, Col, empty)), Empties),
    random_member(Row-Col, Empties),
    set_matrix_value(Board, Row, Col, wall, B1),
    N1 is N - 1,
    random_walls(B1, NewBoard, N1).

% random_bonus(+Board, -NewBoard, +N) - Places N random bonus in Board, returning a NewBoard
random_bonus(Board, Board, 0).

random_bonus(Board, NewBoard, N) :-
    N > 0,
    findall(Row-Col,(between(1,8,Row), between(1,8,Col), get_matrix_value(Board, Row, Col, empty)), Empties),
    random_member(Row-Col, Empties),
    set_matrix_value(Board, Row, Col, bonus, B1),
    N1 is N - 1,
    random_bonus(B1, NewBoard, N1).


% place_joker(+Board, -NewBoard) - Places the Jokers in the Board and returns the NewBoard
place_jokers(Board, NewBoard):-
    ask_number(N, 'jokers'),
    place_loop(Board, NewBoard, N, '\nNote: Jokers must be placed on the boundary walls!\n', joker).

% place_walls(+Board, -NewBoard) - Places the Walls in the Board and returns the NewBoard
place_walls(Board, NewBoard):-
    ask_number(N, 'walls'),
    place_loop(Board, NewBoard, N, '\nNote: Walls must be placed in empty cells!\n', wall).

% place_bonus(+Board, -NewBoard) - Places the Bonus in the Board and returns the NewBoard
place_bonus(Board, NewBoard):-
    ask_number(N, 'bonus'),
    place_loop(Board, NewBoard, N, '\nNote: Bonus must be placed in empty cells!\n', bonus).


% ask_number(-Number, +Piece) - Prompts the user for the number of pieces of type Piece that he wants to place
ask_number(Number, Piece):-
    repeat,
    format('\n=> Number of ~s (0 to 8) ', [Piece]),
    get_int(Number),
    validate_number(Number).


% validate_number(+Number) - Checks if the number of pieces respects Mapello's rules - max 8 pieces 
validate_number(Number):- between(0, 8, Number).
validate_number(_) :- write('ERROR: Invalid number!\n\n'), fail.


% place_loop(+Board, -NewBoard, N, Message, Piece) - Loop to place N pieces of type Piece on the Board and return the NewBoard
place_loop(NewBoard, NewBoard, 0, _, _).
place_loop(Board, NewBoard, N, Message, Piece) :- 
    N > 0, 
    print_board(Board),
    write(Message),
    % Ask position to place the piece
    repeat,
    format('Choose ~s position:\n', [Piece]),
    ask_row(Row),
    ask_col(Col),
    % Get the actual piece on that position
    get_matrix_value(Board, Row, Col, ActualPiece),
    % Place the piece on that position if valid. Otherwise ask for new position.
    place_piece(Board, Piece, ActualPiece, Row, Col, B1),
    N1 is N - 1,
    place_loop(B1, NewBoard, N1, Message, Piece).


% place_piece(+Board, +Piece, +ActualPiece, +Row, +Col, -NewBoard) - Place piece on Board[Row,Col] if the position is valid for Piece
place_piece(Board, Piece, ActualPiece, Row, Col, NewBoard):-
    Piece == joker,
    ActualPiece == wall,
    set_matrix_value(Board, Row, Col, Piece, NewBoard).

place_piece(Board, Piece, ActualPiece, Row, Col, NewBoard):-
    Piece == bonus,
    ActualPiece == empty,
    set_matrix_value(Board, Row, Col, Piece, NewBoard).

place_piece(Board, Piece, ActualPiece, Row, Col, NewBoard):-
    Piece == wall,
    ActualPiece == empty,
    set_matrix_value(Board, Row, Col, Piece, NewBoard).

place_piece(_, _, _, _, _, _):- write('ERROR: Invalid position!\n'), fail.


% empty(-Board) - Returns an empty Board
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


% intermediate(-Board) - Returns an intermediate board
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


% final(-Board) - Returns a final Board
final([
[wall,  wall,  wall,  wall,  joker, wall,  wall,  wall,  wall, wall],
[wall,  wall,  black, black, black, black, black, white, wall, wall],
[wall,  black, black, black, black, black, wall,  black, white, wall],
[joker, white, wall,  black, white, white, black, black, black, joker],
[joker, white, white, black, black, black, white, black, black, wall],
[wall,  white, black, black, black, white, white, white, black, wall],
[wall,  white, white, black, white, black, white, wall,  black, joker],
[joker, white, white, wall,  black, black, black, black, black, wall],
[wall,  wall,  white, white, white, white, white, black, wall,  wall],
[wall,  wall,  wall,  joker, wall,  wall,  wall,  joker, wall,  wall]
]).