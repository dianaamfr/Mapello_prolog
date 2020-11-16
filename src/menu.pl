menu:-
    print_menu,
    write('=> Insert Option '),
    read(Input),
    handle_menu_option(Input).

setup_menu(Mode) :-
    print_setup_menu,
    write('=> Insert Option '),
    read(Input),
    handle_setup_option(Input, Mode).

level_menu(Mode) :-
    print_level_menu,
    write('=> Insert Option '),
    read(Input),
    handle_level_option(Input, Mode).

handle_menu_option(0).

handle_menu_option(1):-
    setup_menu(GameMode),
    write('\33\[2J'),
    game_loop(GameMode, 'p', 'p', '').

handle_menu_option(2):-
    write('\33\[2J'),
    print_player_menu,
    write('=> Insert Option '),
    read(Input),
    handle_first_player(Input).

handle_menu_option(3):-
    level_menu(Level),
    setup_menu(GameMode),
    write('\33\[2J'),
    game_loop(GameMode, 'c', 'c', Level).

handle_menu_option(_):-
    write('ERROR: Invalid Option!\n'),
    write('=> Insert Option '),
    read(Input),
    handle_menu_option(Input).


handle_level_option(1, 1).
handle_level_option(2, 2). 
handle_level_option(_, Level):-
    write('ERROR: Invalid Option!\n'),
    write('=> Insert Option '),
    read(Input),
    handle_setup_option(Input, Level).


handle_first_player(1):-
    write('\33\[2J'),
    print_player('WHITE'),
    level_menu(Level),
    setup_menu(GameMode),
    game_loop(GameMode, 'c', 'p', Level).

handle_first_player(2):- 
    write('\33\[2J'),
    print_player('BLACK'),
    level_menu(Level),
    setup_menu(GameMode),
    game_loop(GameMode, 'p', 'c', Level).
    
handle_first_player(_):-
    write('ERROR: Invalid Option!\n'),
    write('=> Insert Option '),
    read(Input),
    handle_first_player(Input).


handle_setup_option(1, UserMode):- initial(user, UserMode).

handle_setup_option(2, DefaultMode):- initial(DefaultMode).

handle_setup_option(3, RandomMode):- initial(random, RandomMode).
handle_setup_option(_, Mode):-
    write('ERROR: Invalid Option!\n'),
    write('=> Insert Option '),
    read(Input),
    handle_setup_option(Input, Mode).

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
    write('|                    (1) User Sets the Board                  |'),nl,
    write('|                                                             |'),nl,
    write('|                    (2) Default Board                        |'),nl,
    write('|                                                             |'),nl,
    write('|                    (3) Random Board                         |'),nl,
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
    write('|                        (1) Easy                             |'),nl,
    write('|                                                             |'),nl,
    write('|                        (2) Hard                             |'),nl,
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
