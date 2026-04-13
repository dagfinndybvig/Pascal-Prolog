:- module(semantics, [check_program/1]).

check_program(program(_, Vars, block(Stmts))) :-
    ensure_no_duplicates(Vars),
    check_stmts(Stmts, Vars).

ensure_no_duplicates(Vars) :-
    msort(Vars, Sorted),
    (   has_duplicate(Sorted, Dup)
    ->  throw(error(duplicate_declaration(Dup), _))
    ;   true
    ).

has_duplicate([X, X|_], X) :- !.
has_duplicate([_|Rest], Dup) :-
    has_duplicate(Rest, Dup).

check_stmts([], _).
check_stmts([Stmt|Rest], Vars) :-
    check_stmt(Stmt, Vars),
    check_stmts(Rest, Vars).

check_stmt(assign(Name, Expr), Vars) :-
    ensure_declared(Name, Vars),
    check_expr(Expr, Vars).
check_stmt(if(Cond, Then, Else), Vars) :-
    check_expr(Cond, Vars),
    check_stmt(Then, Vars),
    check_stmt(Else, Vars).
check_stmt(while(Cond, Body), Vars) :-
    check_expr(Cond, Vars),
    check_stmt(Body, Vars).
check_stmt(writeln(expr(Expr)), Vars) :-
    check_expr(Expr, Vars).
check_stmt(writeln(str(_)), _).
check_stmt(readln(Name), Vars) :-
    ensure_declared(Name, Vars).
check_stmt(block(Stmts), Vars) :-
    check_stmts(Stmts, Vars).

check_expr(int(_), _).
check_expr(var(Name), Vars) :-
    ensure_declared(Name, Vars).
check_expr(unary('-', Expr), Vars) :-
    check_expr(Expr, Vars).
check_expr(bin(_, Left, Right), Vars) :-
    check_expr(Left, Vars),
    check_expr(Right, Vars).

ensure_declared(Name, Vars) :-
    (   memberchk(Name, Vars)
    ->  true
    ;   throw(error(undeclared_variable(Name), _))
    ).
