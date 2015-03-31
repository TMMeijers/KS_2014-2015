:- dynamic(descends_from/2).

descends_from(arachnide, chelicerate).
descends_from(insect, crustacean).
descends_from(centipede, labiatae).

descends_from(chelicerate, arthropoda).
descends_from(crustacean, arthropoda).
descends_from(labiatae, arthropoda).

descends_from(amphibie, vertebrata).
descends_from(reptile, vertebrata).
descends_from(bird, vertebrata).
descends_from(mammal, vertebrata).
descends_from(ostheichthye, vertebrata).

descends_from(vertebrata, chordata).

descends_from(chordata, animal).

descends_from(leg, body_part).

descends_from(skeleton, body_part).

descends_from(exo_skeleton, skeleton).
descends_from(endo_skeleton, skeleton).

%% Adds an item to the knowledge base
add_descends_from(X, Y) :-
	X \= Y,
	assert(descends_from(X, Y)).