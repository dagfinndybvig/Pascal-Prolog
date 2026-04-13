% Code generator for x86-64 assembly
% This is a minimal implementation for the PoC

:- module(codegen_asm_x86_64, [
    generate_asm/2,  % generate_asm(+IR, -Assembly)
    generate_asm_text/2,  % generate_asm_text(+IR, -Assembly)
    asm_header/1,    % asm_header(-Header)
    asm_footer/1,    % asm_footer(-Footer)
    asm_writeln_str/2 % asm_writeln_str(+String, -Assembly)
]).

% Counter for generating unique labels
:- dynamic label_counter/1.
label_counter(0).

% Generate assembly for a simple writeln statement
generate_asm(ir_writeln_str(String), Assembly) :-
    asm_writeln_str(String, Assembly).

% Generate assembly for a simple writeln statement (text section)
generate_asm_text(ir_writeln_str(_), Assembly) :-
    asm_writeln_str_text(Assembly).

% Assembly header
asm_header(".data\n"):- !.

% Assembly footer
asm_footer(".text\n\t.global main\nmain:\n\tpushq %rbp\n\tmovq %rsp, %rbp\n"):- !.

% Generate assembly for writeln_str
asm_writeln_str(String, DataSection) :-
    format(atom(DataSection), "msg:\n\t.asciz \"~w\\n\"\n", [String]).

asm_writeln_str_text(TextSection) :-
    format(atom(TextSection), "\tleaq msg(%rip), %rdi\n\tcall puts\n", []).
