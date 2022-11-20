% 1. Posiciones pares e impares
% Debe implementar el predicado sepparimpar(L, P, I) tal que L, P e I sean listas, y P contenga todos los elementos en las posiciones pares de L e I todos los de las posiciones impares (Se consideran que las listas parten desde 0).
%
% ?- sepparimpar([1, 5, 3, 2, 4, 6], P, I).
% P= [1, 3, 4], I = [5, 2, 6]
%
% ?- sepparimpar(L, [1, 2, 3], [4, 5, 6]).
% L = [1, 4, 2, 5, 3, 6]

sepparimpar([], [], []).
sepparimpar([B], [B], []).
sepparimpar([A|LT], [A|PT], I) :- sepparimpar(LT, I, PT).





% 2. Todos los numeros en un rango
% Debe implementar el predicado todosrango(L, Min, Max) tal que L sea una lista que contenga todos los numeros enteros en el intervalo [Min, Max) (La lista puede contener mas numeros).
%
% ?- todosrango([1, 5, 3, 2, 4, 6], 3, 7).
% true
%
% ?- todosrango([1, 5, 3, 2, 4, 6], X, Y).
% X = 1, Y = 2
% X = 1, Y = 3
% X = 2, Y = 3
% X = 1, Y = 4
% ...
% X = 6, Y = 7

todosrango(L, A, B) :- member(A1, L), A is A1, B is A+1.
todosrango(L, A, B) :- member(A, L), A1 is A+1, todosrango(L, A1, B).





% 3. Rango maximo
% Debe implementar el predicado rangomax(L, Min, Max) tal que L sea una lista y el intervalo [Min, Max) es el mas grande posible, para el cual se cumple que todos los enteros en este se encuentren en la lista.
%
% ?- rangomax([1, 5, 3, 2, 4, 6], 1, 7).
% true
%
% ?- rangomax([1, 5, 3, 2, 4, 6], 3, 7).
% false
%
% ?- rangomax([1, 5, 3, 2, 4, 6], X, Y).
% X = 1, Y = 7

c_rangos_lista([], []).
c_rangos_lista([_], [1]).
c_rangos_lista([La, Lb|Lt], [Rh|Rt]) :-
    sort([La, Lb|Lt], [La, Lb|Lt]),
    La is Lb - 1,
    c_rangos_lista([Lb|Lt], [V1|Rt]),
    Rh is V1 + 1;

    not(sort([La, Lb|Lt], [La, Lb|Lt])),
    sort([La, Lb|Lt], L2),
    c_rangos_lista(L2, [Rh|Rt]);

    sort([La, Lb|Lt], [La, Lb|Lt]),
    not(La is Lb - 1),
    Rh is 1,
    c_rangos_lista([Lb|Lt], Rt).


rangomax(L, A, B) :- 
    todosrango(L, A, B), 
    A2 is A-1, B2 is B+1, 
    not(todosrango(L, A2, B)), 
    not(todosrango(L, A, B2)),

    c_rangos_lista(L, R),
    max_list(R, R2),
    R2 is B-A.


