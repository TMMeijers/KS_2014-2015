:- consult(knowledge_base).

%% Evaluates if X descends directly from Y
is_a(X, Y) :-
	descends_from(X, Y).

%% Evaluates if X is a descendent from Y
is_a(X, Z) :-
	descends_from(X, Y),
	is_a(Y, Z).

has(X, VR, Y) :-
	has_relation(X, VR, Y).

has(X, VR, Y) :-
	is_a(Z, Y),
	has(X, VR, Z).

has(X, VR, Y) :-
	is_a(X, Z), % find all from which X descends from
	has(Z, VR, Y).

%%has(X, VR, Y) :-
%%	range(A/B, VR),
%%	has(X, A/B, Y).	

range(L/R, Min/Max) :-
	between(Min, Max, L),
	between(Min, Max, R),
	R =< 10,
	L =< R.

:- dynamic(found/1).

evaluate(X, Min/Max, Y) :-
	retractall(found(has(_,_,_))),
	evaluate_dynamic(X, Min/Max, Y).

evaluate_dynamic(X, Min/Max, Y) :-
	has(X, Min/Max, Y),
	not(found(has(X, Min/Max, Y))),
	assert(found(has(X, Min/Max, Y))).