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
descends_from(hair, body_part).
descends_from(feathers, body_part).

%% Segmented body
descends_from(segmented_body, body).
descends_from(body_segment, segmented_body).

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
has_relation(bird, 1/1, feathers).
has_relation(bird, 0/0, hair).

% Chordata
has_relation(mammal, 1/1, brain_with_neocortex).
has_relation(mammal, 1/1, hair).
% HACK
%has_relation(mammal, 0/0, feathers).

% Animal
has_relation(chordata, 1/1, endo_skeleton).
has_relation(chordata, 1/1, spine).

% Arachnids
has_relation(arachnid, 8/8, leg).
has_relation(arachnid, 2/2, body_segment).

% Insects
has_relation(insect, 6/6, leg).
has_relation(insect, 3/3, body_segment).

% Centipedes
has_relation(centipede, 20/300, leg).
has_relation(centipede, 15/inf, body_segment).

% Arthropoda
has_relation(arthropoda, 1/1, exo_skeleton).
has_relation(arthropoda, 1/1, segmented_body).
has_relation(arthropoda, 0/inf, leg).
has_relation(arthropoda, 0/0, spine).

% Top Level
has_relation(animal, 0/1, feathers).
has_relation(animal, 0/1, hair).
has_relation(animal, 0/2, wings).
has_relation(animal, 0/1, spine).
has_relation(animal, 0/inf, leg).
has_relation(animal, 1/inf, body_segment).
has_relation(animal, 1/1, brain).
has_relation(animal, 1/1, skeleton).

%% Adds an item to the knowledge base
add_descends_from(X, Y) :-
	X \= Y,
	assert(descends_from(X, Y)).