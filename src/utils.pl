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


% get_sublist(+List, +From, +To, -SubList) - Get a sublist = list[From, To]
get_sublist(List, From, To, SubList) :- 	
    findall(Cell, (nth0(Pos, List, Cell), Pos >= From, Pos =< To), SubList).


% get_col(+ColNumber, +Matrix, -Col) - Get column ColNumber from a matrix
get_col(ColNumber, Matrix, Col) :-
    maplist(nth0(ColNumber), Matrix, Col).


% Verify adjacent cell
% check_right(+Matrix, +Row, +Col, +Piece) - True if the cell on the right of Matrix[Row, Col] is the same as Piece
check_right(Matrix, Row, Col, Piece):-
	Right is Col + 1, Right =< 8,
	get_matrix_value(Matrix, Row, Right, Value),
	Value == Piece.

% check_left(+Matrix, +Row, +Col, +Piece) - True if the cell on the left of Matrix[Row, Col] is the same as Piece
check_left(Matrix, Row, Col, Piece):-
	Left is Col - 1, Left >= 1,
	get_matrix_value(Matrix, Row, Left, Value),
	Value == Piece.

% check_top(+Matrix, +Row, +Col, +Piece) - True if the cell on top of Matrix[Row, Col] is the same as Piece
check_top(Matrix, Row, Col, Piece):-
	Top is Row - 1, Top >= 1,
	get_matrix_value(Matrix, Top, Col, Value),
	Value == Piece.

% check_bottom(+Matrix, +Row, +Col, +Piece) - True if the cell below Matrix[Row, Col] is the same as Piece
check_bottom(Matrix, Row, Col, Piece):-
	Bottom is Row + 1, Bottom =< 8,
	get_matrix_value(Matrix, Bottom, Col, Value),
	Value == Piece.
