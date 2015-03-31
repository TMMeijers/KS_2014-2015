:- consult(knowledge_base).

%% Evaluates if X descends directly from Y
is_a(X, Y) :-
	descends_from(X, Y).

%% Evaluates if X is a descendent from Y
is_a(X, Z) :-
	descends_from(X, Y),
	is_a(Y, Z).

has_inner(X, VR, Y) :-
	has_relation(X, VR, Y).

has_inner(X, VR, Y) :-
	is_a(Z, Y),
	has_inner(X, VR, Z).

has_inner(X, VR, Y) :-
	is_a(X, Z), % find all from which X descends from
	has_inner(Z, VR, Y).

has(X, (Min/Max, Y)) :-
	has(X, Min/Max, Y).

has(X, Min/inf, Y) :-
	has_inner(X, Min/inf, Y).

has(X, Min/Max, Y) :-
	%range(L/R, Min/Max),
	has_inner(X, L/R, Y).

range(L/R, Min/inf) :-
	!,
	range(L/R, Min/10).

range(L/R, Min/Max) :-
	number(L),
	number(R),
	number(Min),
	number(Max),
	between(Min, Max, L),
	between(Min, Max, R),
	L =< R.

is_predecessor(X, Y) :-
	decends_from(Y, X).

match_by_attributes(What, Attributes, X) :-
	maplist(has(X), Attributes),
	\+concept(X).

classify(What, Attributes, NewSet) :-
	setof(C,
	      match_by_attributes(What, Attributes, C),
	      NewSet).
	      

%categorize(What, Attributes, X) :-
%	maplist(evaluate(X), Attributes),
	

:- dynamic(found/1).

evaluate(X, (VR, Y)) :-
	evaluate(X, VR, Y).

evaluate(X, Min/Max, Y) :-
	retractall(found(has(_,_,_))),
	evaluate_dynamic(X, Min/Max, Y).

evaluate_dynamic(X, Min/Max, Y) :-
	has(X, Min/Max, Y),
	not(found(has(X, Min/Max, Y))),
	assert(found(has(X, Min/Max, Y))).