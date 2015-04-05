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
	writer([Rel, ' (', Min/Max, ')']).

print_relation([(Min/Max, Rel)|T]) :-
	writer([Rel, ' (', Min/Max, ')', ', ']),
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
	assert(descends_from(Concept, entity)),
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

%% add_abstract_concept is used to update abstract concepts for
%% relations. e.g. so that we can add claws under limbs.

add_abstract_concept(Concept) :-
	(descends_from(_, Concept);
	 descends_from(Concept, _)),
	!,
	writer(['Impossible to add ', Concept, ', it is already known.']).

add_abstract_concept(Concept) :-
	assert(descends_from(Concept, entity)),
	writer([Concept, ' added as a root abstract concept.']), !.

add_abstract_concept(Concept, _) :-
	(descends_from(_, Concept);
	 descends_from(Concept, _)),
	!,
	writer(['Impossible to add ', Concept, ', it is already known.']).

add_abstract_concept(Concept, Parent) :-
	\+(descends_from(_, Parent);
	   descends_from(Parent, _)),
	!,
	writer(['Impossible to add ', Concept, ', parent is unknown.']).

add_abstract_concept(Concept, Parent) :-
	assert(descends_from(Concept, Parent)),
	writer([Concept, ' added.']), !.

%% Update_relations checks if there are no restrictions and then updates
%% the relations if not.
update_relations(Concept, Rels) :-
	descends_from(Concept, entity),
	!,
	add_relations(Concept, Rels), !.


update_relations(Concept, Rels) :-
	descends_from(Concept, Parent),
	all_relations(Parent, PRels),
	check_restrictions(Rels, PRels),
	add_relations(Concept, Rels), !.

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

%% Demonstration functions

go1 :-
	write('Show a concept with its restrictions, filtered and unfiltered:'), nl,
	show(human), nl,
	show_filtered(human), nl,
	write('use show/1 and show_filtered/1 for this information.').

go2 :-
	write('Now let\'s try to add a new concept below a human, the \'Teaching Assistant\':'), nl,
	write('?- show_filtered(teaching_assistant)'), nl,
	\+show(teaching_assistant), nl,
	write('?- add(teaching_assistant, humn, [(1/1, walking), (2/2, leg), (3/3, arm), (0/0, birth)]).'), nl,
	add(teaching_assistant, humn, [(1/1, walking), (2/2, leg), (3/3, arm), (0/0, birth)]), nl,
	write('?- add(teaching_assistant, human, [(1/1, walking), (2/2, leg), (3/3, arm), (0/0, birth)]).'), nl,
	add(teaching_assistant, human, [(1/1, walking), (2/2, leg), (3/3, arm), (0/0, birth)]), nl,
	write('?- add(teaching_assistant, human, [(1/1, walking), (2/2, leg), (2/2, arm), (0/0, birth)]).'), nl,
	add(teaching_assistant, human, [(1/1, walking), (2/2, leg), (2/2, arm), (0/0, birth)]), nl,
	write('?- show_filtered(teaching_assistant)'), nl,
	show_unfiltered(teaching_assistant), nl,
	write('Adding new concepts checks for restrictions, if parent concepts '), nl,
	write('are known and if the concept to be added is not known yet.').

go3 :-
	write('Our knowledge system is also able to give classifications based on restrictions given'), nl,
	write('So give us all concepts in the system with 2 legs and wings and lay 5 to 10 eggs.'), nl,
	write('?- classify([(2/2, leg), (2/2, wing), (5/10, egg)], X).'), nl,
	classify([(2/2, leg), (2/2, wing), (5/10, egg)], X), write(X), nl, nl,
	write('And now suppose we have encountered a new species, but don\'t know it\'s inheritance.'), nl,
	write('try to add it based on the above restrictions:'), nl,
	write('?- add(pfundstein_meijers_bird, [(2/2, leg), (2/2, wing), (5/10, egg)]).'), nl,
	add(pfundstein_meijers_bird, [(2/2, leg), (2/2, wing), (5/10, egg)]), nl,
	write('So say we have observed it some more and have noticed that our new bird swims'), nl,
	write('?- add(pfundstein_meijers_bird, [(2/2, leg), (2/2, wing), (5/10, egg), (1/1, swimming)]).'), nl,
	add(pfundstein_meijers_bird, [(2/2, leg), (2/2, wing), (5/10, egg), (1/1, swimming)]), nl,
	show(pfundstein_meijers_bird), nl,
	write('So the system is able to classify new species and add them when there is no ambiguity.'), nl,
	write('Of course, one can also use classify/2 to get options and then use add/3 to add it.').

go4 :-
	write('The possibility to update restrictions is also there, which even \nchecks if there is no'),
	write(' parent concept restricting the change:'), nl,
	write('?- show(eagle).'), nl,
	show(eagle), nl,
	write('?- update_relations(eagle, [(3/3, wing)]).'), nl,
	\+update_relations(eagle, [(3/3, wing)]),
	write('Doesn\'t work, since all birds have two wings, so let\'s try:'), nl,
	write('?- update_relations(bird, [(3/3, wing)]).'), nl,
	update_relations(bird, [(3/3, wing)]), nl,
	write('?- show(eagle)'), nl,
	show(eagle),
	write('And because of inheritance, eagle now shows that it has three wings,'),
	write('since it\'s ancestor is a bird.').

go5 :-
	write('As a last demonstration we can add a whole new concept, with it\'s only'), nl,
	write('super concept being \'entity\':'), nl,
	write('add(plant, []).'), nl,
	add(plant, []), nl,
	write('Let\'s add some restrictions to new abstract concepts:'), nl,
	write('?- add_abstract_concept(diet_type), add_abstract_concept(photosynthesis, diet_type),\n   add_abstract_concept(reproduction, pollen).'), nl,	
	add_abstract_concept(diet_type), add_abstract_concept(photosynthesis, diet_type), add_abstract_concept(pollen, reproduction), nl,
	write('?- update_relations(plant, [(0/0, movement_type), (0/inf, pollen), (1/inf, diet_type), (1/1, photosynthesis)]).'), nl,
	update_relations(plant, [(0/0, movement_type), (0/inf, pollen), (1/inf, diet_type), (1/1, photosynthesis)]),
	write('?- show(plant).'), nl,
	show(plant), nl,
	write('So we can add new concepts everywhere in the tree, update relations and define new abstract '), nl,
	write('with the sytem checking for inconsistencies and other human errors. Last try:'), nl,
	write('?- add(walking_plant, plant, [(1/1, walking)]).'), nl,
	add(walking_plant, plant, [(1/1, walking)]), nl,
	write('?- add_abstract_concept(carnivore, diet_type).'), nl,
	add_abstract_concept(carnivore, diet_type), nl,
	write('?- add(flesh_eating_plant, plant, [(1/1, carnivore)]).'), nl,
	add(flesh_eating_plant, plant, [(1/1, carnivore)]), nl,
	write('?- show(walking_plant).'), nl,
	\+show(walking_plant), nl,
	write('?- show(flesh_eating_plant).'), nl,
	show(flesh_eating_plant).