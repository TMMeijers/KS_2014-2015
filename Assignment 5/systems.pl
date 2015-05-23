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
	retractall(_ in _),
	retractall(_ outputs _),
	retractall(_ predicts _),
	retractall(components(_)),
	assert(4 in m1),
	assert(2 in m1),
	assert(2 in m2),
	assert(3 in m2),
	assert(8 in m3),
	assert(1 in m3),
	assert(m1 in a1),
	assert(m2 in a1),
	assert(m2 in a2),
	assert(m3 in a2),
	assert(1 in m4),
	assert(5 in m4),
	assert(5 in m5),
	assert(2 in m5),
	assert(2 in m6),
	assert(3 in m6),
	assert(m4 in a3),
	assert(m5 in a3),
	assert(m5 in a4),
	assert(m6 in a4),
	assert(m1 outputs 8),
	assert(m2 outputs 6),
	assert(m3 outputs 8),
	assert(a1 outputs 14),
	assert(a2 outputs 14),
	assert(m4 outputs 6),
	assert(m5 outputs 10),
	assert(m6 outputs 6),
	assert(a3 outputs 15),
	assert(a4 outputs 16),
	assert(components([m1, m2, m3, m4, m5, m6, a1, a2, a3, a4])),
	write('Cleared previous system, loaded system 2 (Custom circuit with 10 components).'), nl, nl.