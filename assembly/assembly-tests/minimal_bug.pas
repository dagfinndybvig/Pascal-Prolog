program minimal_bug;

var
  x, y, z: integer;

begin
  x := 20;
  y := 4;
  writeln(x);  // Should print 20
  writeln(y);  // Should print 4
  z := x * y;   // Should be 80
  writeln(z);  // But prints wrong value
end.