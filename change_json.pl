#! /usr/bin/swipl -q

:- use_module(library('http/json_convert')).
:- use_module(library('hashtable')).
:- initialization(main, main).
:- set_prolog_flag(stack_limit, 10_737_418_240).

possibly_fail(end_of_file):- halt(0).
possibly_fail(_).

chars_so_far([], 0).
chars_so_far([Head|Tail], Size2):-
	atom_length(Head, Size),
	chars_so_far(Tail, Size3),
	Size2 is Size + Size3.


write_line_intern([]):- !.
write_line_intern([Head|Tail]):- atom_codes(Head, [10]), !, write('\\n'), write_line_intern(Tail).
write_line_intern([Head|Tail]):- atom_codes(Head, [34]), !, write('\\"'), write_line_intern(Tail).
write_line_intern([Head|Tail]):- atom_codes(Head, [92]), !, write('\\"'), write_line_intern(Tail).
write_line_intern([Head|Tail]):- write(Head), write_line_intern(Tail).

write_line(X):- write('"'), atom_chars(X, Y), write_line_intern(Y), write('"').

write_lines([]):- !.
write_lines(A):- atom(A), !, write_line(A).
write_lines([A]):- atom(A), !, write_line(A).
write_lines([A, B]):- atom(A), !, write_line(A), write(','), write_line(B).
write_lines([First|Tail]):- atom(First), !, write_line(First), write(','), write_lines(Tail).

take(_, 0, []).
take([], _, []).
take([First|Rest], N, [First|Rest2]):- N2 is N - 1, take(Rest, N2, Rest2).

write_prev_answer(X, []):- !, write_lines([X]).
write_prev_answer(_, [Head|_]):- !, write_lines([Head]).

main_intern(State):- 
	read_line_to_string(user_input, Line),
	possibly_fail(Line),
	string_to_atom(Line, Line2),
	ht_get(State, 'lines', Lines),
	json:atom_json_term(Line2, json(JSON), []),
	append(Lines, [JSON.text], Lines2),
	take(Lines2, 100, Lines3),
	ht_put(State, 'lines', Lines3),
	ht_get(State, 'id', Id),
	Id2 is Id + 1,
	ht_put(State, 'id', Id2),
	write('{"answers":{"text":['),
	write_lines([JSON.text]),
	write('], "answer_start":[1, '),
	atom_length(Line2, Line2Length),
	write(Line2Length),
	write(']}, "context":['),
	write_lines(Lines3),
	write('], "id":'),
	write(Id),
	write(', "question": "'),
	write_prev_answer(Line2, Lines),
	writeln('", "title": "shitposting"}'),
	main_intern(State).


	
main:- 
	ht_new(State),
	ht_put(State, 'lines', []),
	ht_put(State, 'id', 0),
	main_intern(State).
main:- halt(1).

