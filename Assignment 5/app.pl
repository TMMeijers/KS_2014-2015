%% Kennissystemen 2014-2015
%% Universiteit van Amsterdam
%%
%% Jeroen Vranken (10658491)
%% Thomas Meijers (10647023)
%%
%% Assignment 5 - GDE
%% 23-05-2015
%%
%% This is the main file for the assignment, please consult this and use the goN/0 predicates
%% to let the system run some examples for you.

:- consult('systems.pl').
:- consult('components.pl').
:- consult('gde.pl').

go1 :-
	load_system1,
	load_model.