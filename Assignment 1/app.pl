:- consult(knowledge_base).
:- consult(knowledge_base_rules).

%% prints ancestor line

print_concept([X]) :-
	descends_from(_, X),
	writer([X, '[root]']), !.

print_concept([H|T]) :-
	descends_from(H, _), !,
	writer([H, '\n', ' \\/']),
	print_concept(T).

print_concept([X]) :-
	writer([X, ' is not a known concept.']).

print_relation([(Min/Max, Rel)]) :-
	writer([Rel, '(', Min/Max, ')']).

print_relation([(Min/Max, Rel)|T]) :-
	writer([Rel, '(', Min/Max, ')', ', ']),
	print_relation(T).
	      
%% displays all we know about a concept
%% <concept> - <parent> - ... - <root>
%% <list of attributes> either unfiltered or filtered
%% unfiltered = [(2/2, leg), (0/inf, limb)],
%% filtered = [(2/2, leg)].

show(Concept) :-
	show_unfiltered(Concept).

show_unfiltered(Concept) :-
	all_ancestors(Concept, Ancestors),
	all_relations(Concept, Relations),
	!,
	append([Concept], Ancestors, Bloodline),
	show_full(Bloodline, Relations), !.

show_unfiltered(Concept) :-
	all_relations(Concept, Relations),
	!,
	show_full([Concept], Relations), !.

show_filtered(Concept) :-
	all_ancestors(Concept, Ancestors),
	filtered_relations(Concept, Relations),
	!,
	append([Concept], Ancestors, Bloodline),
	show_full(Bloodline, Relations), !.

show_filtered(Concept) :-
	all_relations(Concept, Relations),
	!,
	show_full([Concept], Relations), !.	

% Print the whole heritance tree and relations
show_full(Bloodline, Relations) :-
	write('INHERITANCE: '),nl,
	print_concept(Bloodline),
	nl, write('RELATIONS: '), nl,
	print_relation(Relations).

%% classifies a concept according to a list of attributes
classify(AttrList, Concepts) :-
	findall(Concept,
	        foreach(member(Rel, AttrList),
		      has(Concept, Rel)),
	        UConcepts),
	sort(UConcepts, Concepts).

%% Add/3 adds a concept under a specified parent,
%% It checks if the parent is known, the new concept
%% isn't already a parent of a child and that the
%% relations aren't too restricting.

% Make sure Parent exists
add(Concept, Parent, _) :-
	\+(descends_from(Parent, _);
	   descends_from(_, Parent)),
	!,
	writer(['Impossible to add ', Concept, ', parent concept is unknown.']).

% Make sure new concept is not already a child.
add(Concept, _, _) :-
	(descends_from(_, Concept);
	 descends_from(Concept, _)),
	!,
	writer(['Impossible to add ', Concept, ', it is already known.']).

% Make sure relations aren't restricting
add(Concept, Parent , Rels) :-
	all_relations(Parent, ParentRels),
	\+check_restrictions(Rels, ParentRels),
	!,
	writer(['Impossible to add ', Concept, ', relations are restricting this parent.']).

add(Concept, Parent, URels) :-
	filter_parent_relations(URels, Rels),
	assert(descends_from(Concept, Parent)),
	add_relations(Concept, Rels),
	!,
	writer([Concept, ' added.']).

%% Add/2 adds a concept based on the specified relations,
%% this only works if we have an exact match, if there are
%% multiple possibilities, we can't add. No relations specified
%% means we have a new root concept.

add(Concept, _) :-
	(descends_from(Concept, _);
	 descends_from(_, Concept)),
	!,
	writer(['Impossible to add ', Concept, ', it is already known.']).

add(Concept, []) :-
	assert(descends_from(entity, Concept)),
	writer([Concept, ' added as new superconcept.']), !.

add(Concept, Rels) :-
	classify(Rels, Possibilities),
	length(Possibilities, N),
	N > 1,
	!,
	writer(['Impossible to add ', Concept, ', more than one possibility based on relations.']).

add(Concept, Rels) :-
	classify(Rels, Possibilities),
	length(Possibilities, N),
	N =:= 0,
	!,
	writer(['Impossible to add ', Concept, ', no matches found.']).

add(Concept, Rels) :-
	classify(Rels, Possibilities),
	length(Possibilities, N),
	N =:= 1,
	nth0(0, Possibilities, Parent),
	add(Concept, Parent, Rels).

% Helper for add, checks if relations aren't restricting
check_restrictions([], _).

% If we have a direct match with relations
check_restrictions([Rel|Rest], ParentRels) :-
	member_and_inrange(Rel, ParentRels),
	!,
	check_restrictions(Rest, ParentRels).

% If we only need to check restriction with a parentconcept (e.g. leg vs limb).
check_restrictions([(Low/High, Rel)|Rest], ParentRels) :-
	% If we check parent concept, lower concept shouldn't be in list.
	\+member((_, Rel), ParentRels),
	descends_from(Rel, URel),
	member_and_inrange((Low/High, URel), ParentRels),
	!,
	check_restrictions(Rest, ParentRels).
	
% Checks if relation is present and if value restriction holds
member_and_inrange((Low/High, Rel), [(Min/Max, Rel)|_]) :-
	!,
	range(Low/High, Min/Max), !.

member_and_inrange(Rel, [_|PRels]) :-
	member_and_inrange(Rel, PRels), !.

% Helper for add, adds all relations to knowledge base
add_relations(_, []).

add_relations(Concept, [(Min/Max, Rel)|Rest]) :-
	kb_relation_add_or_update(Concept, Min/Max, Rel),
	add_relations(Concept, Rest).

%% Writer/1 is a helper function to print strings and variables from a list.
writer([]) :-
	nl.

writer([H|T]) :-
	write(H),
	writer(T).