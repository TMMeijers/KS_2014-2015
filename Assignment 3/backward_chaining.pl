%% Kennissystemen 2014-2015
%% Assignment 3 - MC4
%% Markus Pfundstein (10452397)
%% Thomas Meijers (10647023)
%%
%% Backward chaining rules for assignment 3.

maybe(X, Y) :-
	maybe_disease(X, Y), disease(Y).

maybe_disease(X, Y) :-
	if X then Y.

maybe_disease(X, Y) :-
	if X and _ then Y.

maybe_disease(X, Y) :-
	if _ and X then Y.

maybe_disease(X, Y) :-
	if X and _ and _ then Y.

maybe_disease(X, Y) :-
	if _ and X and _ then Y.

maybe_disease(X, Y) :-
	if _ and _ and X then Y.

maybe_disease(X, Y) :-
	if X and _ and _ and _ then Y.

maybe_disease(X, Y) :-
	if _ and X and _ and _ then Y.

maybe_disease(X, Y) :-
	if _ and _ and _ and X then Y.

maybe_disease(X, Y) :-
	if _ and _ and X and _ then Y.
 
is_true( P ):-
    fact( P ).

is_true( P ):-
    if Condition then P,
    is_true( Condition ).

is_true( P1 and P2 ):-
    is_true( P1 ),
    is_true( P2 ).

is_true( P1 or P2 ):-
    is_true( P1 )
    ;
    is_true( P2 ).