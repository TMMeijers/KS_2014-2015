%% Kennissystemen Assignment 4
%% Universiteit van Amsterdam
%%
%% Thomas Meijers (10647023) & Jeroen Vranken (10658491)
%% May 3rd, 2015
%%
%% These are the definitions for the timelines assignment.

:- op(300, xfy, before).
:- op(298, xfy, concurrent).
:- op(200, xfy, or).

:- dynamic(before/2).
:- dynamic(concurrent/2).
:- dynamic(or/2).
:- dynamic(event/1).

:- discontiguous(before/2).
:- discontiguous(concurrent/2).
:- discontiguous(or/2).
:- discontiguous(event/1).


%%%%%
%% Adds transitive relations

is_before(X, Y):-
	X before Y.

is_before(X, Z):-
	X before Y,
	is_before(Y, Z).