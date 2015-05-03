%% Kennissystemen Assignment 4
%% Universiteit van Amsterdam
%%
%% Thomas Meijers (10647023) & Jeroen Vranken (10658491)
%% May 3rd, 2015
%%
%% These are the rules for assignment 4, timeline reasoning.

%%%%%
%% permutate_timeline/2 joins all timelines and generates permutations
%% main is used as the main timeline, the other are joined to the main in join_time/3

permutate_timeline([Main|Timelines], Permutated) :-
	join_time(Main, Timelines, Permutated).

%%%%%
%% join_time/3 takes two timelines and generates a possible combination of the two (through scramble/3).

join_time(Permutated, [], Permutated).

join_time(Main, [Time|Rest], Permutated) :-
	scramble(Main, Time, Result),
	join_time(Result, Rest, Permutated).

%%%%%
%% scramble/3 is used to call scramble/4 with an initialised buffer.

scramble(Main, Timelines, Result) :-
	scramble(Main, Timelines, [], Result, none_).

%%%%%
%% scramble/4 Takes two timelines, main and an auxillary and generates a possible permutation by
%% adding all elements of the auxillary timelines. The third argument is the buffer which holds
%% events that should be added.

scramble(Result, [], [], Result, _) :- !.

scramble(Main, [], Buffer, Result, Add_behind) :-
	perm_concurrent(Main, none_, Add_behind, Buffer, Result).

%% If we have the same event in both lists add the buffer to the main timeline.
scramble(Main, [H|Rest], Buffer, Result, Add_behind) :-
	conc_member(H, Main),
	\+length(Buffer, 0), !,
	perm_concurrent(Main, H, Add_behind, Buffer, Perm),
	scramble(Perm, Rest, [], Result, none_). % reinitialise buffer

%% If we encounter multiple members after another dont add to buffer
scramble(Main, [H|Rest], [], Result, _) :-
	conc_member(H, Main), !,
	scramble(Main, Rest, [], Result, H).

%% If we see new events add them to the buffer
scramble(Main, [H|Rest], Buffer, Result, Add_behind) :-
	scramble(Main, Rest, [H|Buffer], Result, Add_behind).

%%%%%
%% conc_member/2 works like member/2 but also checks concurrent events (notation a:b)

conc_member(_, []) :-
	!, fail.

conc_member(H, [H|_]) :- !.

conc_member(H, [H:_|_]) :- !.

conc_member(H, [_:Other|Rest]) :-
	conc_member(H, [Other|Rest]), !.

conc_member(H, [_|Rest]) :-
	conc_member(H, Rest).

%%%%%
%% perm_concurrent/4 adds an event to the main timeline. Generates permutations and/or concurrent events.

perm_concurrent(Result, _, _, [], Result) :- !.

perm_concurrent(Main, Add_before, none_, [Insert|Buffer], New) :-
	!,
	insert_before(Main, Add_before, Insert, Result),
	perm_concurrent(Result, Insert, none_, Buffer, New).

perm_concurrent(Main, none_, Add_after, [Insert|Buffer], New) :-
	!,
	insert_after(Main, Add_after, Insert, Result),
	perm_concurrent(Result, Insert, Add_after, Buffer, New).

perm_concurrent(Main, Add_before, Add_after, [Insert|Buffer], New) :-
	Add_before \= none_,
	Add_after \= none_, !,
	insert_between(Main, Add_after, Add_before, Insert, Result),
	perm_concurrent(Result, Insert, Add_after, Buffer, New).

%%%%%
%% insert_before/4 inserts an item before Max, or makes it concurrent with the item. Will generate all permutations

%% insert item before max
insert_before(Main, Max, Elem, Result) :-
	split(Main, Max, Before, After),
	append(Before, [Elem], First_half),
	append(First_half, After, Result).

%% make concurrent with item before max
insert_before(Main, Max, Elem, Result) :-
	nextto(Conc, Max, Main),
	split(Main, Max, Before, After),
	select(Conc, Before, Before_min1),
	make_concurrent(Conc, Elem, Conc_event),
	append(Before_min1, Conc_event, First_half),
	append(First_half, After, Result).

%% moves one element to the front
insert_before(Main, Max, Elem, Result) :-
	nextto(Prev, Max, Main), !,
	insert_before(Main, Prev, Elem, Result).

insert_before(Main, _, Elem, Result) :-
	append([Elem], Main, Result).

%%%%%
%% insert_after/4 inserts an item after Min, or generates concurrent events.

insert_after(Main, Min, Elem, Result) :-
	nextto(Min, Next, Main),
	split(Main, Next, Before, After),
	append([Elem], After, Second_half),
	append(Before, Second_half, Result).

insert_after(Main, Min, Elem, Result) :-
	nextto(Min, Next, Main),
	split(Main, Next, Before, After),
	select(Next, After, After_min1),
	make_concurrent(Next, Elem, Conc_event),
	append(Conc_event, After_min1, Second_half),
	append(Before, Second_half, Result).

insert_after(Main, Min, Elem, Result) :-
	nextto(Min, Next, Main), !,
	insert_after(Main, Next, Elem, Result).

insert_after(Main, _, Elem, Result) :-
	append(Main, [Elem], Result).

%%%%%
%% insert_between/5 inserts an event (or makes it concurrent) between Min and Max.

insert_between(Main, Min, Max, Elem, Result) :-
	nextto(Min, Next, Main),
	Next \= Max,
	split(Main, Next, Before, Temp),
	split(Temp, Max, Middle, After),
	append([Elem], Middle, New_middle),
	append(Before, New_middle, First_half),
	append(First_half, After, Result).

insert_between(Main, Min, Max, Elem, Result) :-
	nextto(Min, Next, Main),
	Next \= Max,
	split(Main, Next, Before, Temp),
	split(Temp, Max, Middle, After),
	select(Next, Middle, Middle_min1),
	make_concurrent(Next, Elem, Conc_event),
	append(Conc_event, Middle_min1, Middle_new),
	append(Before, Middle_new, First_half),
	append(First_half, After, Result).

insert_between(Main, Min, Max, Elem, Result) :-
	nextto(Min, Next, Main),
	Next \= Max, !,
	insert_between(Main, Next, Max, Elem, Result).

insert_between(Main, _, Max, Elem, Result) :-
	split(Main, Max, Before, After),
	append([Elem], After, Second_half),
	append(Before, Second_half, Result).

%%%%%
%% make_concurrent/3 makes Event concurrent with main

make_concurrent(Main, Event, [Main:Event]) :-
	atom(Main), !.

make_concurrent(H:Rest, Event, [Event:H:Rest]) :-
	atom(H).

%%%%%
%% split/4 splits a list at item H (H is included in the second half).

split([H|Rest], H, [], [H|Rest]) :- !.

split([H|Rest], Split, [H|Before], After) :-
	H \= Split,
	split(Rest, Split, Before, After).
	
%%%%%
%% flatten_timelines/2 joins all timelines (lists) in one big list, one level of nesting is removed.

flatten_timelines([], []).

flatten_timelines([H|Rest], Result) :-
	flatten_timelines(Rest, Temp),
	append(H, Temp, Result).

%%%%%
%% generate_multiple/2 generates all possible (seperate) timelines, uses generate/2

generate_multiple([], []).

generate_multiple([S|Rest], [Result|Timelines]) :-
	setof(T, generate(S, T), Result),
	generate_multiple(Rest, Timelines).

%%%%%
%% generate/2 generates a possible (seperate) timeline.

generate(Current, [Result|Timeline]) :-
	Current before Next,
	get_all_concurrent(Current, Concurrent),
	list_to_concurrent(Concurrent, Result),
	generate(Next, Timeline).

generate(Current, [Result]) :-
	\+Current before _,
	get_all_concurrent(Current, Concurrent),
	list_to_concurrent(Concurrent, Result).

%%%%%
%% print_multiple/1 prints all timelines in the list.

print_multiple([]).

print_multiple([T|Rest]) :-
	write('START '),
	print_timeline(T),
	print_multiple(Rest).

%%%%%
%% print_timeline/1 prints all events in a timelines.

print_timeline([Last|[]]) :-
	write(Last),
	write(' END.'), nl.

print_timeline([Event|Rest]) :-
	length(Rest, N),
	N \= 0,
	write(Event),
	write(' -> '),
	print_timeline(Rest).

%%%%%
%% add_points/1 adds all relations between events and gives feedback.

add_points([]).

add_points([H|Rest]) :-
	write('Added: '),
	write(H), nl,
	add(H),
	add_points(Rest).
	
%%%%%
%% check_inconsistent/1 checks if the fact to be added is inconsistent. 

check_inconsistent(X before Y) :-
	Y concurrent X;
	X concurrent Y,
	format('CONTRADICTION: ~p and ~p are concurrent!', [Y, X]).

check_inconsistent(X before Y) :-
	is_before(Y, X),
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
% if illegally trying to start new timeline
add(X before Y) :-
	\+event(X),
	\+event(Y),
	event(_), !,
	write('Cannot start seperate timeline while currently there is one in the knowledge base.'), nl.

% for new timeline
add(X before Y) :-
	\+event(X),
	\+event(Y), !,
	write('Started new timeline!'), nl,
	assert(event(X)),
	assert(event(Y)),
	assert(X before Y).

% adding events to existing timeline
add(X before Y) :-
	check_if_event(X),
	check_if_event(Y),
	\+X before Y,
	\+check_inconsistent(X before Y), % TODO RECURSIVELY
	add_transitive(X before Y).

%% CONCURRENT OPERATOR
% if illegally trying to start new timeline
add(X concurrent Y) :-
	\+event(X),
	\+event(Y),
	event(_), !,
	write('Cannot start seperate timeline while currently there is one in the knowledge base.'), nl.

% for new timelines
add(X concurrent Y) :-
	\+event(X),
	\+event(Y), !,
	write('Started new timeline!'), nl,
	assert(event(X)),
	assert(event(Y)),
	assert(X concurrent Y).

% adding events to existing timeline
add(X concurrent Y):-
	check_if_event(X),
	check_if_event(Y),
	\+X concurrent Y,
	\+check_inconsistent(X concurrent Y), % TODO RECURSIVELY
	add_transitive(X concurrent Y).

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
	add_trans_list(Conc_X concurrent Conc_Y),
	get_all_before(X, Before_X),
	get_all_before(Y, Before_Y),
	get_all_after(X, After_X),
	get_all_after(Y, After_Y),
	add_trans_list(Before_X before Conc_Y),
	add_trans_list(Before_Y before Conc_X),
	add_trans_list(Conc_Y before After_X),
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
	\+H concurrent Event,
	Event \= H, !,
	assert(Event concurrent H),
	add_trans_single(Event concurrent Rest).

add_trans_single(Event concurrent [_|Rest]) :-
	add_trans_single(Event concurrent Rest).
	
%%%%%
%% generate_timelines/1

generate_timeline(Timelines) :-
	generate_timeline(Timelines, []).

generate_timeline(Timelines, List) :-
        find_start(Start),
	append(List, Start, Current),
	next_event(Current, Timelines).

%%%%%
%% next_event/2 finds the next event

%%%%%
%% find_start/1 finds the first element in a timeline (in case of ambiguity variations are generated later)

find_start(Result) :-
	Start before _,
	\+_ before Start,
	get_all_concurrent(Start, Result).
	 
find_start(Result) :-
	Start concurrent _,
	get_all_concurrent(Start, Result).

%%%%%
%% find_direct_next/2 finds the next event based on the first argument

find_direct_next([Current|_], [Next]) :-
	atom(Current),
	get_next(Current, Next).

get_next(Current, Result) :-
	Current before Next, !,
	get_all_concurrent(Next, Result).

get_next(_, []).
	
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