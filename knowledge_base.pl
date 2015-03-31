

is_a(arachnide, chelicerate).
is_a(insect, crustacean).
is_a(centipede, labiatae).

is_a(chelicerate, arthropoda).
is_a(crustacean, arthropoda).
is_a(labiatae, arthropoda).



is_a(amphibie, vertebrata).
is_a(reptile, vertebrata).
is_a(bird, vertebrata).
is_a(mammal, vertebrata).
is_a(ostheichthye, vertebrata).


is_a(vertebrata, chordata).

is_a(chordata, animal).

is_a(stomme_vogel, bird).

is_a(X, X) :-
	X .=. X.

is_a(X, Z) :-
	is_a(X, Y),
	is_a(Y, Z).

