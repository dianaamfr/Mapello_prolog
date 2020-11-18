:- use_module(library(random)).
:- use_module(library(between)).
:- use_module(library(lists)).

:- consult('atoms.pl').
:- consult('input.pl').
:- consult('utils.pl').
:- consult('display.pl').
:- consult('random.pl').
:- consult('menu.pl').
:- consult('boards.pl').
:- consult('game.pl').

% play - Starts the game
play:-
    menu.
