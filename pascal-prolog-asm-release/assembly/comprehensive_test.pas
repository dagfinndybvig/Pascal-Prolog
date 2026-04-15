program comprehensive_test;

var
  a, b, c, result: integer;
  name: string;

begin
  writeln('Comprehensive Pascal Test Program');
  writeln('================================');
  
   Test variable declarations and assignments
  a := 10;
  b := 20;
  c := 30;
  
   Test arithmetic operations
  result := a + b * c - 5;
  write('Arithmetic result (10 + 20 * 30 - 5): ');
  writeln(result);
  
   Test comparison operators
  if a < b then
    writeln('a is less than b')
  else
    writeln('a is not less than b');
  
  if b >= c then
    writeln('b is greater than or equal to c')
  else
    writeln('b is less than c');
  
  if a = 10 then
    writeln('a equals 10')
  else
    writeln('a does not equal 10');
  
   Test nested blocks and variable scoping
  begin
    var temp: integer;
    temp := a + b;
    writeln('Nested block temp value: ', temp);
  end;
  
   Test input/output operations
  write('Enter your name: ');
  readln(name);
  write('Hello, ');
  writeln(name);
  
  write('Enter first number: ');
  readln(a);
  write('Enter second number: ');
  readln(b);
  
  result := a * b + (a + b);
  write('Result of (a * b + (a + b)): ');
  writeln(result);
  
   Test negative numbers
  c := -a;
  write('Negative of a: ');
  writeln(c);
  
   Test complex expression
  result := (a + b) * (c - 5) / 2;
  write('Complex expression result: ');
  writeln(result);
  
  writeln('Test completed successfully!');
  
   Final check
  if result > 0 then
    writeln('Final result is positive')
  else
    writeln('Final result is not positive')
end.