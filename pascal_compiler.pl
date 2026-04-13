:- module(pascal_compiler, [
    parse_pascal/2,
    check_pascal/1,
    compile_to_c/2,
    compile_to_executable/2
]).

:- use_module(library(process)).
:- use_module(library(filesex)).
:- use_module(src/parser).
:- use_module(src/semantics).
:- use_module(src/ir).
:- use_module(src/codegen_c).

parse_pascal(SourcePath, AST) :-
    parse_file(SourcePath, AST).

check_pascal(SourcePath) :-
    parse_pascal(SourcePath, AST),
    check_program(AST).

compile_to_c(SourcePath, COutPath) :-
    parse_pascal(SourcePath, AST),
    check_program(AST),
    lower_program(AST, IRProgram),
    write_c_file(COutPath, IRProgram).

compile_to_executable(SourcePath, OutputPath) :-
    parse_pascal(SourcePath, AST),
    check_program(AST),
    lower_program(AST, IRProgram),
    setup_call_cleanup(
        tmp_file_stream(text, TempCPath, Stream),
        (
            close(Stream),
            write_c_file(TempCPath, IRProgram),
            runtime_paths(RuntimeCPath, RuntimeIncludeDir),
            process_create(
                path(gcc),
                [
                    '-std=c11',
                    '-Wall',
                    '-Wextra',
                    '-x', 'c',
                    TempCPath,
                    RuntimeCPath,
                    '-I', RuntimeIncludeDir,
                    '-o', OutputPath
                ],
                [process(PID)]
            ),
            process_wait(PID, Status),
            expect_success(Status)
        ),
        delete_file(TempCPath)
    ).

runtime_paths(RuntimeCPath, RuntimeIncludeDir) :-
    source_file(pascal_compiler:compile_to_executable(_, _), File),
    file_directory_name(File, Dir),
    directory_file_path(Dir, runtime, RuntimeIncludeDir),
    directory_file_path(RuntimeIncludeDir, 'runtime.c', RuntimeCPath).

expect_success(exit(0)) :- !.
expect_success(Status) :-
    throw(error(gcc_failed(Status), _)).

usage :-
    writeln("Usage:"),
    writeln("  swipl -q -s pascal_compiler.pl -- parse <source.pas>"),
    writeln("  swipl -q -s pascal_compiler.pl -- check <source.pas>"),
    writeln("  swipl -q -s pascal_compiler.pl -- c <source.pas> <out.c>"),
    writeln("  swipl -q -s pascal_compiler.pl -- build <source.pas> <out_binary>").

main :-
    current_prolog_flag(argv, Argv),
    (   Argv = [parse, Source]
    ->  parse_pascal(Source, AST),
        writeln(AST)
    ;   Argv = [check, Source]
    ->  check_pascal(Source),
        writeln(ok)
    ;   Argv = [c, Source, COut]
    ->  compile_to_c(Source, COut),
        format("Wrote ~w~n", [COut])
    ;   Argv = [build, Source, OutBin]
    ->  compile_to_executable(Source, OutBin),
        format("Built ~w~n", [OutBin])
    ;   usage,
        halt(1)
    ).

:- initialization(main, main).
