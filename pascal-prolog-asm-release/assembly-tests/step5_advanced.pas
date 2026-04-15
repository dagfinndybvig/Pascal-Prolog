program test_advanced;

var
  x, y: integer;

begin
  x := 10;
  
  begin
    var y: integer;
    y := 5;
    writeln(x + y)
  end;
  
  y := -x;
  writeln(y);
  
  if x <> 10 then
    writeln('Error')
  else
    writeln('Success');
  
  if x >= 5 then
    writeln('x is >= 5')
  else
    writeln('x is < 5')
end.