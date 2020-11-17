:-use_module(library(between)).

ask_row(Row):-
	write('=> Row '),
	read(Input),
	validate_row(Input, Row).

validate_row(Input, Row):-
	letter(Row, Input),
	between(0, 9, Row).

validate_row(_, Row) :-
    write('ERROR: Invalid row!\n\n'),
    ask_row(Row).

ask_col(Col):-
	write('=> Column '),
	read(Input),
	validate_col(Input, Col).

validate_col(Input, Input):-
	integer(Input),
	between(0, 9, Input).
	
validate_col(_, Col) :-
    write('ERROR: Invalid Column!\n\n'),
    ask_col(Col).
