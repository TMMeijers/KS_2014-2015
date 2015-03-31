:- consult(knowledge_base).

%% Evaluates if X descends directly from Y
is_a(X, Y) :-
	descends_from(X, Y).

%% Evaluates if X is a descendent from Y
is_a(X, Z) :-
	descends_from(X, Y),
	is_a(Y, Z).

has2(X, VR, Y) :-
	has_relation(X, VR, Y).

has2(X, VR, Y) :-
	is_a(Z, Y),
	has2(X, VR, Z).

has2(X, VR, Y) :-
	is_a(X, Z), % find all from which X descends from
	has2(Z, VR, Y).

has(X, Min/inf, Y) :-
	has2(X, Min/inf, Y).

has(X, Min/Max, Y) :-
	range(L/R, Min/Max),
	has2(X, L/R, Y).

%%has(X, VR, Y) :-
%%	range(A/B, VR),
%%	has(X, A/B, Y).	

range(L/R, Min/inf) :-
	!,
	range(L/R, Min/10).

range(L/R, Min/Max) :-
	between(Min, Max, L),
	between(Min, Max, R),
	L =< R.

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