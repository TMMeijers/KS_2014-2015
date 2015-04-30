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
event(desert).
event(juice).

%% desert concurrent banana.
%% dinner before dessert.
%% snack before dinner.
%% breakfast before lunch.
%% lunch before dinner.
%% lunch concurrent juice.



breakfast before lunch.
breakfast before juice.
lunch before dinner.
dinner before dessert.
juice concurrent lunch.
juice before dinner.