program test_control_flow;

var
  i, result: integer;

begin
  i := 5;
  result := 0;
  while i > 0 do
  begin
    result := result + i;
    i := i - 1
  end;
  writeln(result);
  
  if i > 0 then
    writeln(1)
  else
    writeln(0);
  
  if result = 15 then
    writeln(1)
  else
    writeln(0)
end.