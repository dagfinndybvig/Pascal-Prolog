program simple_comprehensive;

var
  a, b, c, result: integer;

begin
  a := 10;
  b := 20;
  c := 30;
  
  result := a + b * c - 5;
  write('Arithmetic result: ');
  writeln(result);
  
  if a < b then
    writeln('a is less than b')
  else
    writeln('a is not less than b');
  
  begin
    var temp: integer;
    temp := a + b;
    writeln('Nested block temp: ', temp);
  end;
  
  writeln('Test completed!')
end.