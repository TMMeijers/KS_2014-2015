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
descends_from(amphibie, 

%% ARTHROPODA
%% Phyla
descends_from(arthropoda, animal).
%% Subphyla
descends_from(chelicerate, arthropoda).
descends_from(crustacean, arthropoda).
descends_from(labiatae, arthropoda).
%% Classes
descends_from(arachnide, chelicerate).
descends_from(insect, crustacean).
descends_from(centipede, labiatae).


%%% OBJECT HIERARCHY
descends_from(leg, body_part).

descends_from(skeleton, body_part).

descends_from(exo_skeleton, skeleton).
descends_from(endo_skeleton, skeleton).

%% RELATIONS

has_relation(bird, 2/2, leg).

% top level relations
has_relation(animal, 0/inf, leg).
has_relation(arthropoda, 1/1, exo_skeleton).
has_relation(chordata, 1/1, endo_skeleton).
has_relation(animal, 1/1, skeleton).


%% Adds an item to the knowledge base
add_descends_from(X, Y) :-
	X \= Y,
	assert(descends_from(X, Y)).