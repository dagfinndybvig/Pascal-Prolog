program test_nested_blocks;

var
  outer: integer;

begin
  outer := 10;
  writeln(outer);
  
  begin
    var inner: integer;
    inner := 20;
    writeln(inner);
    writeln(outer + inner)
  end;
  
  writeln(outer)
end.