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
	format('Found the following minimum conflict set: ~p.~n~n', [Conflict_set]),
	candidate_generation(Conflict_set, Candidates),
	write('Determining probe points...'), nl,
	probe_points(Candidates).

%%%%
%% assert_model_forward/1 uses forward chaining to make predictions based on the input.
%% the system assumes that the input is not faulty.

assert_model_forward([]).

assert_model_forward([Component|Rest]) :-
	forward_inference(Component),
	assert_model_forward(Rest).

%%%%%
%% forward_inference/1 reasons about components and the output they should have. This is used
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
	components(Comps),
	reverse(Comps, Components), % reverse so we start at output nodes
	conflict_recognition(Components, Conflict_set).

%%%%%
%% conflict_recognition/2 checks per component if it should be included in the minimum conflict set
%% as discussed in class, we are assuming that only one component is faulty. So when faulty output it
%% found we will return the minimum conflict set.

conflict_recognition([], []).

conflict_recognition([Component|Rest], Result) :-
	Component predicts Correct,
	Component outputs Output,
	Correct =:= Output, !,
	format('~p outputs ~p as expected.~n', [Component, Correct]),
	conflict_recognition(Rest, Result).

conflict_recognition([Component|_], Result) :-
	Component predicts Correct,
	Component outputs Output,
	format('FAULT: ~p outputs ~p, expected ~p.~n', [Component, Output, Correct]),
	generate_conflict_set(Component, Result).

%%%%%
%% generate_conflict_set/2 returns the minimum conflict set based on the given component

generate_conflict_set(Component, Result) :-
	setof(C, C in Component, Temp),
	filter_inputs(Temp, Filtered),
	append([Component], Filtered, Result).

%%%%%
%% filter_inputs/2 filters the inputs out of the list

filter_inputs([], []).

filter_inputs([H|Rest], Result) :-
	number(H), !,
	filter_inputs(Rest, Result).

filter_inputs([H|Rest], [H|Result]) :-
	filter_inputs(Rest, Result).
	
%%%%%
%% candidate_generation/1 generates candidates based on the minimum conflict set

candidate_generation([], []) :- !,
	write('Empty conflict set, the systems exhibits no faulty outputs.'), nl, nl.

candidate_generation(Candidates, Result) :-
	check_conflicts(Candidates, [Contradictions], Conflicts),
	format('~n~nExpanding ~p with the new conflict set:~p.~n~n', [Contradictions, Conflicts]),
	format('Eliminating...~n'),
	make_superset(Contradictions, Conflicts, Result, Candidates),
	format('Generated the following minimal candidate sets: ~p~n~n', [Result]).

%%%%%
%% make_superset/4 expands the new element with all the conflict sets

make_superset(_, [], [], _).

make_superset(Contradict, [Conflict|Rest], [[Contradict, Conflict]|Result], Candidates) :-
	\+member(Conflict, Candidates), !,
	make_superset(Contradict, Rest, Result, Candidates).

make_superset(Contradict, [Conflict|Rest], [[Conflict]|Result], Candidates) :-
	make_superset(Contradict, Rest, Result, Candidates).

%%%%%
%% check_conflicts/3 returns the new minimal candidates, keeps track of componenets
%% no longer explaining all the outputs.

check_conflicts([], [], []) :- !.

check_conflicts([C|Rest], Contradictions, [C|Conflicts]) :-
	format('~nChecking ~p', [C]),
	setof(Next, C in Next, Inputs),
	no_contradiction(Inputs), !,
	format(', not inconsistent, added to new conflict set.'),
	check_conflicts(Rest, Contradictions, Conflicts).

check_conflicts([C|Rest], [C|Contradictions], [New, New_input|Conflicts]) :-
	format('~nChecking ~p', [C]),
	setof(Next, C in Next, Check_comps), !,
	find_correct(Check_comps, New),
	format(', contradiction! ~p produces inconsistent output.~n', [New]),
	setof(In, In in New, Inputs),
	select(C, Inputs, [New_input]),
	format('Added ~p to contradictions (not explaining all faults),~nAdded ~p and ~p to the new conflict set.', [C, New, New_input]),
	check_conflicts(Rest, Contradictions, Conflicts).	

check_conflicts([C|Rest], Contradictions, [C|Conflicts]) :-
	format('~nChecking ~p, not inconsistent, added to new conflict set.', [C]),
	\+C in _,
	check_conflicts(Rest, Contradictions, Conflicts).

%%%%%
%% find_correct/2 returns components with correct output, our system only has binary input / output
	
find_correct([C|_], C) :-
	C outputs Output,
	C predicts Correct,
	Output =:= Correct, !.
	     
find_correct([_|[Rest]], Rest).
		
	
%%%%%
%% no_contradiction/1 checks if nothing contradicts (we expect faulty output!)

no_contradiction([]).

no_contradiction([Comp|Rest]) :-
	Comp outputs Output,
	Comp predicts Correct,
	Output =\= Correct,
	no_contradiction(Rest).

%%%%%
%% probe_points/1 determines probe points and then probes

probe_points(Candidates) :-
	calc_probs(Candidates, Probs, Pure_probs),
	sort(Pure_probs, Sorted_probs),
	sort_probs(Probs, Sorted_probs, Rev),
	reverse(Rev, Sorted),
	format('Probing candidates in the following order: ~p.~n~n', [Sorted]),
	format('Probing...~n'),
	probe(Sorted).

%%%%%
%% probe/1 probes the probe points in the given order

probe([]) :- !.

probe([Set|Rest]) :-
	format('Probing the following candidate set: ~p.~n', [Set]),
	probe_candidate(Set, work), !,
	probe(Rest).

probe([Set|_]) :- 
	probe_candidate(Set, fault),
	format('Please replace the faulty component, thanks for using GDE.~n~n').

probe_candidate([], work) :- !.

probe_candidate([C|Rest], Working) :-
	C predicts Correct,
	C outputs Output,
	Correct =:= Output, !,
	format('~p functioning normally.~n', [C]),
	probe_candidate(Rest, Working).

probe_candidate([C|_], fault) :-
	format('FAULTY COMPONENT FOUND: ~p!~n', [C]).

%%%%%
%% sort_probs/3 sorts the set of candidate lists

sort_probs(_, [], []) :- !.

sort_probs(Candidates, [Lowest|Rest], [Set|Result]) :-
	get_lowest_set(Candidates, Lowest, Set),
	sort_probs(Candidates, Rest, Result).

%%%%%
%% get_lowest_set/3 returns the candidate set corresponding to the prob.

get_lowest_set([C:Prob|_], Prob, C) :- !.

get_lowest_set([_|Rest], Prob, C) :-
	get_lowest_set(Rest, Prob, C).

%%%%%
%% calc_probs/3 calculdates probabilities of candidate sets

calc_probs([], [], []).

calc_probs([H|Candidates], [H:Prob|Result], [Prob|Probs]):-
	components(Comps),
	filter_comps(H, Comps, Filtered),
	candidate_prob(H, Filtered, 1, Prob),
	format('The probability of ~p being faulty is: ~p~n', [H, Prob]),
	calc_probs(Candidates, Result, Probs).

%%%%%
%% filter_comps/3 filters the list of components of faulty components

filter_comps(_, [], []) :- !.

filter_comps(Candidates, [C|Rest], Result) :-
	member(C, Candidates), !,
	filter_comps(Candidates, Rest, Result).

filter_comps(Candidates, [C|Rest], [C|Result]) :-
	filter_comps(Candidates, Rest, Result).

%%%%%
%% candidate_prob/4 calculates the probability

candidate_prob([], Working, Current, Result) :-
	multiply_good(Working, Current, Result).

candidate_prob([H|Rest], Working_comps, Current, Result):-
	sub_atom(H, 0, 1, _, m),
	multiplier_fault(Value),
	Current_prob is Current * Value,
	candidate_prob(Rest, Working_comps, Current_prob, Result).

candidate_prob([H|Rest], Working_comps, Current, Result):-
	sub_atom(H, 0, 1, _, a),
	adder_fault(Value),
	Current_prob is Current * Value,
	candidate_prob(Rest, Working_comps, Current_prob, Result).

%%%%%
%% multiply_good/3 multiplies prob with prob of the working components

multiply_good([], Result, Result) :- !.

multiply_good([C|Rest], Current, Result) :-
	sub_atom(C, 0, 1, _, m),
	multiplier_working(Value),
	New is Value * Current,
	multiply_good(Rest, New, Result).


multiply_good([C|Rest], Current, Result) :-
	sub_atom(C, 0, 1, _, a),
	adder_working(Value),
	New is Value * Current,
	multiply_good(Rest, New, Result).






















