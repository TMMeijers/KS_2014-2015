:- dynamic
	descends_from/2,
	has_relation/3.

:- discontiguous
	descends_from/2,
	has_relation/3,
	concept/1.

%% Animals
descends_from(animal, entity).

descends_from(cold_blooded, animal).
descends_from(warm_blooded, animal).

descends_from(mammal, warm_blooded).
descends_from(bird, warm_blooded).
descends_from(reptile, cold_blooded).

descends_from(horse, mammal).
descends_from(gorilla, mammal).
descends_from(wolf, mammal).
descends_from(whale, mammal).
descends_from(human, mammal).

descends_from(eagle, bird).
descends_from(pigeon, bird).
descends_from(pinguin, bird).

descends_from(crocodile, reptile).
descends_from(snake, reptile).
descends_from(lizard, reptile).

%% Below are entities used for role restrictions

descends_from(movement_type, entity).
descends_from(limb, entity).
descends_from(reproduction, entity).

%% Living environment

descends_from(walking, movement_type).
descends_from(swimming, movement_type).
descends_from(flying, movement_type).

has_relation(animal, 1/inf, movement_type).
has_relation(bird, 1/1, walking).
has_relation(reptile, 1/1, walking).
has_relation(horse, 1/1, walking).
has_relation(gorilla, 1/1, walking).
has_relation(wolf, 1/1, walking).
has_relation(whale, 1/1, swimming).
has_relation(eagle, 1/1, flying).
has_relation(pigeon, 1/1, flying).
has_relation(pinguin, 1/1, walking).
has_relation(pinguin, 1/1, swimming).
has_relation(crocodile, 1/1, swimming).

%% Limbs

descends_from(leg, limb).
descends_from(arm, limb).
descends_from(wing, limb).
descends_from(fin, limb).
descends_from(tail, limb).

has_relation(animal, 0/inf, limb).
has_relation(bird, 2/2, wing).
has_relation(bird, 2/2, leg).
has_relation(bird, 1/1, tail).
has_relation(horse, 4/4, leg).
has_relation(horse, 1/1, tail).
has_relation(gorilla, 2/2, leg).
has_relation(gorilla, 2/2, arm).
has_relation(wolf, 4/4, leg).
has_relation(wolf, 1/1, tail).
has_relation(whale, 2/2, fin).
has_relation(human, 2/2, leg).
has_relation(human, 2/2, arm).
has_relation(crocodile, 4/4, leg).
has_relation(crocodile, 1/1, tail).
has_relation(snake, 0/0, limb).
has_relation(lizard, 4/4, leg).
has_relation(lizard, 1/1, tail).

%% Reproduction

descends_from(egg, reproduction).
descends_from(birth, reproduction).

has_relation(animal, 0/inf, reproduction).
has_relation(bird, 0/inf, egg).
has_relation(mammal, 0/inf, birth).
has_relation(crocodile, 0/inf, egg).
has_relation(snake, 0/inf, egg).
has_relation(snake, 0/inf, birth).
has_relation(lizard, 0/inf, egg).
has_relation(lizard, 0/inf, birth).