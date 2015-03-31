:- dynamic(descends_from/2).

%%% ANIMAL HIERARCHY

%% CHORDATA
%% Phyla
descends_from(chordata, animal).
%% Subphyla
descends_from(vertebrata, chordata).
%% Classes
descends_from(amphibie, vertebrata).
descends_from(reptile, vertebrata).
descends_from(bird, vertebrata).
descends_from(mammal, vertebrata).
descends_from(ostheichthye, vertebrata).
%% Amphibie
descends_from(amphibie, lizard).

%% Mammal
descends_from(cangaroo, mammal).

descends_from(rabbit, mammal).
descends_from(dolphin, mammal).
	      
%% ARTHROPODA
%% Phyla
descends_from(arthropoda, animal).
%% Subphyla
descends_from(chelicerate, arthropoda).
descends_from(crustacean, arthropoda).
descends_from(labiatae, arthropoda).
%% Classes
descends_from(arachnid, chelicerate).
descends_from(insect, crustacean).
descends_from(centipede, labiatae).
%% Arachnides
descends_from(scorpion, arachnid).
descends_from(spider, arachnid).
descends_from(mite, arachnid).     
%% Insects

%% Centipedes

%%% OBJECT HIERARCHY
descends_from(leg, body_part).

%% body parts
descends_from(skeleton, body_part).
descends_from(brain, body_part).

%% skeleton
descends_from(exo_skeleton, skeleton).
descends_from(endo_skeleton, skeleton).

%% brain
descends_from(brain_with_neocortex, brain).

%% key-value-restrictions

has_relation(cangaroo, 2/2, leg).
has_relation(dolphin, 0/0, leg).
has_relation(rabbit, 2/2, leg).

has_relation(bird, 2/2, leg).

has_relation(mammal, 1/1, brain_with_neocortex).

has_relation(arthropoda, 1/1, exo_skeleton).
has_relation(chordata, 1/1, endo_skeleton).

% top level relations
has_relation(animal, 0/inf, leg).
has_relation(animal, 1/1, brain).
has_relation(animal, 1/1, skeleton).


%% Adds an item to the knowledge base
add_descends_from(X, Y) :-
	X \= Y,
	assert(descends_from(X, Y)).