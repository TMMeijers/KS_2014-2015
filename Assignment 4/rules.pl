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
	assert(X before Y).

add_after(X, Y) :-
	check_if_event(X),
	check_if_event(Y),
	assert(X after Y).

add_concurrent(X, Y) :-
	check_if_event(X),
	check_if_event(Y),
	assert(X concurrent Y).

doSmartStuff:-
	X before Y, 
	Y before Z,
	assert(X before Z).


check_if_event(Event) :-
	\+event(Event), !,
	assert(event(Event)).

check_if_event(Event) :-
	event(Event).