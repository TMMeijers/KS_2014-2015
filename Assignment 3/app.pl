%% Kennissystemen 2014-2015
%% Assignment 3 - MC4
%% Markus Pfundstein (10452397)
%% Thomas Meijers (10647023)
%%
%% This is the main application which does the main reasoning.

/*
 * Defining new operators
 */

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).

/*
 * Consult additional files
 */

:- consult('forward_chaining.pl').
:- consult('backward_chaining.pl').
:- consult('knowledge_base.pl').

/*
 * Application rules
 */