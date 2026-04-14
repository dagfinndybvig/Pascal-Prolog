#!/usr/bin/env swipl

:- initialization(main).

main :-
    current_prolog_flag(argv, [File|_]),
    consult('pascal_compiler.pl'),
    parse_pascal(File, AST),
    check_program(AST),
    lower_program(AST, IR),
    writeln('IR:'),
    writeln(IR),
    
    % Test assembly generation
    asm_header(Header),
    writeln('Header:'),
    writeln(Header),
    
    IR = ir_program(_, _, Stmts),
    member(Stmt, Stmts),
    writeln('Processing statement:'),
    writeln(Stmt),
    (generate_asm(Stmt, AsmCode) ->
        writeln('Generated assembly:'),
        writeln(AsmCode)
    ;
        writeln('Failed to generate assembly for statement')
    ),
    fail.

main :-
    halt.