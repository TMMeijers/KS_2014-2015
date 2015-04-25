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
	write('U heeft waarschijnlijk last van aarsmaden, knip goed uw nagels!'), nl,
	write('Tot ziens!').

check_aarsmaden(nee) :-
	write('Dan verwijzen wij uw door naar een huisarts, de Digitale Tropenarts Beta herkent enkel tropische ziektes en aarsmaden, veel succes.'), nl,
	write('Tot ziens!').

%% Welcome message, start diagnosis
start_diagnosis :-
	write('Welkom bij uw Digitale Tropenarts Beta V0.01 (Versie: Aarsmaden)'), nl,
	write('Heeft u recentelijk een reis ondernomen naar de tropen? (ja/nee)'), nl,
	read(Travel),
	get_symptoms(Travel).

%% get_symptoms/1 asks the user for the initial list of symptoms.
get_symptoms(ja) :-
	write('Geeft u alstublieft de symptomen in lijstvorm, wees zo specifiek mogelijk. ([a, b])'), nl,
	write('Voor een complete lijst met alle bekende symptomen voert u ''symptomen'' in.'), nl,
	read(Symptoms),
	forward_chaining(Symptoms).
	
get_symptoms(nee) :-
	write('Heeft u jeuk aan uw anus? (ja/nee)'), nl,
	read(Jeuk),
	check_aarsmaden(Jeuk).

%% forward_chaining/1
forward_chaining(symptomen) :-
	print_symptoms, !,
	get_symptoms(ja).

forward_chaining(Symptoms) :-
	true.

%% print_symptoms/0 prints a list of all known symptoms in the system.
print_symptoms :-
	setof(D, disease(D), Diseases),
	setof([A,B], if A then B, Out),
	flatten(Out, All),
	filter_symptoms(Diseases, All, Symptoms),
	sort(Symptoms, Sorted_symptoms),
	output_symptoms(Sorted_symptoms),
	get_symptoms(ja).

output_symptoms([]).

output_symptoms([A, B, C|Rest]) :- !,
	write(A), write(', '), write(B), write(', '), write(C), write(','), nl,
	output_symptoms(Rest).

output_symptoms([A, B|Rest]) :- !,
	write(A), write(', '), write(B), write('.'), nl,
	output_symptoms(Rest).

output_symptoms([A|Rest]) :-
	write(A), write('.'), nl,
	output_symptoms(Rest).

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
	member(X, Diseases), !,
	filter_symptoms(Diseases, Rest, Symptoms).

filter_symptoms(Diseases, [X|Rest], [X|Symptoms]) :-
	filter_symptoms(Diseases, Rest, Symptoms).