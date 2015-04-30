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
	event(X),
	\+event(Y),
	assert(event(Y)),
	write(step1),
	findall(A, X concurrent A, List_A),
	findall(B, B concurrent X, List_B),
	findall(C, C before X, List_C),
	write(step2),
	append(List_A, List_B, Temp),
	append(List_C, Temp, Result_list),
	write(step3),
	add_trans_list(Result_list before Y).

add_transitive(X before Y) :-
	event(Y),
	\+event(X),
	assert(event(X)),
	findall(A, Y concurrent A, List_A),
	findall(B, B concurrent Y, List_B),
	findall(C, Y before C, List_C),
	append(List_A, List_B, Temp),
	append(List_C, Temp, Result_list),
	add_trans_list(X before Result_list).

%% CONCURRENT OPERATOR
add_transitive(X concurrent Y) :-
	event(X),
	\+event(Y), !,
	assert(event(Y)),
	findall(A, X concurrent A, List_A),
	findall(B, B concurrent X, List_B),
	append(List_A, List_B, Conc_list),
	add_trans_list(Conc_list concurrent Y),
	findall(C, C before X, List_C),
	add_trans_list(List_C before Y),
	findall(D, X before D, List_D),
	add_trans_list(Y before List_D).

add_transitive(X concurrent Y) :-
	event(Y),
	\+event(X),
	add_transitive(Y concurrent X).	

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
		
%% CONCURRENT OPERATOR
add_trans_list([] concurrent Y) :-
	\+is_list(Y), !.

add_trans_list([X|Rest] concurrent Y) :-
	assert(X concurrent Y),
	add_trans_list(Rest concurrent Y).

%%%%%
%% generate_timelines/1

generate_timelines(Timelines) :-
	find_start(Start),
	find_direct_next(Start, Next)

%%%%%
%% find_start/1 finds the first element in a timeline (in case of ambiguity variations are generated later)

find_start(Result) :-
	Start before Next,
	\+_ before Start, !,
	findall(Conc1, Conc1 concurrent Start, List_A),
	findall(Conc2, Start concurrent Conc2, List_B),
	append(List_A, List_B, Temp),
	sort(Temp, Conc_List),
	append([Start], Conc_List, Inter_result),
	list_to_concurrent(Inter_result, Result), !.

find_start(Result) :-
	Start concurrent _,
	findall(Conc1, Conc1 concurrent Start, List_A),
	findall(Conc2, Start concurrent Conc2, List_B),
	append(List_A, List_B, Temp),
	sort(Temp, Conc_List),
	append([Start], Conc_List, Inter_result),
	list_to_concurrent(Inter_result, Result), !.

%%%%%
%% list_to_concurrent/2 transforms a list to the concurrent representation

list_to_concurrent([Last|[]], Last).

list_to_concurrent([H|Rest], H:Result) :-
	list_to_concurrent(Rest, Result).