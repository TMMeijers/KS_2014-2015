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
	write('This is the current timeline:'), nl,
	timeline, nl,
	write('First we will add wine concurrent to dinner:'), nl,
	add(wine concurrent dinner),
	timeline, nl,
	write('Then we will put soup in between lunch and dinner'), nl,
	add(lunch before soup), add(soup before dinner),
	timeline, nl,

	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%% DEZE ALLEEN ALS HIJ NIET MEER DE OMGEKEERDE GENEREERT!
	write('When ambiguous data is added, the program will generate all possible timelines,'), nl,
	write('For instance, when placing water before dessert:'), nl,
	add(water before soup),
	timeline, nl.
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

go2 :-
	write('The system handles contradications:'), nl,
	write('add(lunch before breakfast)'), nl,
	add(lunch before breakfast), nl, nl.

go3 :-
	write('This also works on transitive contradictions:'), nl,
	write('add(dessert before breakfast)'), nl,
	add(dessert before breakfast).














