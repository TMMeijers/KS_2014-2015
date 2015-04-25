%% Kennissystemen 2014-2015
%% Assignment 3 - MC4
%% Markus Pfundstein (10452397)
%% Thomas Meijers (10647023)
%%
%% Forward chaining rules for assignment 3.

forward :-
	new_derived_fact(P),
	\+disease(P),
	!,
	write(P), write(' toegevoegd aan het symptoomdomein.'), nl,
	assert(fact(P)),
	forward;
	true.


new_derived_fact( Conclusion ) :-
	if Condition then Conclusion,
	not( fact( Conclusion ) ),
	composed_fact( Condition ).

composed_fact( Condition ) :-
	fact( Condition ).

composed_fact( Condition1 and Condition2 ) :-
	composed_fact( Condition1 ),
	composed_fact( Condition2 ).

composed_fact( Condition1 or Condition2 ) :-
	composed_fact( Condition1 )
	;
	composed_fact( Condition2 ).