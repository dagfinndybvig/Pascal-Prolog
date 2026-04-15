program test_edge_cases;

var
  a, b, c, d, e: integer;

begin
  (* Test 1: Large numbers *)
  a := 2147483647;  (* Max 32-bit signed integer *)
  b := -2147483648; (* Min 32-bit signed integer *)
  writeln('Large positive: ', a);
  writeln('Large negative: ', b);

  (* Test 2: Arithmetic edge cases *)
  c := a + 1;      (* Overflow case *)
  d := b - 1;      (* Underflow case *)
  writeln('Overflow result: ', c);
  writeln('Underflow result: ', d);

  (* Test 3: Division edge cases *)
  e := 1 / 1;       (* Normal division *)
  writeln('Normal division: ', e);

  (* Test 4: Complex expression *)
  writeln('Complex: ', (a + b) * (c - d) / e);

  (* Test 5: Nested blocks *)
  begin
    var f: integer;
    f := 42;
    writeln('Nested block: ', f);
  end;

  writeln('All edge case tests completed successfully');
end.