%% Kennissystemen 2014-2015
%% Universiteit van Amsterdam
%%
%% Jeroen Vranken (10658491)
%% Thomas Meijers (10647023)
%%
%% Assignment 5 - GDE
%% 23-05-2015
%%
%%  gde.pl is the general diagnostic engine, it can diagnose systems consisting of adders and multipliers.

%%%%%
%% load_model/0 loads the model in the system and gives output.

load_model :-
	write('Loading all components...'), nl,
	components(Components),
	format('Components loaded: ~p.~n~n', [Components]),
	write('Asserting correct model, forward chaining...'), nl,
	assert_model_forward(Components), nl,
	conflict_recognition(Conflict_set),
	candidate_generation(Conflict_set, Candidates).

%%%%
%% assert_model_forward/1 uses forward chaining to make predictions based on the input.
%% the system assumes that the input is not faulty.

assert_model_forward([]).

assert_model_forward([Component|Rest]) :-
	forward_inference(Component),
	assert_model_forward(Rest).

%%%%%
%% forward_inference/1 reasons about componenets and the output they should have. This is used
%% as the default correct input (the default non-faulty model)

forward_inference(Component):-
	sub_atom(Component, 0, 1, _, m),
	In1 in Component,
	In2 in Component,
	number(In1),
	number(In2),
	In1 \= In2,
	multiplier(In1, In2, Output), !,
	format('Asserted ~p predicts ~p.~n', [Component, Output]),
	assert(Component predicts Output). % Since this simulates the correct model

forward_inference(Component) :-
	sub_atom(Component, 0, 1, _, m),
	C1 in Component,
	C2 in Component,
	C1 \= C2,
	C1 predicts In1,
	C2 predicts In2,
	multiplier(In1, In2, Output), !,
	format('Asserted ~p predicts ~p.~n', [Component, Output]),
	assert(Component predicts Output). % Since this simulates the correct model

forward_inference(Component):-
	sub_atom(Component, 0, 1, _, a),
	In1 in Component,
	In2 in Component,
	number(In1),
	number(In2),
	In1 \= In2,
	adder(In1, In2, Output), !,
	format('Asserted ~p predicts ~p.~n', [Component, Output]),
	assert(Component predicts Output). % Since this simulates the correct model

forward_inference(Component) :-
	sub_atom(Component, 0, 1, _, a),
	C1 in Component,
	C2 in Component,
	C1 \= C2,
	C1 predicts In1,
	C2 predicts In2,
	adder(In1, In2, Output), !,
	format('Asserted ~p predicts ~p.~n', [Component, Output]),
	assert(Component predicts Output). % Since this simulates the correct model

%%%%%
%% backward_inference/4 can give inputs based on the output. Can of course also be used for forward inference

backward_inference(Component, In1, In2, Out) :-
	sub_atom(Component, 0, 1, _, a),
	adder(In1, In2, Out).

backward_inference(Component, In1, In2, Out) :-
	sub_atom(Component, 0, 1, _, m),
	multiplier(In1, In2, Out).

%%%%%
%% conflict_recognition/1 returns the minimum conflict set, it starts probing at the output nodes

conflict_recognition(Conflict_set) :-
	componenets(Comps),
	reverse(Comps, Components), % reverse so we start at output nodes
	conflict_recognition(Components, Conflict_set).

%%%%%
%% conflict_recognition/2 checks per component if it should be included in the minimum conflict set

conflict_recognition([], []).

conflict_recognition([Component|Rest], Result) :-
	Component predicts Correct,
	Component ouputs Output,
	Correct =:= Output, !,
	format('~p outputs ~p as expected.~n', [Component, Correct]),
	conflict_recognition(Rest, Result).

conflict_recognition([Component|Rest], [Component|Result]) :-
	Component predicts Correct.

%%%%%
%% candidate_generation/1 generates candidates based on the minimum conflict set.

candidate_generation([], []) :- !,
	write('Empty conflict set, the systems exhibits no faulty outputs.'), nl, nl.