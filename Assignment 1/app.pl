:- consult(knowledge_base).
:- consult(knowledge_base_rules).

%% prints ancestor line
print_concept([X]) :-
	write(X), write('[root]'), nl, !.

print_concept([H|T]) :-
	write(H), write(' => '),
	print_concept(T).

print_relation([(Min/Max, Rel)]) :-
	write(Rel), write('('), write(Min/Max), write(')'), nl, !.

print_relation([(Min/Max, Rel)|T]) :-
	write(Rel), write('('), write(Min/Max), write(')'), write(', '),
	print_relation(T).
	      
%% displays all we know about a concept
%% <concept> - <parent> - ... - <root>
%% <list of attributes>
show(Concept) :-
	all_ancestors(Concept, Ancestors),
	all_relations(Concept, Relations),
	!,
	append([Concept], Ancestors, Bloodline),
	show_full(Bloodline, Relations).

show(Concept) :-
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
