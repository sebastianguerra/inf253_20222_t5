% sepparimpar(L, P, I): 
%
% Cierto si P contiene los elementos pares de la lista L e I los impares.

sepparimpar([], [], []).

sepparimpar([B], [B], []).

sepparimpar([A | LT], [A | PT], I) :- sepparimpar(LT, I, PT).





% todosrango(L, Min, Max):
%
% Cierto si L es una lista que contiene todos los numeros en el intervalo 
% [Min, Max).

todosrango(L, A, B) :-
    member(A, L), 
    (
        B is A + 1;

        A1 is A + 1, 
        todosrango(L, A1, B)
    ).





% is_sorted(L):
%
% Cierto si L es una lista ordenada de menor a mayor.

is_sorted(L) :- sort(L, L).





% c_rangos_lista(L, R):
%
% Cierto si R es una lista que contiene la cantidad de enteros consecutivos
% en la lista L.
% Ej: Si L es [1,3,4,6,7,8] R es [1,2,3].
% L puede ser una lista desordenada, ya que en la implementacion se ordena.

c_rangos_lista([], []).

c_rangos_lista([_], [1]).

c_rangos_lista([La, Lb | Lt], [Rh | Rt]) :-
    (
        is_sorted([La, Lb | Lt])
    -> 
        (
            La is Lb - 1
        -> 
            (
                c_rangos_lista([Lb | Lt], [V1 | Rt]),
                Rh is V1 + 1
            )
        ;
            Rh is 1,
            c_rangos_lista([Lb | Lt], Rt)
        )
    ;
        sort([La, Lb | Lt], SortedList),
        c_rangos_lista(SortedList, [Rh | Rt])
    ).





% rangomax(L, Min, Max):
%
% Cierto si Min y Max son el rango mas grande posible en L. 
% Similar a todosrango/3 pero solo verifica el rango mas grande.

rangomax(L, A, B) :- 
    todosrango(L, A, B), 

    A2 is A - 1, B2 is B + 1, 
    not(todosrango(L, A2, B)), 
    not(todosrango(L, A, B2)),

    c_rangos_lista(L, R),
    max_list(R, R2),
    R2 is B-A.





% alllessthan(L, N):
%
% Cierto si todos los elementos de L son menores a N.

alllessthan([], _).

alllessthan([A | LT], B) :- 
    A < B, 
    alllessthan(LT, B).





% allgreaterorequalthan(L, N):
%
% Cierto si todos los elementos de L son mayores o iguales que N.

allgreaterorequalthan([], _).

allgreaterorequalthan([A | LT], B) :- 
    A >= B, 
    allgreaterorequalthan(LT, B).





% chicograndechico(L, Min, Max):
%
% Cierto si L es una lista de largo Max-Min en donde todos sus elementos
% en posiciones pares estan en el intervalo [Min, (Max+Min)/2) y todos sus
% elementos en posiciones impares estan en el intervalo [(Max+Min)/2, Max).

chicograndechico(L, Min, Max) :-
    Len is Max-Min,
    length(L, Len),
    rangomax(L, Min, Max),
    sepparimpar(L, L1, L2),
    H is (Max + Min) / 2,
    alllessthan(L1, H),
    allgreaterorequalthan(L2, H).














% test_sepparimpar:
%
% Tests del predicado sepparimpar.

test_sepparimpar :-
    sepparimpar([1, 5, 3, 2, 4, 6], P1, I1),
    P1 = [1, 3, 4], I1 = [5, 2, 6],
    not((
        sepparimpar([1, 5, 3, 2, 4, 6], P2, I2),
        P2 \= [1, 3, 4], I2 \= [5, 2, 6]
    )),
    write("1 OK"), nl,

    sepparimpar(L1, [1, 2, 3], [4, 5, 6]),
    L1 = [1, 4, 2, 5, 3, 6],
    not((
        sepparimpar(L2, [1, 2, 3], [4, 5, 6]),
        L2 \= [1, 4, 2, 5, 3, 6]
    )),
    write("2 OK"), nl.





% test_todosrango:
%
% Tests del predicado todosrango.

test_todosrango :-
    todosrango([1, 5, 3, 2, 4, 6], 3, 7),
    write("1 OK"), nl,

    findall([X, Y], 
            todosrango([1,5,3,2,4,6], X, Y), L1),
            sort(L1, L2),
            permutation([
                [1,2], [1,3], [1,4], [1,5], [1,6], [1,7], 
                [2,3], [2,4], [2,5], [2,6], [2,7], 
                [3,4], [3,5], [3,6], [3,7], 
                [4, 5], [4, 6], [4, 7], 
                [5, 6], [5, 7], 
                [6, 7]], 
                L2),
    write("2 OK"), nl,
    
    not(todosrango([1, 5, 3, 4, 6], 1, 7)),
    write("3 OK"), nl,

    not(todosrango([1, 5, 3, 2, 4, 6], 1, 8)),
    write("4 OK"), nl,

    length(L3, 3),
    findall(L3, todosrango(L3, 1, 3), L4),
    sort(L4, L5),
    permutation(L5, [[1,2,_],[1,_,2],[2,1,_],[2,_,1],[_,1,2],[_,2,1]]),
    write("5 OK"), nl.





% test_rangomax:
%
% Tests del predicado rangomax.

test_rangomax :-
    rangomax([1, 5, 3, 2, 4, 6], 1, 7),
    write("1 OK"), nl,

    not(rangomax([1, 5, 3, 2, 4, 6], 3, 7)),
    write("2 OK"), nl,

    rangomax([1, 5, 3, 2, 4, 6], X1, Y1),
    X1 = 1, Y1 = 7,

    not((
        rangomax([1, 5, 3, 2, 4, 6], X2, Y2),
        X2 \= 1, Y2 \= 7
    )),
    write("3 OK"), nl.





% test_chicograndechico:
%
% Tests del predicado chicograndechico.

test_chicograndechico :-
    findall(L1, chicograndechico(L1, 1, 5), L2),
    sort(L2, L3),
    permutation(L3, [[1, 3, 2, 4], [2, 3, 1, 4], [1, 4, 2, 3], [2, 4, 1, 3]]),
    write("1 OK"), nl,

    findall(L4, chicograndechico(L4, 1, 6), L5), 
    sort(L5, L6),
    permutation(L6, [
        [1, 4, 2, 5, 3], [1, 4, 3, 5, 2], [2, 4, 1, 5, 3], 
        [2, 4, 3, 5, 1], [3, 4, 1, 5, 2], [3, 4, 2, 5, 1], 
        [1, 5, 2, 4, 3], [1, 5, 3, 4, 2], [2, 5, 1, 4, 3], 
        [2, 5, 3, 4, 1], [3, 5, 1, 4, 2], [3, 5, 2, 4, 1]]),
    write("2 OK"), nl.





% test:
%
% Ejecuta los tests de todos los predicados.

test :- 
    nl,

    write("sepparimpar"), nl,
    test_sepparimpar,
    write('OK sepparimpar'), nl, nl,

    write("todosrango"), nl,
    test_todosrango,
    write('OK todosrango'), nl, nl,

    write("rangomax"), nl,
    test_rangomax,
    write('OK rangomax'), nl, nl,

    write("chicograndechico"), nl,
    test_chicograndechico,
    write('OK chicograndechico'), nl, nl.
