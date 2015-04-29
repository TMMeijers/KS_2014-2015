%% Kennissystemen Assignment 4
%% Universiteit van Amsterdam
%%
%% Thomas Meijers (10647023) & Jeroen Vranken (10658491)
%% May 3rd, 2015
%%
%% This application can reason about timelines.

:- consult('definitions.pl').
:- consult('knowledge_base.pl').
:- consult('rules.pl').

go1 :-
	true.
	%% assert(a before b),
	%% assert(c while b),
	%% assert(c meets d). % assert KB