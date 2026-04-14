program test_control_flow;

var
  x, y: integer;

begin
  x := 10;
  
  if x > 5 then
  begin
    y := x * 2;
    writeln(y)
  end
  else
  begin
    y := x + 1;
    writeln(y)
  end;
  
  while x > 0 do
  begin
    writeln(x);
    x := x - 1
  end
end.