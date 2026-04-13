program test_write_functionality;

var
    x, y: integer;

begin
    x := 10;
    y := 20;
    
    write('x = ');
    write(x);
    writeln('');
    
    write('This is a test ');
    write('on the same line');
    writeln('');
    
    write('Result: ');
    write(x + y);
    writeln('');
    
    write('Final value: ');
    write(x * y);
    writeln('');
    
    write('Done.');
end.