%% Kennissystemen 2014-2015
%% Universiteit van Amsterdam
%%
%% Jeroen Vranken (10658491)
%% Thomas Meijers (10647023)
%%
%% Assignment 5 - GDE
%% 23-05-2015
%%
%% Systems.pl describes the two systems used for this assignment. System1 is the default GDE system used
%% in the examples. System 2 is the system consisting of 10 modules.

%%%%%
%% OPERATORS

:- op(300, xfy, in).
:- op(300, xfy, outputs).
:- op(300, xfy, predicts).

%%%%%
%% DYNAMIC CLAUSES

:- dynamic(in/2).
:- dynamic(outputs/2).
:- dynamic(predicts/2).
:- dynamic(components/1).

%%%%%
%% load_system/0 loads the default GDE circuit

load_system1 :-
	retractall(_ in _),
	retractall(_ outputs _),
	retractall(_ predicts _),
	retractall(components(_)),
	assert(3 in m1),
	assert(2 in m1),
	assert(2 in m2),
	assert(3 in m2),
	assert(2 in m3),
	assert(3 in m3),
	assert(m1 in a1),
	assert(m2 in a1),
	assert(m2 in a2),
	assert(m3 in a2),
	assert(m1 outputs 6), % We will assert the 'real world' with a faulty system.
	assert(m2 outputs 6),
	assert(m3 outputs 6),
	assert(a1 outputs 10),
	assert(a2 outputs 12),
	assert(components([m1, m2, m3, a1, a2])),
	write('Cleared previous system, loaded system 1 (GDE Default).'), nl, nl.

%%%%%
%% load_system2/0 loads the custom circuit (10 interconnected modules)

load_system2 :-
	false.