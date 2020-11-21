% Input

% get_int(-Input) - Gets an Integer as an User Input
get_int(Input) :- 
	peek_code(C), 
	C \= 10, 
	get_code(C),
	peek_char(Char),
	Char == '\n',
	Input is C - 48, 
	!, skip_line.

get_int(_):- peek_code(C), C \= 10, !, write('ERROR: Invalid Input!\n\n'), skip_line, fail.

get_int(_):- write('ERROR: Invalid Input!\n\n'),  get_code(_), fail.

% get_character(-Input) - Gets a Char as an User Input
get_character(Input):- 
	peek_char(Input), 
	Input \= '\n',
	get_char(Input), 
	peek_char(Char),
	Char == '\n', 
	!, skip_line.

get_character(_):- peek_char(C), C \= '\n', !, write('ERROR: Invalid Input!\n\n'), skip_line, fail.

get_character(_):- write('ERROR: Invalid Input!\n\n'),  get_char(_), fail.


% ask_row(-Row) - Asks the User for a valid Row
ask_row(Row):-
	repeat,
	write('=> Row: '),
	get_character(Input),
	validate_row(Input, Row), !.

% validate_row(+Input, -Row) - Validates the User Row Input
validate_row(Input, Row):- 
	letter(Row, Input).

validate_row(_, _) :- 
	write('ERROR: Invalid row!\n\n'), fail.

% ask_col(-Col) - Asks the User for a valid Column
ask_col(Col):-
	repeat,
	write('=> Column: '),
	get_int(Input),
	validate_col(Input, Col), !.

% validate_col(+Input, -Input) - Validates the User Column Input
validate_col(Input, Input):- 
	between(0, 9, Input).
	
validate_col(_, _) :- 
	write('ERROR: Invalid Column!\n\n'), fail.
