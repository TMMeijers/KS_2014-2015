%% Kennissystemen Assignment 4
%% Universiteit van Amsterdam
%%
%% Thomas Meijers (10647023) & Jeroen Vranken (10658491)
%% May 3rd, 2015
%%
%% This application can reason about timelines.
%% all top-level clauses are defined in this document (except add/1),
%% the predicates go1 until go5 give a demonstration of the system's
%% capabilities.

:- consult('definitions.pl').
:- consult('knowledge_base.pl').
:- consult('rules.pl').

%%%%%
%% delete/0 deletes the whole knowledge base

delete :-
	retractall(event(_)),
	retractall(_ before _),
	retractall(_ concurrent _),
	write('Cleared knowledge base!'), nl.

%%%%%
%% reload/0 is a helper clause that reloads the original knowledge_base.pl

reload :-
	delete,
	write('Reloading original KB.'), nl,
	consult('knowledge_base.pl').

%%%%%
%% timeline/0 generates all possible permutations of a timeline based on current events and relations.

timeline :-
	setof(S, find_start([S]), Starts),
	generate_multiple(Starts, Temp),
	flatten_timelines(Temp, Timelines),
	write('SEPERATE TIMELINES:'), nl,
	print_multiple(Timelines), nl,
	setof(P, permutate_timeline(Timelines, P), Permutated),
	write('ALL POSSIBLE COMBINED TIMELINES:'), nl,
	print_multiple(Permutated).

%%%%%
%% point/0 clears the whole knowledgebase and then adds events and relations to the KB based
%% on the input given by the user.

point :-
	delete,
	write('Please give input, list with events seperated by comma''s, example:'), nl,
	write('[breakfast before lunch, lunch before dinner, wine concurrent dinner]'), nl, nl,
	read(Points),
	add_points(Points).

%%%%%
%% goN/0 show examples of how the system works.
	
go1 :-
	write('GENERAL INFORMATION:'), nl,
	write('delete/0 clears the KB'),nl,
	write('reload/0 reloads the original KB'), nl,
	write('point/0 clears the KB and asks for input'), nl,
	write('add/1 adds the argument to the existing KB'), nl,
	write('timeline/0 prints the timeline(s)'), nl, nl,
	write('This is the current timeline:'), nl,
	timeline, nl,
	write('First we will add wine concurrent to dinner:'), nl,
	add(wine concurrent dinner),
	timeline, nl,
	write('Then we will put soup in between lunch and dinner'), nl,
	add(lunch before soup), add(soup before dinner),
	timeline, nl,
	write('When ambiguous data is added, the program will generate all possible timelines,'), nl,
	write('For instance, when placing water before soup:'), nl,
	add(water before soup),
	timeline, nl.

go2 :-
	write('The system handles contradications:'), nl,
	write('add(lunch before breakfast)'), nl,
	\+add(lunch before breakfast), nl, nl,
	write('This also works on transitive contradictions:'), nl,
	write('add(dessert before breakfast)'), nl,
	\+add(dessert before breakfast).

go3 :-
	write('The system handles complex timelines like a zigzagging one:'), nl,
	format('a~n \\~n  b~n /~nc~n \\~n  d~n /~ne'), nl,
	delete,
	add(a before b),
	add(c before b),
	add(c before d),
	add(e before d),
	timeline.

go4 :-
	write('Adding loops to the previous timeline can decrease the number of possibilities again:'), nl,
	write('add(c before a).'), nl,
	add(c before a),
	write('add(e before a).'), nl,
	add(e before a),
	timeline.

go5 :-
	write('Our reasoner handles complex timelines that join, split and loop again.'), nl,
	write('This increases the possibilities exponentially, but it''s still fast!'), nl,
	delete,
	add(a before b),
	add(b before c),
	add(c before d),
	add(a before x),
	add(x before d),
	add(a before y),
	add(z before d),
	add(w before z),
	timeline,
	write('Scroll up for all the timelines, as can be seen, we can generate A LOT of'), nl,
	write('timelines with just 8 events'), nl,
	write('Try for yourself with point/0 or add/1!').
