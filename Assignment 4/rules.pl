%% Kennissystemen Assignment 4
%% Universiteit van Amsterdam
%%
%% Thomas Meijers (10647023) & Jeroen Vranken (10658491)
%% May 3rd, 2015
%%
%% These are the rules for assignment 4, timeline reasoning.

%%%%%
%% check_inconsistent/1 checks if the fact to be added is inconsistent. 

check_inconsistent(X before Y) :-
	Y concurrent X;
	X concurrent Y,
	format('CONTRADICTION: ~p and ~p are concurrent!', [Y, X]).

check_inconsistent(X before Y) :-
	Y before X,
	format('CONTRADICTION: ~p comes before ~p!', [Y, X]).

check_inconsistent(X concurrent Y) :-
	Y before X,
	format('CONTRADICTION: ~p comes before ~p !', [Y, X]).

check_inconsistent(X concurrent Y) :-
	X before Y,
	format('CONTRADICTION: ~p comes before ~p !', [X, Y]).	

%%%%%
%% add/1 adds events to the timeline if not inconsistent, transitively updates all relations

add(X before Y) :-
	\+check_inconsistent(X before Y),
	add_transitive(X before Y),
	assert(X before Y).
	
add(X concurrent Y):-
	\+check_inconsistent(X concurrent Y),
	assert(X concurrent Y).


%%%%%
%% check_if_event/1 checks if something is an event, if not it will be asserted

check_if_event(Event) :-
	\+event(Event), !,
	assert(event(Event)).

check_if_event(Event) :-
	event(Event).

%%%%%
%% add_transitive/1 checks all events in the timeline and adds relations accordingly.

%% BEFORE OPERATOR
add_transitive(X before Y) :-
	event(X),
	\+event(Y),
	assert(event(Y)),
	setof(A, X concurrent A, List_A),
	setof(B, B concurrent X, List_B),
	setof(C, C before X, List_C),
	append(List_A, List_B, Temp),
	append(List_C, Temp, Result_list),
	add_trans_list(Result_list before Y).

add_transitive(X before Y) :-
	event(Y),
	\+event(X),
	assert(event(X)),
	setof(A, Y concurrent A, List_A),
	setof(B, B concurrent Y, List_B),
	setof(C, Y before C, List_C),
	append(List_A, List_B, Temp),
	append(List_C, Temp, Result_list),
	add_trans_list(X before Result_list).

%%%%%
%% add_trans_list/1 adds a whole list in the timeline before a certain event.

%% BEFORE OPERATOR
add_trans_list([] before  X) :-
	\+is_list(X), !.

add_trans_list([X|Rest] before Y) :-
	assert(X before Y),
	add_trans_list(Rest before Y).

add_trans_list(X before []) :-
	\+is_list(X), !.

add_trans_list(X before [Y|Rest]) :-
	assert(X before Y),
	add_trans_list(X before Rest).
		
