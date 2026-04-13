:- module(ir, [lower_program/2]).

lower_program(program(Name, Vars, block(Stmts)), ir_program(Name, Vars, IRStmts)) :-
    maplist(lower_stmt, Stmts, IRStmts).

lower_stmt(assign(Name, Expr), ir_assign(Name, IRExpr)) :-
    lower_expr(Expr, IRExpr).
lower_stmt(if(Cond, Then, Else), ir_if(IRCond, IRThen, IRElse)) :-
    lower_expr(Cond, IRCond),
    lower_stmt(Then, IRThen),
    lower_stmt(Else, IRElse).
lower_stmt(while(Cond, Body), ir_while(IRCond, IRBody)) :-
    lower_expr(Cond, IRCond),
    lower_stmt(Body, IRBody).
lower_stmt(writeln(Expr), ir_writeln(IRExpr)) :-
    lower_expr(Expr, IRExpr).
lower_stmt(readln(Name), ir_readln(Name)).
lower_stmt(block(Stmts), ir_block(IRStmts)) :-
    maplist(lower_stmt, Stmts, IRStmts).

lower_expr(int(N), ir_int(N)).
lower_expr(var(Name), ir_var(Name)).
lower_expr(unary('-', Expr), ir_unary('-', IRExpr)) :-
    lower_expr(Expr, IRExpr).
lower_expr(bin(Op, Left, Right), ir_bin(Op, IRLeft, IRRight)) :-
    lower_expr(Left, IRLeft),
    lower_expr(Right, IRRight).
