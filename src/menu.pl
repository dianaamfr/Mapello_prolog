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

handle_menu_option(0).

handle_menu_option(1):-
    setup_menu(GameMode),
    write('\33\[2J'),
    game_loop(GameMode).

handle_menu_option(_):-
    write('ERROR: Invalid Option!\n'),
    write('=> Insert Option '),
    read(Input),
    handle_menu_option(Input).


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
    write('|                  (1) Player vs Player                       |'),nl,
    write('|                                                             |'),nl,
    write('|                  (2) Player vs Computer                     |'),nl,
    write('|                                                             |'),nl,
    write('|                  (3) Computer vs Computer                   |'),nl,
    write('|                                                             |'),nl,
    write('|                  (0) Quit                                   |'),nl,   
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
        
        
        
        
