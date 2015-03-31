				% Kennissystemen 2014-2015
				% Universiteit van Amsterdam
				% T.M. Meijers (10647023), M. Pfundstein (1045237)
				% Assignment 1, 31-03-2015

%%% PHYLA
descends_from(chordata, animal).
descends_from(arthropoda, animal).

%%% ARTHROPODA
% subphyla
descends_from(chelicerate, arthropoda).
descends_from(crustacean, arthropoda).
descends_from(labiatae, arthropoda).
% classes
descends_from(arachnide, chelicerate).
descends_from(insect, crustacean).
descends_from(centipede, labiatae).

%%% CHORDATA
% subphyla
descends_from(vertebrata, chordata).
% classes
descends_from(amphibie, vertebrata).
descends_from(reptile, vertebrata).
descends_from(bird, vertebrata).
descends_from(mammal, vertebrata).
descends_from(ostheichthye, vertebrata).



descends_from(stomme_vogel, bird).

descends_from(leg, body_part).

descends_from(skeleton, body_part).

descends_from(exo_skeleton, skeleton).
descends_from(endo_skeleton, skeleton).

is_a(X, Y) :-
	descends_from(X, Y).

is_a(X, Z) :-
	descends_from(X, Y),
	is_a(Y, Z).