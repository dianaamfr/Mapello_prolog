get_int(Input) :- skip_line, get_code(C), Input is C - 48.

ask_row(Row):-
	repeat,
	write('=> Row: '),
	skip_line,
	get_char(Input),
	validate_row(Input, Row), !.

validate_row(Input, Row):- letter(Row, Input).

validate_row(_, _) :- write('ERROR: Invalid row!\n\n'), fail.

ask_col(Col):-
	repeat,
	write('=> Column: '),
	get_int(Input),
	validate_col(Input, Col), !.

validate_col(Input, Input):- between(0, 9, Input).
	
validate_col(_, _) :- write('ERROR: Invalid Column!\n\n'), fail.
