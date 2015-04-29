%% Kennissystemen Assignment 4
%% Universiteit van Amsterdam
%%
%% Thomas Meijers (10647023) & Jeroen Vranken (10658491)
%% May 3rd, 2015
%%
%% These are the rules for assignment 4, timeline reasoning.

check_inconsistent(X before Y) :-
	Y concurrent X;
	X concurrent Y,
	format('CONTRADICTION: ~p and ~p are concurrent!', [Y, X]).

check_inconsistent(X before Y) :-
	Y before X;
	X after Y,
	format('CONTRADICTION: ~p comes before ~p!', [Y, X]).

check_inconsistent(X concurrent Y) :-
	Y before X,
	format('CONTRADICTION: ~p comes before ~p !', [Y, X]).

check_inconsistent(X concurrent Y) :-
	X before Y,
	format('CONTRADICTION: ~p comes before ~p !', [X, Y]).


add(X after Y) :-
	add(Y before X).

add(X before Y) :-
	\+check_inconsistent(X before Y),
	add_transitive(X before Y),
	check_if_event(X),
	check_if_event(Y),
	assert(X before Y).
	
add(X concurrent Y):-
	\+ check_inconsistent(X concurrent Y),
	assert(X concurrent Y),
	assert(Y concurrent X).


check_if_event(Event) :-
	\+event(Event), !,
	assert(event(Event)).

check_if_event(Event) :-
	event(Event).