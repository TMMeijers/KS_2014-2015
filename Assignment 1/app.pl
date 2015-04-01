:- consult(knowledge_base).
:- consult(knowledge_base_rules).

%% prints ancestor line
print_concept([X]) :-
	write(X), write('[root]'), nl, !.

print_concept([H|T]) :-
	write(H), write(' => '),
	print_concept(T).

%% displays all we know about a concept
%% <concept> - <parent> - ... - <root>
%% <list of attributes>
show(Concept) :-
	all_ancestors(Concept, Ancestors), !,
	append([Concept], Ancestors, Bloodline),
	print_concept(Bloodline).

show(Concept) :-
	print_concept([Concept]).

%% displays whole knowledge base
%% foreach concept:
%%     <concept> - <parent> - ... - <root>
%%     <list of attributes>
