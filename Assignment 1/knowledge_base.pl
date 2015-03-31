:- dynamic(descends_from/2).

%%% ANIMAL HIERARCHY

%% CHORDATA
%% Phyla
descends_from(chordata, animal).
%% Classes
descends_from(amphibie, chordata).
descends_from(reptile, chordata).
descends_from(bird, chordata).
descends_from(mammal, chordata).
descends_from(ostheichthye, chordata).
%% Amphibie
descends_from(amphibie, lizard).
descends_from(amphibie, frog).

%% Bird
descends_from(pinguin, bird).
descends_from(eagle, bird).

%% Mammal
descends_from(cangaroo, mammal).
descends_from(rabbit, mammal).
descends_from(dolphin, mammal).
	      
%% ARTHROPODA
%% Phyla
descends_from(arthropoda, animal).
%% Classes
descends_from(arachnid, arthropoda).
descends_from(insect, arthropoda).
descends_from(centipede, arthropoda).
%% Arachnides
descends_from(scorpion, arachnid).
descends_from(spider, arachnid).
descends_from(mite, arachnid).     
%% Insects

%% Centipedes

%%% OBJECT HIERARCHY
descends_from(leg, body_part).
descends_from(skeleton, body_part).
descends_from(brain, body_part).
descends_from(wings, body_part).
descends_from(spine, body_part).

%% skeleton
descends_from(exo_skeleton, skeleton).
descends_from(endo_skeleton, skeleton).

%% brain
descends_from(brain_with_neocortex, brain).

%% KEY-VALUE-RESTRICTIONS
% Mammals
has_relation(cangaroo, 2/2, leg).
has_relation(dolphin, 0/0, leg).
has_relation(rabbit, 2/2, leg).
has_relation(bird, 2/2, leg).
has_relation(bird, 2/2, wings).

% Chordata
has_relation(mammal, 1/1, brain_with_neocortex).

% Animal
has_relation(chordata, 1/1, endo_skeleton).
has_relation(chordata, 1/1, spine).

% Arachnids

% Insects

% Centipedes

% Arthropoda

% Animal
has_relation(arthropoda, 1/1, exo_skeleton).
has_relation(arthropoda, 1/1, segmented_body).


% Top Level
has_relation(animal, 0/2, wings).
has_relation(animal, 0/1, spine).
has_relation(animal, 0/inf, leg).
has_relation(animal, 1/1, brain).
has_relation(animal, 1/1, skeleton).

%% Adds an item to the knowledge base
add_descends_from(X, Y) :-
	X \= Y,
	assert(descends_from(X, Y)).