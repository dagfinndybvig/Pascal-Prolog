program sum_to_n;
var
  n, i, total: integer;
begin
  readln(n);
  i := 1;
  total := 0;
  while i <= n do
  begin
    total := total + i;
    i := i + 1
  end;
  writeln(total)
end.
