program simple_comprehensive;

var
  a, b, c, result: integer;

begin
   Test variable declarations and assignments
  a := 10;
  b := 20;
  c := 30;
  
   Test arithmetic operations
  result := a + b * c - 5;
  write('Arithmetic result: ');
  writeln(result);
  
   Test comparison operators
  if a < b then
    writeln('a is less than b')
  else
    writeln('a is not less than b');
  
   Test nested blocks
  begin
    var temp: integer;
    temp := a + b;
    writeln('Nested block temp: ', temp);
  end;
  
  writeln('Test completed!')
end.