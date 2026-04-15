program debug_step_by_step;

var
  x, y, z: integer;

begin
  x := 10 + 5 * 2;  writeln(x);  // Should be 20
  y := (20 - 4) / 4; writeln(y);  // Should be 4
  z := x * y;        writeln(z);  // Should be 80
end.