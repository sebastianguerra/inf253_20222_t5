% Debe implementar el predicado sepparimpar(L, P, I) tal que L, P e I sean
% listas, y P contenga todos los elementos en las posiciones pares de L e I
% todos los de las posiciones impares (Se consideran que las listas parten
% desde 0).
sepparimpar([], [], []).

sepparimpar([B], [B], []).

sepparimpar([A | LT], [A | PT], I) :- sepparimpar(LT, I, PT).





% Debe implementar el predicado todosrango(L, Min, Max) tal que L sea una lista
% que contenga todos los numeros enteros en el intervalo [Min, Max) (La lista
% puede contener mas numeros).
todosrango(L, A, B) :-
    member(A, L), 
    (
        B is A + 1;

        A1 is A + 1, 
        todosrango(L, A1, B)
    ).





% Debe implementar el predicado rangomax(L, Min, Max) tal que L sea una lista y
% el intervalo [Min, Max) es el mas grande posible, para el cual se cumple que
% todos los enteros en este se encuentren en la lista.
c_rangos_lista([], []).
c_rangos_lista([_], [1]).
c_rangos_lista([La, Lb | Lt], [Rh | Rt]) :-
    (
        sort([La, Lb | Lt], [La, Lb | Lt])
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
        sort([La, Lb | Lt], L2),
        c_rangos_lista(L2, [Rh | Rt])
    ).



rangomax(L, A, B) :- 
    todosrango(L, A, B), 

    A2 is A - 1, B2 is B + 1, 
    not(todosrango(L, A2, B)), 
    not(todosrango(L, A, B2)),

    c_rangos_lista(L, R),
    max_list(R, R2),
    R2 is B-A.





% Debe implementar el predicado chicograndechico(L, Min, Max) tal que L es una
% lista de largo Max-Min en donde todos sus elementos en posiciones pares estan
% en el intervalo [Min, (Max+Min)/2] y todos sus elementos en posiciones
% impares estan en el intervalo ((Max+min)/2, Max).
alllessthan([], _).

alllessthan([A | LT], B) :- 
    A < B, 
    alllessthan(LT, B).


allgreaterorequalthan([], _).

allgreaterorequalthan([A | LT], B) :- 
    A >= B, 
    allgreaterorequalthan(LT, B).


chicograndechico(L, Min, Max) :-
    rangomax(L, Min, Max),
    length(L, Len),
    Len is Max-Min,
    sepparimpar(L, L1, L2),
    H is (Max + Min) / 2,
    alllessthan(L1, H),
    allgreaterorequalthan(L2, H).









test_sepparimpar :-
    sepparimpar([1, 5, 3, 2, 4, 6], P, I),
    P = [1, 3, 4], I = [5, 2, 6],
    sepparimpar(L, [1, 2, 3], [4, 5, 6]),
    L = [1, 4, 2, 5, 3, 6].


test_todosrango :-
    todosrango([1, 5, 3, 2, 4, 6], 3, 7),

    findall([X, Y], 
            todosrango([1,5,3,2,4,6], X, Y), L),
            permutation([
                [1,2], [1,3], [1,4], [1,5], [1,6], [1,7], 
                [2,3], [2,4], [2,5], [2,6], [2,7], 
                [3,4], [3,5], [3,6], [3,7], 
                [4, 5], [4, 6], [4, 7], 
                [5, 6], [5, 7], 
                [6, 7]], 
                L),
    
    not(todosrango([1, 5, 3, 4, 6], 1, 7)),
    not(todosrango([1, 5, 3, 2, 4, 6], 1, 8)),

    length(L2, 3),
    findall(L2, todosrango(L2, 1, 3), L3),
    permutation(L3, [[1,2,_],[1,_,2],[2,1,_],[2,_,1],[_,1,2],[_,2,1]]).


test_rangomax :-
    rangomax([1, 5, 3, 2, 4, 6], 1, 7),

    not(rangomax([1, 5, 3, 2, 4, 6], 3, 7)),
    findall(
        [X, Y], 
        rangomax([1, 5, 3, 2, 4, 6], X, Y), 
        L), 
    L = [[1, 7]].


test_chicograndechico :-
    findall(L6, chicograndechico(L6, 1, 5), L7),
    permutation(L7, [[1, 3, 2, 4], [2, 3, 1, 4], [1, 4, 2, 3], [2, 4, 1, 3]]),

    findall(L8, chicograndechico(L8, 1, 6), L9), 
    permutation(L9, [
        [1, 4, 2, 5, 3], [1, 4, 3, 5, 2], [2, 4, 1, 5, 3], 
        [2, 4, 3, 5, 1], [3, 4, 1, 5, 2], [3, 4, 2, 5, 1], 
        [1, 5, 2, 4, 3], [1, 5, 3, 4, 2], [2, 5, 1, 4, 3], 
        [2, 5, 3, 4, 1], [3, 5, 1, 4, 2], [3, 5, 2, 4, 1]]).



test :- 
    test_sepparimpar,
    write('sepparimpar ok'), nl,

    test_todosrango,
    write('todosrango ok'), nl,

    test_rangomax,
    write('rangomax ok'), nl,

    test_chicograndechico,
    write('chicograndechico ok'), nl.