%% Kennissystemen 2014-2015
%% Universiteit van Amsterdam
%%
%% Jeroen Vranken (10658491)
%% Thomas Meijers (10647023)
%%
%% Assignment 5 - GDE
%% 23-05-2015
%%
%% Components.pl contains the clauses representing the adder and multiplier components
%% and their corresponding fault chances.

%%%%%
%% adder_fault/1 is the faulting chance of the adder module as specified by the manufacturer

adder_fault(0.0004).
adder_working(0.9996).

%%%%%
%% adder/3 is the adder module

adder(In1, In2, Output) :-
	Output is In1 + In2.

%%%%%
%% multiplier_fault/1 is the faulting chance of the multiplier module as specified by the manufacturer

multiplier_fault(0.0006).
multiplier_working(0.9994).
%%%%%
%% multiplier/3 is the multiplier module

multiplier(In1, In2, Output) :-
	Output is In1 * In2.
	