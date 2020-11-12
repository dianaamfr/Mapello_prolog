ask_row(Row):-
	write('=> Row '),
	read(Input),
	validate_row(Input, Row).

validate_row(Input, Row):-
	letter(Row, Input),
	Row >= 0,
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
	Input >= 0,
	Input =< 9.
	
validate_col(_, Col) :-
    write('ERROR: Invalid Column!\n\n'),
    ask_col(Col).
