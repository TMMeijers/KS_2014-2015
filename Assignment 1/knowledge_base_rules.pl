:- consult(knowledge_base).

%% Evaluates if X descends directly from Y
is_a(X, Y) :-
	descends_from(X, Y).

%% Evaluates if X is a descendent from Y
is_a(X, Z) :-
	descends_from(X, Y),
	is_a(Y, Z).

%% A concept is a root of an inheritance tree, if it does
%% not have a ancestor
is_root_concept(X) :-
	\+descends_from(X, _).

%% Returns all relations that are _directly_ associated
%% with a concept. Thus doesn't walk the inheritance tree
%% back to the root
concept_relations(X, Rels) :-
	setof((VR,Rel), has_relation(X, VR, Rel), Rels).

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
	merge_relations_ordered(XRels,ARels,Rels).

%% takes two lists of relations [(VR1,Rel1),(VR2,Rel2)..]
%% and merges them. If second list has an element that already
%% sits in first list, the element of the _first_ list gets
%% chosen
merge_relations_ordered([],L,L).

merge_relations_ordered([(VR, RelName)|T],L,[(VR, RelName)|M]):-
	\+ member((_,RelName), L),
	!,
	merge_relations_ordered(T,L,M).

merge_relations_ordered([H|T],[_|LT], [H|M]) :-
	merge_relations_ordered(T,LT,M).