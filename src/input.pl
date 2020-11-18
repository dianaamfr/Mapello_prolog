get_int(Input) :- get_code(C), C \= 10, Input is C - 48, skip_line.
get_character(Input):- get_char(Input), Input \= '\n', skip_line.

ask_row(Row):-
	repeat,
	write('=> Row: '),
	get_character(Input),
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
