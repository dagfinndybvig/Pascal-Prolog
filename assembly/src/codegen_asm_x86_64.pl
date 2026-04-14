% Code generator for x86-64 assembly
% This is a minimal implementation for the PoC

:- module(codegen_asm_x86_64, [
    generate_asm/2,  % generate_asm(+IR, -Assembly)
    generate_asm_text/2,  % generate_asm_text(+IR, -Assembly)
    asm_header/1,    % asm_header(-Header)
    asm_footer/1,    % asm_footer(-Footer)
    asm_writeln_str/2, % asm_writeln_str(+String, -Assembly)
    asm_writeln_int_text/2, % asm_writeln_int_text(+Expr, -Assembly)
    asm_assign/3,    % asm_assign(+VarName, +Expr, -Assembly)
    asm_expr/2,      % asm_expr(+Expr, -Assembly)
    init_var_offsets/1 % init_var_offsets(+Vars)
]).

% Counter for generating unique labels
:- dynamic label_counter/1.
label_counter(0).

% Counter and mapping for emitted string literals
:- dynamic string_counter/1.
:- dynamic string_label/2.
string_counter(0).

% Variable stack offset tracking
:- dynamic var_offset/2.

% Track if we need int_format
:- dynamic needs_int_format/0.

% Initialize variable offsets and flags
init_var_offsets(Vars) :-
    retractall(var_offset(_, _)),
    retractall(needs_int_format),
    retractall(label_counter(_)),
    retractall(string_counter(_)),
    retractall(string_label(_, _)),
    assert(label_counter(0)),
    assert(string_counter(0)),
    init_var_offsets(Vars, 8).  % Start from 8 for negative offsets from %rbp

init_var_offsets([], _).
init_var_offsets([Var|Vars], Offset) :-
    assert(var_offset(Var, Offset)),
    NextOffset is Offset + 8,
    init_var_offsets(Vars, NextOffset).

% Generate assembly for different IR statements
generate_asm(ir_writeln_str(String), Assembly) :-
    asm_writeln_str(String, Assembly).
generate_asm(ir_write_str(String), Assembly) :-
    asm_write_str(String, Assembly).
generate_asm(ir_writeln_int(_Expr), Assembly) :-
    format(atom(Assembly), "", []).
generate_asm(ir_write_int(_Expr), Assembly) :-
    format(atom(Assembly), "", []).
generate_asm(ir_readln(_Name), Assembly) :-
    format(atom(Assembly), "", []).
generate_asm(ir_assign(_VarName, _Expr), Assembly) :-
    format(atom(Assembly), "", []).
generate_asm(ir_if(_, ThenStmt, ElseStmt), Assembly) :-
    generate_asm(ThenStmt, ThenData),
    generate_asm(ElseStmt, ElseData),
    format(atom(Assembly), "~w~w", [ThenData, ElseData]).
generate_asm(ir_while(_, BodyStmt), Assembly) :-
    generate_asm(BodyStmt, BodyData),
    format(atom(Assembly), "~w", [BodyData]).
generate_asm(ir_block(Stmts), Assembly) :-
    asm_data_list(Stmts, Assembly).
generate_asm(IR, _) :-
    throw(error(unsupported_ir_for_asm_data(IR), _)).

% Generate assembly for text section
generate_asm_text(ir_writeln_str(String), Assembly) :-
    asm_writeln_str_text(String, Assembly).
generate_asm_text(ir_write_str(String), Assembly) :-
    asm_write_str_text(String, Assembly).
generate_asm_text(ir_writeln_int(Expr), Assembly) :-
    asm_writeln_int_text(Expr, Assembly).
generate_asm_text(ir_write_int(Expr), Assembly) :-
    asm_write_int_text(Expr, Assembly).
generate_asm_text(ir_readln(Name), Assembly) :-
    asm_readln_text(Name, Assembly).
generate_asm_text(ir_assign(VarName, Expr), Assembly) :-
    asm_assign(VarName, Expr, Assembly).
generate_asm_text(ir_block(Stmts), Assembly) :-
    asm_stmt_list(Stmts, Assembly).
generate_asm_text(ir_if(Cond, ThenStmt, ElseStmt), Assembly) :-
    next_label(if_else, ElseLabel),
    next_label(if_end, EndLabel),
    asm_expr(Cond, CondCode),
    generate_asm_text(ThenStmt, ThenCode),
    generate_asm_text(ElseStmt, ElseCode),
    format(
        atom(Assembly),
        "~w\tcmpq $0, %rax\n\tje ~w\n~w\tjmp ~w\n~w:\n~w~w:\n",
        [CondCode, ElseLabel, ThenCode, EndLabel, ElseLabel, ElseCode, EndLabel]
    ).
generate_asm_text(ir_while(Cond, BodyStmt), Assembly) :-
    next_label(while_start, StartLabel),
    next_label(while_end, EndLabel),
    asm_expr(Cond, CondCode),
    generate_asm_text(BodyStmt, BodyCode),
    format(
        atom(Assembly),
        "~w:\n~w\tcmpq $0, %rax\n\tje ~w\n~w\tjmp ~w\n~w:\n",
        [StartLabel, CondCode, EndLabel, BodyCode, StartLabel, EndLabel]
    ).
generate_asm_text(IR, _) :-
    throw(error(unsupported_ir_for_asm_text(IR), _)).

asm_stmt_list([], "").
asm_stmt_list([Stmt|Rest], Assembly) :-
    generate_asm_text(Stmt, FirstCode),
    asm_stmt_list(Rest, RestCode),
    format(atom(Assembly), "~w~w", [FirstCode, RestCode]).

asm_data_list([], "").
asm_data_list([Stmt|Rest], Assembly) :-
    generate_asm(Stmt, FirstData),
    asm_data_list(Rest, RestData),
    format(atom(Assembly), "~w~w", [FirstData, RestData]).

next_label(Prefix, Label) :-
    retract(label_counter(N)),
    Next is N + 1,
    assert(label_counter(Next)),
    format(atom(Label), "~w_~d", [Prefix, N]).



% Assembly header
asm_header(".data\n"):- !.

asm_footer(".text\n\t.global main\nmain:\n\tpushq %rbp\n\tmovq %rsp, %rbp\n\tsubq $256, %rsp\n"):- !.

% Generate assembly for writeln_str
asm_writeln_str(String, DataSection) :-
    asm_string_data(String, DataSection).

asm_write_str(String, DataSection) :-
    asm_string_data(String, DataSection).

asm_writeln_str_text(String, TextSection) :-
    asm_string_call_text(String, rt_writeln_str, TextSection).

asm_write_str_text(String, TextSection) :-
    asm_string_call_text(String, rt_write_str, TextSection).

asm_writeln_int_text(Expr, TextSection) :-
    asm_expr(Expr, ExprCode),
    format(
        atom(TextSection),
        "~w\tmovl %eax, %edi\n\tcall rt_writeln_int\n",
        [ExprCode]
    ).

asm_write_int_text(Expr, TextSection) :-
    asm_expr(Expr, ExprCode),
    format(
        atom(TextSection),
        "~w\tmovl %eax, %edi\n\tcall rt_write_int\n",
        [ExprCode]
    ).

asm_readln_text(VarName, Assembly) :-
    var_offset(VarName, Offset),
    format(
        atom(Assembly),
        "\tcall rt_readln_int\n\tmovslq %eax, %rax\n\tmovq %rax, -~d(%rbp)\n",
        [Offset]
    ).

asm_assign(VarName, Expr, Assembly) :-
    asm_expr(Expr, ExprCode),
    var_offset(VarName, Offset),
    format(atom(Assembly), "~w\tmovq %rax, -~d(%rbp)\n", [ExprCode, Offset]).

asm_string_data(String, DataSection) :-
    ensure_string_label(String, Label, IsNew),
    (   IsNew = true
    ->  asm_escape_string(String, Escaped),
        format(atom(DataSection), "~w:\n\t.asciz \"~w\"\n", [Label, Escaped])
    ;   format(atom(DataSection), "", [])
    ).

asm_string_call_text(String, FuncName, TextSection) :-
    (   string_label(String, Label)
    ->  format(atom(TextSection), "\tleaq ~w(%rip), %rdi\n\tcall ~w\n", [Label, FuncName])
    ;   throw(error(missing_string_label(String), _))
    ).

ensure_string_label(String, Label, false) :-
    string_label(String, Label),
    !.
ensure_string_label(String, Label, true) :-
    next_string_label(Label),
    assert(string_label(String, Label)).

next_string_label(Label) :-
    retract(string_counter(N)),
    Next is N + 1,
    assert(string_counter(Next)),
    format(atom(Label), "str_~d", [N]).

asm_escape_string(Text, EscapedAtom) :-
    text_codes(Text, Codes),
    escape_asm_string_codes(Codes, EscapedCodes),
    atom_codes(EscapedAtom, EscapedCodes).

text_codes(Text, Codes) :-
    string(Text),
    !,
    string_codes(Text, Codes).
text_codes(Text, Codes) :-
    atom(Text),
    !,
    atom_codes(Text, Codes).

escape_asm_string_codes([], []).
escape_asm_string_codes([0'\\|Rest], [0'\\, 0'\\|EscapedRest]) :-
    !,
    escape_asm_string_codes(Rest, EscapedRest).
escape_asm_string_codes([0'"|Rest], [0'\\, 0'"|EscapedRest]) :-
    !,
    escape_asm_string_codes(Rest, EscapedRest).
escape_asm_string_codes([10|Rest], [0'\\, 0'n|EscapedRest]) :-
    !,
    escape_asm_string_codes(Rest, EscapedRest).
escape_asm_string_codes([Code|Rest], [Code|EscapedRest]) :-
    escape_asm_string_codes(Rest, EscapedRest).

% Generate assembly for expressions
asm_expr(ir_int(N), Assembly) :-
    format(atom(Assembly), "\tmovq $~d, %rax\n", [N]).
asm_expr(ir_var(Name), Assembly) :-
    var_offset(Name, Offset),
    format(atom(Assembly), "\tmovq -~d(%rbp), %rax\n", [Offset]).
asm_expr(ir_unary('-', Expr), Assembly) :-
    asm_expr(Expr, ExprCode),
    format(atom(Assembly), "~w\tnegq %rax\n", [ExprCode]).
asm_expr(ir_bin('+', Left, Right), Assembly) :-
    asm_expr(Left, LeftCode),
    asm_expr(Right, RightCode),
    format(atom(Assembly), "~w\tpushq %rax\n~w\tpopq %rcx\n\taddq %rcx, %rax\n", [LeftCode, RightCode]).
asm_expr(ir_bin('-', Left, Right), Assembly) :-
    asm_expr(Left, LeftCode),
    asm_expr(Right, RightCode),
    format(atom(Assembly), "~w\tpushq %rax\n~w\tpopq %rcx\n\tsubq %rax, %rcx\n\tmovq %rcx, %rax\n", [LeftCode, RightCode]).
asm_expr(ir_bin('*', Left, Right), Assembly) :-
    asm_expr(Left, LeftCode),
    asm_expr(Right, RightCode),
    format(atom(Assembly), "~w\tpushq %rax\n~w\tpopq %rcx\n\timulq %rcx, %rax\n", [LeftCode, RightCode]).
asm_expr(ir_bin('/', Left, Right), Assembly) :-
    asm_expr(Left, LeftCode),
    asm_expr(Right, RightCode),
    format(
        atom(Assembly),
        "~w\tpushq %rax\n~w\tpopq %rcx\n\tmovq %rax, %r11\n\tmovq %rcx, %rax\n\tcqo\n\tidivq %r11\n",
        [LeftCode, RightCode]
    ).
asm_expr(ir_bin('=', Left, Right), Assembly) :-
    asm_compare_expr(Left, Right, "sete", Assembly).
asm_expr(ir_bin('<>', Left, Right), Assembly) :-
    asm_compare_expr(Left, Right, "setne", Assembly).
asm_expr(ir_bin('<', Left, Right), Assembly) :-
    asm_compare_expr(Left, Right, "setl", Assembly).
asm_expr(ir_bin('<=', Left, Right), Assembly) :-
    asm_compare_expr(Left, Right, "setle", Assembly).
asm_expr(ir_bin('>', Left, Right), Assembly) :-
    asm_compare_expr(Left, Right, "setg", Assembly).
asm_expr(ir_bin('>=', Left, Right), Assembly) :-
    asm_compare_expr(Left, Right, "setge", Assembly).

asm_compare_expr(Left, Right, SetInstr, Assembly) :-
    asm_expr(Left, LeftCode),
    asm_expr(Right, RightCode),
    format(
        atom(Assembly),
        "~w\tpushq %rax\n~w\tpopq %rcx\n\tcmpq %rax, %rcx\n\t~w %al\n\tmovzbq %al, %rax\n",
        [LeftCode, RightCode, SetInstr]
    ).
