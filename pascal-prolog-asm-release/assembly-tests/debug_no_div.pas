program debug_no_div;

var
  x, y, z: integer;

begin
  x := 10 + 5 * 2;  writeln(x);  // Should be 20
  y := 20 - 4;       writeln(y);  // Should be 16
  z := x * y;        writeln(z);  // Should be 320
end.