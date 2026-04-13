:- module(codegen_c, [emit_c_source/2, write_c_file/2]).

emit_c_source(ir_program(_, Vars, Stmts), Source) :-
    vars_lines(Vars, DeclLines),
    stmts_lines(Stmts, 1, StmtLines),
    append(
        [
            [
                "#include \"runtime.h\"",
                "",
                "int main(void) {"
            ],
            DeclLines,
            StmtLines,
            [
                "    return 0;",
                "}"
            ]
        ],
        Lines
    ),
    atomic_list_concat(Lines, '\n', Atom),
    atom_string(Atom, Source).

write_c_file(Path, IRProgram) :-
    emit_c_source(IRProgram, Source),
    setup_call_cleanup(
        open(Path, write, Out),
        write(Out, Source),
        close(Out)
    ).

vars_lines([], []).
vars_lines(Vars, Lines) :-
    maplist(var_line, Vars, Lines).

var_line(Name, Line) :-
    format(atom(Line), "    int ~w = 0;", [Name]).

stmts_lines([], _, []).
stmts_lines([Stmt|Rest], Level, Lines) :-
    stmt_lines(Stmt, Level, First),
    stmts_lines(Rest, Level, Tail),
    append(First, Tail, Lines).

stmt_lines(ir_assign(Name, Expr), Level, [Line]) :-
    expr_text(Expr, ExprText),
    indent(Level, Indent),
    format(atom(Line), "~w~w = ~w;", [Indent, Name, ExprText]).
stmt_lines(ir_writeln(Expr), Level, [Line]) :-
    expr_text(Expr, ExprText),
    indent(Level, Indent),
    format(atom(Line), "~wrt_writeln_int(~w);", [Indent, ExprText]).
stmt_lines(ir_readln(Name), Level, [Line]) :-
    indent(Level, Indent),
    format(atom(Line), "~w~w = rt_readln_int();", [Indent, Name]).
stmt_lines(ir_block(Stmts), Level, Lines) :-
    stmts_lines(Stmts, Level, Lines).
stmt_lines(ir_if(Cond, ThenStmt, ElseStmt), Level, Lines) :-
    expr_text(Cond, CondText),
    indent(Level, Indent),
    format(atom(OpenIf), "~wif (~w) {", [Indent, CondText]),
    InnerLevel is Level + 1,
    stmt_lines(ThenStmt, InnerLevel, ThenLines),
    format(atom(CloseThen), "~w}", [Indent]),
    stmt_lines(ElseStmt, InnerLevel, ElseLines),
    (   ElseLines = []
    ->  append([[OpenIf], ThenLines, [CloseThen]], Lines)
    ;   format(atom(OpenElse), "~welse {", [Indent]),
        format(atom(CloseElse), "~w}", [Indent]),
        append([[OpenIf], ThenLines, [CloseThen, OpenElse], ElseLines, [CloseElse]], Lines)
    ).
stmt_lines(ir_while(Cond, Body), Level, Lines) :-
    expr_text(Cond, CondText),
    indent(Level, Indent),
    format(atom(Open), "~wwhile (~w) {", [Indent, CondText]),
    InnerLevel is Level + 1,
    stmt_lines(Body, InnerLevel, BodyLines),
    format(atom(Close), "~w}", [Indent]),
    append([[Open], BodyLines, [Close]], Lines).

expr_text(ir_int(N), Text) :-
    format(atom(Text), "~w", [N]).
expr_text(ir_var(Name), Name).
expr_text(ir_unary('-', Expr), Text) :-
    expr_text(Expr, Inner),
    format(atom(Text), "(-(~w))", [Inner]).
expr_text(ir_bin(Op, Left, Right), Text) :-
    expr_text(Left, LText),
    expr_text(Right, RText),
    c_operator(Op, COp),
    format(atom(Text), "((~w) ~w (~w))", [LText, COp, RText]).

c_operator('=', "==").
c_operator('<>', "!=").
c_operator('<', "<").
c_operator('<=', "<=").
c_operator('>', ">").
c_operator('>=', ">=").
c_operator('+', "+").
c_operator('-', "-").
c_operator('*', "*").
c_operator('/', "/").

indent(Level, Indent) :-
    Spaces is Level * 4,
    length(Codes, Spaces),
    maplist(=(0' ), Codes),
    atom_codes(Indent, Codes).
