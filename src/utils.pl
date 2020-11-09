get_list_value([Value|_], 0, Value).
get_list_value([_|T], Pos, Value) :-
    Pos > 0,
    Pos1 is Pos - 1,
    get_list_value(T, Pos1, Value).

get_matrix_value([H|_], 0, Col, Value) :-
    get_list_value(H, Col, Value).
get_matrix_value([_|T], Row, Col, Value) :-
    Row > 0,
    Row1 is Row - 1,
    get_matrix_value(T, Row1, Col, Value).

set_list_value([_|T], 0, Value, [Value|T]).
set_list_value([H|T], Pos, Value, [H|R]) :-
    Pos > 0,
    Pos1 is Pos - 1,
    set_list_value(T, Pos1, Value, R).

set_matrix_value([H|T], 0, Col, Value, [R|T]) :-
    set_list_value(H, Col, Value, R).
set_matrix_value([H|T], Row, Col, Value, [H|R]) :-
    Row > 0,
    Row1 is Row - 1,
    set_matrix_value(T, Row1, Col, Value, R).

