program test_nested_blocks;
var
  x, y: integer;
begin
  x := 1;
  begin
    y := 2;
    begin
      x := x + y;
      writeln(x)
    end
  end
end.