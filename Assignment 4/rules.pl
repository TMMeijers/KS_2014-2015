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

%% BEFORE OPERATOR
add(X before Y) :-
	\+event(X),
	\+event(Y),
	event(_), !,
	write('Cannot start seperate timeline while currently there is one in the knowledge base.'), nl.

add(X before Y) :-
	\+event(X),
	\+event(Y), !,
	write('Started new timeline!'), nl,
	assert(event(X)),
	assert(event(Y)),
	assert(X before Y).

add(X before Y) :-
	check_if_event(X),
	check_if_event(Y),
	\+X before Y,
	\+check_inconsistent(X before Y), % TODO RECURSIVELY
	add_transitive(X before Y),
	assert(X before Y).

%% CONCURRENT OPERATOR
add(X concurrent Y) :-
	\+event(X),
	\+event(Y),
	event(_), !,
	write('Cannot start seperate timeline while currently there is one in the knowledge base.'), nl.

add(X concurrent Y) :-
	\+event(X),
	\+event(Y), !,
	write('Started new timeline!'), nl,
	assert(event(X)),
	assert(event(Y)),
	assert(X concurrent Y).

add(X concurrent Y):-
	check_if_event(X),
	check_if_event(Y),
	\+X concurrent Y,
	\+check_inconsistent(X concurrent Y), % TODO RECURSIVELY
	add_transitive(X concurrent Y),
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
	get_all_concurrent(X, Conc_X),
	get_all_concurrent(Y, Conc_Y),
	add_trans_list(Conc_X before Conc_Y).

%% CONCURRENT OPERATOR
add_transitive(X concurrent Y) :-
	get_all_concurrent(X, Conc_X),
	get_all_concurrent(Y, Conc_Y),
	add_trans_list(Conc_X, Conc_Y),
	get_all_before(X, Before_X),
	get_all_before(Y, Before_Y),
	get_all_after(X, After_X),
	get_all_after(Y, After_Y),
	add_trans_list(Before_X before Conc_Y),
	add_trans_list(Before_Y before Conc_X),
	add_trans_liset(Conc_Y before After_X),
	add_trans_list(Conc_X before After_Y).

%%%%%
%% add_trans_list/1 adds a whole list in the timeline before a certain event.

%% BEFORE OPERATOR
add_trans_list([] before _).

add_trans_list([H|Rest] before List) :-
	add_trans_single(H before List),
	add_trans_list(Rest before List).

%% CONCURRENT OPERATOR
add_trans_list([] concurrent _).

add_trans_list([H|Rest] concurrent List) :-
	add_trans_single(H concurrent List),
	add_trans_list(Rest concurrent List).

%%%%%
%% add_trans_single/1 recursively adds an event to a list of concurrent events

%% BEFORE OPERATOR
add_trans_single(_ before []).

add_trans_single(Event before [H|Rest]) :-
	\+Event before H,
	Event \= H, !,
	assert(Event before H),
	add_trans_single(Event before Rest).

add_trans_single(Event before [_|Rest]) :-
	add_trans_single(Event before Rest).

%% CONCURRENT OPERATOR
add_trans_single(_ concurrent []).

add_trans_single(Event concurrent [H|Rest]) :-
	\+Event concurrent H,
	Event \= H, !,
	assert(Event concurrent H),
	add_trans_single(Event concurrent Rest).
	
%%%%%
%% generate_timelines/1

generate_timelines(Timelines) :-
	find_start(Start),
	find_direct_next(Start, Next), !.

%%%%%
%% find_start/1 finds the first element in a timeline (in case of ambiguity variations are generated later)

find_start(Result) :-
	Start before _,
	\+_ before Start,
	get_all_concurrent(Start, Result), !.
	 
find_start(Result) :-
	Start concurrent _,
	get_all_concurrent(Start, Result), !.

%%%%%
%% find_direct_next/2 finds the next event based on the first argument

find_direct_next([Current|_], Next) :-
	atom(Current),
	get_next(Current, Next).

find_direct_next(_/[Current|_], Next) :-
	atom(Current),
	get_next(Current, Next).

get_next(Current, Result) :-
	Current before Next, !,
	get_all_concurrent(Next, Result).

get_next(Current, []).
	
%%%%%
%% get_all_concurrent/2 gets all concurrent events

get_all_concurrent(Event, Result) :-
	findall(Conc1, Conc1 concurrent Event, List_A),
	findall(Conc2, Event concurrent Conc2, List_B),
	append([Event|List_A], List_B, Temp),
	sort(Temp, Temp2),
	flatten(Temp2, Result).

%%%%%
%% get_all_before/2 gets all events before

get_all_before(Event, Result) :-
	findall(Before, Before before Event, Result).

%%%%%
%% get_all_after/2 gets all events after

get_all_after(Event, Result) :-
	findall(After, Event before After, Result).

%%%%%
%% list_to_concurrent/2 transforms a list to the concurrent representation

list_to_concurrent([Last|[]], Last).

list_to_concurrent([H|Rest], H:Result) :-
	list_to_concurrent(Rest, Result).