ask_row(Row):-
	write('=> Row '),
	read(Input),
	validate_row(Input, Row).

validate_row(Input, Row):-
	letter(Row, Input),
	Row >= 1,
	Row =< 9.
validate_row(_, Row) :-
    write('ERROR: Invalid row!\n\n'),
    ask_row(Row).

ask_col(Col):-
	write('=> Column '),
	read(Input),
	validate_col(Input, Col).

validate_col(Input, Input):-
	integer(Input),
	Input >= 1,
	Input =< 8.
validate_col(_, Col) :-
    write('ERROR: Invalid Column!\n\n'),
    ask_col(Col).
