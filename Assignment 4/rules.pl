%% Kennissystemen Assignment 4
%% Universiteit van Amsterdam
%%
%% Thomas Meijers (10647023) & Jeroen Vranken (10658491)
%% May 3rd, 2015
%%
%% These are the rules for assignment 4, timeline reasoning.

add_before(X, Y) :-
	check_if_event(X),
	check_if_event(Y),
	\+Y before X,
	\+Y while X,
	\+Y meets X.

check_if_event(Event) :-
	\+event(Event),
	assert(event(Event)).