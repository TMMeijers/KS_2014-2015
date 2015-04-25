%% Kennissystemen 2014-2015
%% Assignment 3 - MC4
%% Markus Pfundstein (10452397)
%% Thomas Meijers (10647023)
%%
%% This is the main application which does the main reasoning.


/*
 * Consult additional files
 */

:- consult('definitions.pl').
:- consult('forward_chaining.pl').
:- consult('backward_chaining.pl').
:- consult('knowledge_base.pl').

/*
 * Application rules
*/

%% check_aarsmaden/1 implemented this wayf or fun.
check_aarsmaden(ja) :-
	write('U heeft waarschijnlijk last van aarsmaden, knip goed uw nagels!'), nl, nl,
	close_program.

check_aarsmaden(nee) :-
	write('Dan verwijzen wij uw door naar een huisarts, de Digitale Tropenarts Beta '),nl, 
	write('herkent enkel tropische ziektes en aarsmaden, veel succes.'), nl, nl,
	close_program.

%% Welcome message, start diagnosis
start :-
	retractall(fact(_)),
	write('Welkom bij uw Digitale Tropenarts Beta.'), nl,
	write('Heeft u recentelijk een reis ondernomen naar de tropen? (ja/nee)'), nl,
	read(Travel), nl,
	get_symptoms(Travel).

%% get_symptoms/1 asks the user for the initial list of symptoms.
get_symptoms(ja) :-
	print_symptoms,
	write('Geeft u alstublieft de symptomen in lijstvorm, wees zo specifiek mogelijk. ([a, b])'), nl,
	read(Symptoms), nl,
	forward_chaining(Symptoms).
	
get_symptoms(nee) :-
	write('Heeft u jeuk aan uw anus? (ja/nee)'), nl,
	read(Jeuk), nl,
	check_aarsmaden(Jeuk).

%% forward_chaining/1 gets a list of all symptoms based on forward_chaining and current facts, bottom-up approach
forward_chaining([]) :-
	write('Start symptoomanalyse:'), nl,
	forward, nl,
	write('Start ziekteanalyse:'), nl,
	backward_chaining.

forward_chaining([S|Rest]) :-	% If we need the user to specify
	if S ask Specify, !,
	write('Specificeert u alstublieft de gradatie van het symptoom '''),
	write(S), write(''','), nl,
	write('Typ een van de symptomen over die het beste overeenkomen met uw klachten:'), nl,
	write(Specify), nl,
	read(Specific), nl, nl,
	assert(fact(Specific)),
	forward_chaining(Rest).

forward_chaining([S|Rest]) :-
	assert(fact(S)),
	forward_chaining(Rest).

%% print_symptoms/0 flattens, filters and prints all symptoms
print_symptoms :-
	write('De volgende symptomen zijn bekend in onze database:'), nl,
	setof(D, disease(D), Diseases),
	setof([A,B], if A then B, Out1),
	setof([A,B], if A ask B, Out2),
	append(Out1, Out2, Out),
	flatten(Out, All),
	filter_symptoms(Diseases, All, Symptoms),
	sort(Symptoms, Sorted_symptoms),
	output_list(Sorted_symptoms), nl.

%% output_list/1 prints all symptoms, 3 per row
output_list([]).

output_list([A, B|Rest]) :- !,
	format('  ~p~30|~p~n', [A, B]),
	output_list(Rest).

output_list([A|Rest]) :-
	write(A), nl,
	output_list(Rest).

%% filter_symptoms/3 filters out the diseases and flattens the whole structure
filter_symptoms(_, [], []).

filter_symptoms(Diseases, [X and Y|Rest], Symptoms) :-
	atom(X),
	member(X, Diseases), !,
	filter_symptoms(Diseases, [Y|Rest], Symptoms).

filter_symptoms(Diseases, [X or Y|Rest], Symptoms) :-
	atom(X),
	member(X, Diseases), !,
	filter_symptoms(Diseases, [Y|Rest], Symptoms).

filter_symptoms(Diseases, [X and Y|Rest], [X|Symptoms]) :-
	atom(X), !,
	filter_symptoms(Diseases, [Y|Rest], Symptoms).

filter_symptoms(Diseases, [X or Y|Rest], [X|Symptoms]) :-
	atom(X), !,
	filter_symptoms(Diseases, [Y|Rest], Symptoms).

filter_symptoms(Diseases, [X|Rest], Symptoms) :-
	atom(X),
	member(X, Diseases), !,
	filter_symptoms(Diseases, Rest, Symptoms).

filter_symptoms(Diseases, [X|Rest], [X|Symptoms]) :-
	atom(X), !,
	filter_symptoms(Diseases, Rest, Symptoms).

%% backward_chaining/0 narrows down on diseases based on the symptoms, top-down approach
backward_chaining :-
	setof(D, disease(D), Possibilities),
	narrow_down(Possibilities, Diseases),
	length(Diseases, N),
	N > 0, !,
	nl, write('U kunt een of meerdere van de volgende ziektes hebben:'), nl,
	output_list(Diseases), nl,
	write('Raadpleegt u alstublieft een arts en neem deze analyse mee.'), nl, nl,
	close_program.

backward_chaining :-
	nl, write('Geen ziektes gevonden aan de hand van uw symptomen, wellicht heeft u'), nl,
	write('geen tropenziekte. Raadpleegt u bij twijfel een arts, mocht u het pro-'), nl,
	write('gramma nogmaals willen draaien geeft u dan meer of specifieker uw'), nl,
	write('symptomen in.'), nl, nl,
	close_program.

%% narrow_down/2 uses backward_chaining to check if the disease is in the narrowed down solution space
narrow_down([], []).

narrow_down([D|Rest], [D|Result]) :-
	is_true(D), !,
	write(D), write(' toegevoegd aan mogelijke ziektes, een of meerdere symptomen aanwezig.'), nl,
	narrow_down(Rest, Result).

narrow_down([D|Rest], Result) :-
	write(D), write(' uitgesloten, geen enkel symptoom aanwezig.'), nl,
	narrow_down(Rest, Result).

close_program :-
	!, 
	write('Bedankt voor het gebruiken van Digitale Tropenarts Beta.'), nl,
	write('Tot ziens!').
	