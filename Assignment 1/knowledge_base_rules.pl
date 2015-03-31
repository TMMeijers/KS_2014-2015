:- consult(knowledge_base).

%% Evaluates if X descends directly from Y
is_a(X, Y) :-
	descends_from(X, Y).

%% Evaluates if X is a descendent from Y
is_a(X, Z) :-
	descends_from(X, Y),
	is_a(Y, Z).

range(L/R, Min/inf) :-
	!,
	range(L/R, Min/10).

range(L/R, Min/Max) :-
	number(Min), number(Max),
	between(Min, Max, L),
	between(Min, Max, R),
	L =< R.
		     
%% A concept is a root of an inheritance tree, if it does
%% not have a ancestor
is_root_concept(X) :-
	\+descends_from(X, _).

%% Returns all relations that are _directly_ associated
%% with a concept. Thus doesn't walk the inheritance tree
%% back to the root
concept_relations(X, Rels) :-
	setof((VR,Rel), has_relation(X, VR, Rel), Rels).

%has(X, VR, Y) :-
%	has_relation(X, VR, Y).

%has(X, VR, Y) :-%
%	is_a(Z, Y),
%	has_inner(X, VR, Z).

%has(X, VR, Y) :-
%	is_a(X, Z), % find all from which X descends from
%	has_inner(Z, VR, Y).

%% walks inheritance tree and collects all relations
%% E.g.,
%% ?- all_relations(human, X).
%% X = [ (2/2, arm), (2/2, leg), (0/inf, birth), (0/inf, limb),
%% (0/inf, reproduction), (1/inf, movement_type)].
all_relations(X, Rels) :-
	is_root_concept(X),
	!,
	concept_relations(X, Rels).

all_relations(X, Rels) :-
	% take ancestor
	is_a(X, Y),
	all_relations(Y, ARels),
	!,
	concept_relations(X, XRels),
	merge_relations_ordered(ARels,XRels,Rels).

ar(X, Rels) :-
	is_root_concept(X), !,
	write('AR ROOT: '), write(X), nl,
	concept_relations(X, Rels),
	write('AR ROOT RELS: '), write(Rels), nl.

ar(X, Rels) :-
	descends_from(X, Y),
	concept_relations(X, XRels),
	!,
	ar(Y, YRels),
	write('merge: '), write(YRels),nl,
	write('   with: '),write(XRels),nl,
	merge_relations_ordered(YRels, XRels, Rels),
	write('Res: '),write(Rels),nl.

ar(X, Rels) :-
	descends_from(X, Y),
	ar(Y, Rels).

%% takes two lists of relations [(VR1,Rel1),(VR2,Rel2)..]
%% and merges them. If second list has an element that already
%% sits in first list, the element of the _SECOND_ list gets
%% chosen
merge_relations_ordered([],L,L).

merge_relations_ordered([(VR, RelName)|T],L,[(VR, RelName)|M]):-
	%write('VR: '), write(VR), nl,
	%write('RelName: '), write(RelName), nl,
	%write('L: '), write(L), nl,
	\+member((_,RelName), L),
	%write('passed'),nl,
	!,
	merge_relations_ordered(T,L,M).

merge_relations_ordered([_|T],[H|LT], [H|M]) :-
	!,
	merge_relations_ordered(T,LT,M).

%% Evaluates if some relation holds for a item
%% E.g.,
%% if defined: has_relation(dog, 0/inf, birth)
%% then: relations_holds(dog, 0/2, birth)
%% should return true
relation_holds(X, Min/_, Rel) :-
	has_relation(X, Min/inf, Rel).

relation_holds(X, Min/Max, Rel) :-
	range(L/R, Min/Max),
	has_relation(X, L/R, Rel).

%% backtrack
walk_list([H|_], H).

walk_list([_|Xs], H) :-
	walk_list(Xs, H).

%% forward chains through whole database
%% and adds stuff if not known
%% Cmd:
%% Concept = eagle, all_relations(Concept, X), walk_list(X, (Min/Max, RelName)), \+has_relation(Concept, Min/Max, RelName), assert(has_relation(Concept, Min/Max, RelName)).
%forward_chain_knowledge(Concept) :-
	% get all relations down to root node
	% that are known for a concept
%	all_relations(Concept, AllRelations),
	