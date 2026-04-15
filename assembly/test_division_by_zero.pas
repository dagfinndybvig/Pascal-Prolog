program test_division_by_zero;

var
  a, b, c: integer;

begin
  a := 10;
  b := 0;
  c := a / b;  % This should trigger division by zero error
  writeln(c)
end.