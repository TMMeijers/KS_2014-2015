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


%% Welcome message, start diagnosis
%% For some test runs you can do. 
%%
%% -> to diagnos some simple disease enter:
%% ja.
%% [buikpijn].
%% [diarree].
%%
%% -> to diagnos malaria tropica enter:
%% ja.
%% [koorts].
%% temperatuur_hoger_40.
%% [dagelijks_koorts].
%% [koude_rillingen, transpireert].

%% A FULL SAMPLE RUN:

% go.
% Welkom bij uw Digitale Tropenarts Beta.
% Heeft u recentelijk een reis ondernomen naar de tropen? (ja/nee)
% ja.

% De volgende symptomen zijn bekend in onze database:
%   bloedige_onstlasting        bloedige_ontlasting
%   brijige_ontlasting          buikklachten
%   buikpijn                    dagelijks_koorts
%   darm_aandoening             diarree
%   eitjes_in_ontlasting        heftige_kramp
%   hoge_koorts                 hoofdpijn
%   jeukende_anus               klachten_algemeen
%   klachten_ontlasting         koorts
%   koude_rillingen             lage_koorts
%   malaria_aanval              misseljk
%   obstipatie                  rare_ontlasting
%   regelmatig_koorts_48_uur    regelmatig_koorts_72_uur
%   temperatuur_hoger_38_5      temperatuur_hoger_40
%   transpireert                waterdunne_diarree
%   wormen                      wormen_in_ontlasting

% Geeft u alstublieft de symptomen in lijstvorm, wees zo specifiek mogelijk. ([a, b])
% [koorts, diarree].

% Specificeert u alstublieft de gradatie van het symptoom 'koorts',
% Typ een van de symptomen over die het beste overeenkomen met uw klachten:
% temperatuur_hoger_38_5 or temperatuur_hoger_40
% temperatuur_hoger_40.


% Start symptoomanalyse:
% klachten_ontlasting toegevoegd aan het symptoomdomein.
% darm_aandoening toegevoegd aan het symptoomdomein.
% hoge_koorts toegevoegd aan het symptoomdomein.

% Start ziekteanalyse:
% aarsmaden uitgesloten, geen enkel symptoom aanwezig.
% bacillaire_dysenterie toegevoegd aan mogelijke ziektes, een of meerdere symptomen aanwezig.
% giardasis toegevoegd aan mogelijke ziektes, een of meerdere symptomen aanwezig.
% malaria uitgesloten, geen enkel symptoom aanwezig.
% malaria_quartana uitgesloten, geen enkel symptoom aanwezig.
% malaria_tertiana uitgesloten, geen enkel symptoom aanwezig.
% malaria_tropica uitgesloten, geen enkel symptoom aanwezig.
% tyfus uitgesloten, geen enkel symptoom aanwezig.

% U kunt een of meerdere van de volgende ziektes hebben:
%   bacillaire_dysenterie       giardasis

% Raadpleegt u alstublieft een arts en neem deze analyse mee.

% Bedankt voor het gebruiken van Digitale Tropenarts Beta.
% Tot ziens

go :-
	retractall(fact(_)),
	write('Welkom bij uw Digitale Tropenarts Beta.'), nl,
	write('Heeft u recentelijk een reis ondernomen naar de tropen? (ja/nee)'), nl,
	read(Travel), nl,
	get_symptoms(Travel).


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

get_possible_diseases(Y) :-
	setof(D, get_possible_diseases_helper(D), Y).

get_possible_diseases_helper(Y) :-
	fact(X),
	maybe(X, Y).

get_symptom(Disease, S) :-
	maybe(X, Disease), split_conjunction(X, Y),  member(S, Y).

get_symptoms_for_disease(Disease, Symptoms) :-
	setof(X, get_symptom(Disease, X), Symptoms).

get_symptoms_for_disease_list([D], S) :-
	get_symptoms_for_disease(D, S).

get_symptoms_for_disease_list([D|Rest], Symps) :-
	get_symptoms_for_disease(D, Ss),
	get_symptoms_for_disease_list(Rest, Others),
	append(Others, Ss, Symps).

split_conjunction(X, [X]) :- atom(X), !.

split_conjunction(X and Rest, [X|RestSplit]) :-
	split_conjunction(Rest, RestSplit).

set([],[]).
set([H|T],[H|T1]) :- subtract(T,[H],T2), set(T2,T1).


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
	nl, write('Meer informatie nodig'),
	get_possible_diseases(Possible),
	nl, write('U kunt een of meerdere van deze hebben:'), nl,
	output_list(Possible), nl,
	write('Welke symptome heb je nog? '), nl,
	get_symptoms_for_disease_list(Possible, S),
	set(S, SS),
	exclude(fact, SS, SSClean),
	output_list(SSClean),
	write('Geeft u alstublieft de symptomen in lijstvorm, wees zo specifiek mogelijk. ([a, b])'), nl,
	read(Symptoms), nl,
	forward_chaining(Symptoms).
	
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


