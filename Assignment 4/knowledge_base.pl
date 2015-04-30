%% Kennissystemen Assignment 4
%% Universiteit van Amsterdam
%%
%% Thomas Meijers (10647023) & Jeroen Vranken (10658491)
%% May 3rd, 2015
%%
%% This is the knowledge base for timeline reasoning.

event(breakfast).
event(lunch).
event(dinner).

desert concurrent banana.
dinner before dessert.
snack before diner.
breakfast before lunch.
lunch before dinner.
lunch concurrent juice.

