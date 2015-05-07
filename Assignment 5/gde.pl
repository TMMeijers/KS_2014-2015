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
	components(Comps),
	format('Components loaded: ~p.~n~n', [Comps]),
	write('Asserting correct model, forward chaining...'), nl,
	assert_model_forward(Comps), nl,
	conflict_recognition(Min_conflict_set).

%%%%
%% assert_model_forward/1 uses forward chaining to make predictions based on the input.
%% the system assumes that the input is not faulty.

assert_model_forward([]).

assert_model_forward([Comp|Rest]) :-
	forward_inference(Comp),
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
%% backward_inference/4 can give inputs based on the output. Can of course also be used for forward inference.

backward_inference(Comp, In1, In2, Out) :-
	sub_atom(Comp, 0, 1, _, a),
	adder(In1, In2, Out).

backward_inference(Comp, In1, In2, Out) :-
	sub_atom(Comp, 0, 1, _, m),
	multiplier(In1, In2, Out).