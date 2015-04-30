%% Kennissystemen Assignment 4
%% Universiteit van Amsterdam
%%
%% Thomas Meijers (10647023) & Jeroen Vranken (10658491)
%% May 3rd, 2015
%%
%% This application can reason about timelines.

:- consult('definitions.pl').
:- consult('knowledge_base.pl').
:- consult('rules.pl').

% for now deleted go1.


go1 :-
	write('Adds wine concurrent to dinner'),
	add(wine concurrent dinner).

go2 :-
	write('Tries to put wine before breakfast:'), nl,
	add(wine before breakfast).