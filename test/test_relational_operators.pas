program test_relational_operators;
var
  x, y, z: integer;
begin
  x := 5;
  y := 3;
  if x = y then
    z := 1
  else
    z := 0;
  if x <> y then
    z := z + 1;
  if x < y then
    z := z + 1;
  if x <= y then
    z := z + 1;
  if x > y then
    z := z + 1;
  if x >= y then
    z := z + 1;
  writeln(z)
end.