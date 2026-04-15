program test_div_by_zero;

var
  a, b, c: integer;

begin
  a := 10;
  b := 0;
  c := a / b;
  writeln(c)
end.