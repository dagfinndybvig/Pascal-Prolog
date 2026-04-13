program test_unary_operations;
var
  a, b: integer;
begin
  a := 5;
  b := -a;
  writeln(b);
  b := -(-a);
  writeln(b)
end.