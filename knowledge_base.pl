



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

descends_from(stomme_vogel, bird).

descends_from(leg, body_part).

descends_from(skeleton, body_part).

descends_from(exo_skeleton, skeleton).
descends_from(endo_skeleton, skeleton).

%(animal, (0, nil), leg).

is_a(X, Y) :-
	descends_from(X, Y).

is_a(X, Z) :-
	descends_from(X, Y),
	is_a(Y, Z).
