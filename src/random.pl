:- use_module(library(lists)).
:- use_module(library(random)).


% getElement(N, Id) - get an element by its numeric identifier(N)
getElement(X,E) :- code(E,_,X). 

% getRandomElement(Begin,End,Element) - get a random element with a numeric identifier in the range [Begin,End[
getRandomElement(Bg,End,Elem) :- random(Bg,End,X), getElement(X,Elem).

% The definition of localPieces and globalPieces will change during execution
:- dynamic localPieces/2.
:- dynamic globalPieces/2.

% localPieces(Id,N) - Defines the Max number of Id pieces that can be used in the line to be created
localPieces(wall, 0).
localPieces(joker, 0).
localPieces(bonus, 0).

% globalPieces(Id,N) - Defines the Max number of Id pieces that the board can have
globalPieces(wall, 8).
globalPieces(joker, 8).
globalPieces(bonus, 8).


% restorePieces(Id) - restores the 
restorePieces(Id) :-
    retract(globalPieces(Id, _)),
    assert(globalPieces(Id, 8)),
    retract(localPieces(Id, _)),
    assert(localPieces(Id, 8)).

% setLocalPieces(Id,N) - Sets the number(N) of Id pieces in the board 
setLocalPieces(Id,N) :-
    retract(localPieces(Id, _)),
    assert(localPieces(Id, N)).

% removeLocalPiece(Id,N) - Decreses number of available pieces of Id for the line being created
removeLocalPiece(Id) :-
    retract(localPieces(Id, Old)),
    New is Old - 1,
    assert(localPieces(Id, New)),
    Old > 0.

% removeGlobalPiece(Id,N) - Decreses number of available pieces of Id for the board
removeGlobalPiece(Id) :-
    retract(globalPieces(Id, Old)),
    New is Old - 1,
    assert(globalPieces(Id, New)),
    Old > 0.

% getOuterWallOrJoker(Elem) - Defines a Element as a Joker or a Wall, randomly
getOuterWallOrJoker(Elem) :-
    getRandomElement(0,2,Elem), 
    Elem == joker, 
    localPieces(joker,N), 
    N > 0, 
    globalPieces(joker, Nm),
    Nm > 0,
    !, removeLocalPiece(joker), removeGlobalPiece(joker).
getOuterWallOrJoker(Elem) :- 
    Elem = wall.

% getInnerWallOrJoker(Elem) - Defines a Element as a Wall, a Bonus, or an Empty space, randomly
getInnerWallBonusEmpty(Elem) :- 
    getRandomElement(1,4,Elem), 
    Elem == wall, 
    localPieces(wall,N), 
    N > 0, 
    globalPieces(wall, Nm),
    Nm > 0,
    !, removeLocalPiece(wall), removeGlobalPiece(wall).
getInnerWallBonusEmpty(Elem) :- 
    localPieces(bonus,N), 
    N > 0, 
    globalPieces(bonus, Nm),
    Nm > 0,
    !, removeLocalPiece(bonus), Elem = bonus, removeGlobalPiece(bonus).
getInnerWallBonusEmpty(Elem) :- 
    Elem = empty.

% random - Defines a Element as a Wall, a Bonus, or an Empty space, randomly
randomReverse(L,Lr) :-
    random(0,2,X),
    X == 0, !,
    reverse(L,Lr).

randomReverse(L,Lr) :- Lr = L.    

% lineType1(L1) - Creates a Line with Jokers & Walls (Top and Bottom limits)
lineType1(L1) :- 
    setLocalPieces(joker, 2),
    length(La, 10), 
    maplist(getOuterWallOrJoker, La),
    randomReverse(La, L1).

% setLineT2T3Outer(E1, E10) - Defines Element1 and Element10 of a line(Wall or Bonus)
setLineT2T3Outer(E1, E10) :-
    maplist(setLocalPieces,[joker, wall, bonus],[1,1,1]),
    getOuterWallOrJoker(E1),
    getOuterWallOrJoker(E10).

% lineType2(L2) - Creates a Line with Bonus, Walls & Empty Spaces
lineType2(L2) :- 
    setLineT2T3Outer(E1,E10),
    length(Li,8),
    maplist(getInnerWallBonusEmpty, Li),
    append([E1],Li,L3),
    append(L3,[E10],La),
    randomReverse(La, L2).

% lineType3(L3, LP) - Creates a middle lines of the board
lineType3(L3, LP) :-
    setLineT2T3Outer(E1,E10),
    length(Li1, 3),
    maplist(getInnerWallBonusEmpty, Li1),
    randomReverse(Li1, Lir1),
    length(Li2, 3),
    maplist(getInnerWallBonusEmpty, Li2),
    randomReverse(Li2, Lir2),
    append([[E1], Lir1, LP, Lir2, [E10]],L3).
