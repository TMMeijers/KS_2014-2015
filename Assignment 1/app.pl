:- consult(knowledge_base).
:- consult(knowledge_base_rules).

%% prints ancestor line
print_concept([X]) :-
	descends_from(_, X),
	write(X), write('[root]'), nl, !.

print_concept([H|T]) :-
	descends_from(H, _), !,
	write(H), write(' => '),
	print_concept(T).

print_concept([X]) :-
	write(X),
	write(' is not a known concept'), nl.

print_relation([(Min/Max, Rel)]) :-
	write(Rel), write('('), write(Min/Max), write(')'), nl, !.

print_relation([(Min/Max, Rel)|T]) :-
	write(Rel), write('('), write(Min/Max), write(')'), write(', '),
	print_relation(T).
	      
%% displays all we know about a concept
%% <concept> - <parent> - ... - <root>
%% <list of attributes>
show_unfiltered(Concept) :-
	all_ancestors(Concept, Ancestors),
	all_relations(Concept, Relations),
	!,
	append([Concept], Ancestors, Bloodline),
	show_full(Bloodline, Relations).

show_unfiltered(Concept) :-
	all_relations(Concept, Relations),
	!,
	show_full([Concept], Relations).

show_filtered(Concept) :-
	all_ancestors(Concept, Ancestors),
	filtered_relations(Concept, Relations),
	!,
	append([Concept], Ancestors, Bloodline),
	show_full(Bloodline, Relations).

show_filtered(Concept) :-
	all_relations(Concept, Relations),
	!,
	show_full([Concept], Relations).	


show_full(Bloodline, Relations) :-
	write('Inheritance Line: '),nl,
	print_concept(Bloodline),
	write('Relations: '),nl,
	print_relation(Relations).
	
%% displays whole knowledge base
%% foreach concept:
%%     <concept> - <parent> - ... - <root>
%%     <list of attributes>


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
	\+(descends_from(Parent);
	   descends_from(Parent, _);
	   descends_from(_, Parent)),
	!, 
	write('Impossible to add '),
	write(Concept),
	write(', parent concept is unknown.'),
	nl.

% Make sure new concept is not already a child.
add(Concept, Parent, _) :-
	descends_from(Concept, Parent),
	!,
	write('Impossible to add '),
	write(Concept),
	write(', already known under parent.'),
	nl.

% Make sure relations aren't restricting
add(Concept, Parent , Rels) :-
	\+classify(Rels, _);
	(classify(Rels, Possibilities),
	 \+member(Parent, Possibilities)),
	!,
	write('Impossible to add '),
	write(Concept),
	write(', relations are restricting this parent.').

add(Concept, Parent, URels) :-
	filtered_relions(URels, Rels),
	assert(descends_from(Concept, Parent)),
	add_relations(Concept, Rels).

% Helper for add, adds all relations to knowledge base
add_relations(_, []).

add_relations(Concept, [Rel|Rest]) :-
	kb_relation_add_or_update(Concept, Rel),
	add_relations(Concept, Rest).