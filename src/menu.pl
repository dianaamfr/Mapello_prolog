% Menu

% menu - prints the main menu of the game and asks for the game mode
menu:-
    print_menu,
    repeat,
    write('=> Insert Option '),
    get_int(Input),
    handle_menu_option(Input).

% setup_menu(-Mode) - prints the menu with initial board setup options and returns de chosen setup mode
setup_menu(Mode) :-
    print_setup_menu,
    repeat,
    write('=> Insert Option '),
    get_int(Input),
    handle_setup_option(Input, Mode).

% level_menu(-Level) - prints the level menu and asks for the level of the computer
level_menu(Level) :-
    print_level_menu,
    repeat,
    write('=> Insert Option '),
    get_int(Input),
    handle_level_option(Input, Level).

% level_menu2(-Level) - prints the level menu and asks for the level of both computers
level_menu2(P1Level, P2Level) :-
    print_pc_level_menu,
    repeat,
    write('=> Insert Option '),
    get_int(Input),
    handle_pc_level_option(Input, P1Level, P2Level).


% handle_menu_option(+Option) - generates the game or a new menu accordingly to the option chosen
handle_menu_option(0).

% player vs player
handle_menu_option(1):-
    setup_menu(GameMode),
    write('\33\[2J'),
    game_loop(GameMode, 0, 0).

% player vs computer OR computer vs player
handle_menu_option(2):-
    write('\33\[2J'),
    % ask who plays first
    print_player_menu,
    repeat,
    write('=> Insert Option '),
    get_int(Input),
    handle_first_player(Input).

% computer vs computer
handle_menu_option(3):-
    level_menu2(P1Level, P2Level),
    setup_menu(GameMode),
    write('\33\[2J'),
    game_loop(GameMode, P1Level, P2Level).

handle_menu_option(_Option):- write('ERROR: Invalid Option!\n'), fail.


handle_level_option(1, 1).
handle_level_option(2, 2). 
handle_level_option(_, _):- write('ERROR: Invalid Option!\n'), fail.


handle_pc_level_option(1, 1, 1).
handle_pc_level_option(2, 2, 2). 
handle_pc_level_option(3, 1, 2).
handle_pc_level_option(4, 2, 1). 
handle_pc_level_option(_, _, _):- write('ERROR: Invalid Option!\n'), fail.


% computer plays first
handle_first_player(1):-
    write('\33\[2J'),
    print_player('WHITE'),
    level_menu(Level),
    setup_menu(GameMode),
    game_loop(GameMode, Level, 0).

% user plays first
handle_first_player(2):- 
    write('\33\[2J'),
    print_player('BLACK'),
    level_menu(Level),
    setup_menu(GameMode),
    game_loop(GameMode, 0, Level).
    
handle_first_player(_Option):- write('ERROR: Invalid Option!\n'), fail.


handle_setup_option(1, DefaultMode):- initial(DefaultMode).
handle_setup_option(2, RandomMode):- initial(random, RandomMode).
handle_setup_option(3, UserMode):- initial(user, UserMode).
handle_setup_option(_, _):- write('ERROR: Invalid Option!\n'), fail.


print_menu:-
    write(' _____________________________________________________________'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|              __  __                  _ _                    |'),nl,
    write('|             |  \\/  | __ _ _ __   ___| | | ___               |'),nl,
    write('|             | |\\/| |/ _` \' |_ \\ / _ \\ | |/ _ \\              |'),nl,
    write('|             | |  | | (_| | |_) |  __/ | | (_) |             |'),nl,        
    write('|             |_|  |_|\\__,_| .__/ \\___|_|_|\\___/              |'),nl,
    write('|                          |_|                                |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                    (1) Player vs Player                     |'),nl,
    write('|                                                             |'),nl,
    write('|                    (2) Player vs Computer                   |'),nl,
    write('|                                                             |'),nl,
    write('|                    (3) Computer vs Computer                 |'),nl,
    write('|                                                             |'),nl,
    write('|                    (0) Quit                                 |'),nl,   
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|             By: Diana Freitas & Eduardo Brito               |'),nl,
    write('|                                                             |'),nl,
    write('|_____________________________________________________________|'),nl, nl.


print_setup_menu:-
    write(' _____________________________________________________________'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                    BOARD SETUP MODE                         |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                    (1) Default Board                        |'),nl,
    write('|                                                             |'),nl,
    write('|                    (2) Random Board                         |'),nl,
    write('|                                                             |'),nl,
    write('|                    (3) User Sets the Board                  |'),nl,
    write('|                                                             |'),nl, 
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|_____________________________________________________________|'),nl, nl.

        
print_player_menu:-
    write(' _____________________________________________________________'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                    WHO PLAYS FIRST?                         |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                    (1) Computer plays first                 |'),nl,
    write('|                                                             |'),nl,
    write('|                    (2) User plays first                     |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl, 
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|_____________________________________________________________|'),nl, nl.


print_level_menu:-
    write(' _____________________________________________________________'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                        CHOOSE THE LEVEL                     |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                        (1) Random                           |'),nl,
    write('|                                                             |'),nl,
    write('|                        (2) Greedy                           |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl, 
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|_____________________________________________________________|'),nl, nl.


print_pc_level_menu:-
    write(' _____________________________________________________________'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                      CHOOSE THE LEVELS                      |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                      (1) Random vs Random                   |'),nl,
    write('|                                                             |'),nl,
    write('|                      (2) Greedy vs Greedy                   |'),nl,
    write('|                                                             |'),nl,
    write('|                      (3) Random vs Greedy                   |'),nl,
    write('|                                                             |'),nl,
    write('|                      (4) Greedy vs Random                   |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl, 
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|_____________________________________________________________|'),nl, nl.


print_player(Color):-
    write(' _____________________________________________________________'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    format('|               You will be the ~s Player!                 |',[Color]),nl,
    write('|                                                             |'),nl,
    write('|                                                             |'),nl,
    write('|_____________________________________________________________|'),nl, nl. 
