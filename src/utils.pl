% Set/Check Values in Matrix/Line
% get_list_value(+List, +Pos, -Value) - Get the Value of the element at index Pos of the List 
get_list_value([Value|_], 0, Value).

get_list_value([_|T], Pos, Value) :-
    Pos > 0,
    Pos1 is Pos - 1,
    get_list_value(T, Pos1, Value).


% get_matrix_value(+List, +Row, +Col, -Value) - Get the Value of the element at cell [Row, Col] of the Matrix 
get_matrix_value([H|_], 0, Col, Value) :-
    get_list_value(H, Col, Value).

get_matrix_value([_|T], Row, Col, Value) :-
    Row > 0,
    Row1 is Row - 1,
    get_matrix_value(T, Row1, Col, Value).


% set_list_value(+List, +Pos, +Value, -NewList) - Set the Value of the element at index Pos of the List 
set_list_value([_|T], 0, Value, [Value|T]).

set_list_value([H|T], Pos, Value, [H|R]) :-
    Pos > 0,
    Pos1 is Pos - 1,
    set_list_value(T, Pos1, Value, R).

% set_matrix_value(+List,  +Row, +Col, +Value, -NewList) - Set the Value of the element at cell [Row, Col] of the Matrix 
set_matrix_value([H|T], 0, Col, Value, [R|T]) :-
    set_list_value(H, Col, Value, R).

set_matrix_value([H|T], Row, Col, Value, [H|R]) :-
    Row > 0,
    Row1 is Row - 1,
    set_matrix_value(T, Row1, Col, Value, R).


% Verify adjacent cell
% check_right(+Matrix, +Row, +Col, +Pieces) - True if the cell on the right of Matrix[Row, Col] is in Pieces
check_right(Matrix, Row, Col, Pieces):-
	Right is Col + 1, Right =< 9,
    get_matrix_value(Matrix, Row, Right, Value),
    member(Value, Pieces).

% check_left(+Matrix, +Row, +Col, +Pieces) - True if the cell on the left of Matrix[Row, Col] is in Piece
check_left(Matrix, Row, Col, Pieces):-
	Left is Col - 1, Left >= 0,
	get_matrix_value(Matrix, Row, Left, Value),
	member(Value, Pieces).

% check_top(+Matrix, +Row, +Col, +Pieces) - True if the cell on top of Matrix[Row, Col] is in Pieces
check_top(Matrix, Row, Col, Pieces):-
	Top is Row - 1, Top >= 0,
	get_matrix_value(Matrix, Top, Col, Value),
	member(Value, Pieces).

% check_bottom(+Matrix, +Row, +Col, +Pieces) - True if the cell below Matrix[Row, Col] is in Pieces
check_bottom(Matrix, Row, Col, Pieces):-
	Bottom is Row + 1, Bottom =< 9,
	get_matrix_value(Matrix, Bottom, Col, Value),
	member(Value, Pieces).

% check_top_left(+Matrix, +Row, +Col, +Pieces) - True if the top left cell of Matrix[Row, Col] is in Piece
check_top_left(Matrix, Row, Col, Pieces):-
    Top is Row - 1, Top >= 0,
    Left is Col - 1, Left >= 0,
	get_matrix_value(Matrix, Top, Left, Value),
	member(Value, Pieces).

% check_top_right(+Matrix, +Row, +Col, +Pieces) - True if the top right cell of Matrix[Row, Col] is in Pieces
check_top_right(Matrix, Row, Col, Pieces):-
    Top is Row - 1, Top >= 0,
    Right is Col + 1, Right =< 9,
	get_matrix_value(Matrix, Top, Right, Value),
	member(Value, Pieces).

% check_bottom_left(+Matrix, +Row, +Col, +Pieces) - True if the bottom left cell of Matrix[Row, Col] is in Piece
check_bottom_left(Matrix, Row, Col, Pieces):-
    Bottom is Row + 1, Bottom =< 9,
    Left is Col - 1, Left >= 0,
	get_matrix_value(Matrix, Bottom, Left, Value),
	member(Value, Pieces).

% check_bottom_right(+Matrix, +Row, +Col, +Pieces) - True if the bottom right cell of Matrix[Row, Col] is in Pieces
check_bottom_right(Matrix, Row, Col, Pieces):-
    Bottom is Row + 1, Bottom =< 9,
    Right is Col + 1, Right =< 9,
	get_matrix_value(Matrix, Bottom, Right, Value),
	member(Value, Pieces).

% empty_cell(+Matrix, +Row, +Col) - Check if a cell is empty
empty_cell(Matrix, Row, Col) :-
	get_matrix_value(Matrix, Row, Col, Value),
	Value == empty.

% bonus_cell(+Matrix, +Row, +Col) - Check if a cell has a bonus
bonus_cell(Matrix, Row, Col):-
	get_matrix_value(Matrix, Row, Col, Value),
	Value == bonus.

get_bonus_at(Matrix, Row, Col, Bonus):-
    bonus_cell(Matrix, Row, Col),
    Bonus is 3, !.

get_bonus_at(_, _, _, Bonus):-
    Bonus is 0, !.


count_pieces(GameState, Piece, N) :- 
    L = [1,2,3,4,5,6,7,8],
	findall(Row-Col, 
		(member(Row, L), member(Col, L),
        get_matrix_value(GameState, Row, Col, Piece)), 
		ListOfPieces),
    length(ListOfPieces, N).