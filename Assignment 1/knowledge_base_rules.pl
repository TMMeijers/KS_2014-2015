%% KENNISSYSTEMEN 2014-2015, UVA
%%
%% Contributors: M. Pfundstein & T.M. Meijers
%% Date: April 5th, 2015
%%
%% This file contains all the base rules to work with
%% and check information in the knowledge base.
%%
%% Instructions: Consult ks_assignment1_pfundstein_meijers.pl


%% adds or updates a relation in the knowledge base
kb_relation_add_or_update(Concept, Min/Max, Rel) :-
	% relation does exist
	retractall(has_relation(Concept, _/_, Rel)),
	assert(has_relation(Concept, Min/Max, Rel)).

kb_relation_add_or_update(Concept, Min/Max, Rel) :-
	assert(has_relation(Concept, Min/Max, Rel)).

%% find_all_ancestors
all_ancestors(Concept, Ancestors) :-
	bagof(X, is_a(Concept, X), Ancestors).

%% Evaluates if X descends directly from Y
is_a(X, Y) :-
	descends_from(X, Y).

%% Evaluates if X is a descendent from Y
is_a(X, Z) :-
	descends_from(X, Y),
	is_a(Y, Z).

%% produces a range of numbers expressed as a range
range(L/_, Min/inf) :-
	!,
	L >= Min.

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

concept_relations(_, []).

%% checks if a relation holds for an animal and all ancestors
has(Concept, (VR, RelName)) :-
	has(Concept, VR, RelName).
	
has(X, VR, Y) :-
	relation_holds(X, VR, Y).

has(X, VR, Y) :-
	is_a(X, Z), % find all from which X descends from
	has(Z, VR, Y).

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
	merge_relations_ordered(ARels, XRels, Rels), !.

%% Does the same as all_relations but filters relations which are
%% already specified more specifically in the relations list.
%% E.G. Doesn't include (0/inf, limb) when (2/2, leg) is already
%% present.
filtered_relations(X, Rels) :-
	is_a(X, Y),
	all_relations(Y, ARels),
	!,
	concept_relations(X, XRels),
	merge_relations_ordered(ARels, XRels, Unfiltered),
	filter_parent_relations(Unfiltered, Rels).

filter_parent_relations([], []).

% If we have descendants of the relation present drop it.
filter_parent_relations([H|T], L) :-
	descendants_present(H, T), !,
	filter_parent_relations(T, L).

filter_parent_relations([H|T], [H|L]) :-
	filter_parent_relations(T, L).

% Check if any descendants in the list
descendants_present((_, Rel), L) :-
	descends_from(Child, Rel),
	member((_, Child), L).

% Check for descendants of descendants etc.
descendants_present((_, Rel), L) :-
	descends_from(Child, Rel),
	descendants_present((_, Child), L).


%% takes two lists of relations [(VR1,Rel1),(VR2,Rel2)..]
%% and merges them. If second list has an element that already
%% sits in first list, the element of the _SECOND_ list gets
%% chosen
merge_relations_ordered([], L, L).

merge_relations_ordered([(_, Rel)|T], L, M):-
	% when relation is already in second list, drop it
	% and go on with Tail
	member((_, Rel), L), !,
	merge_relations_ordered(T, L, M).

merge_relations_ordered([H|T], L, [H|M]) :-
	% when relation is not in second list, prepend it
	merge_relations_ordered(T, L, M).

%% Evaluates if some relation holds for a item
%% E.g.,
%% if defined: has_relation(dog, 0/inf, birth)
%% then: relations_holds(dog, 0/2, birth)
%% should return true

relation_holds(X, inf/inf, Rel) :-
	!,
	has_relation(X, inf/inf, Rel).

relation_holds(X, Low/inf, Rel) :-
	has_relation(X, Min/inf, Rel),
	!,
	Low >= Min.

relation_holds(X, Low/High, Rel) :-
	has_relation(X, Min/Max, Rel),
	range(Low/High, Min/Max), !.

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
	