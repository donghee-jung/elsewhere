Program Example36;

type
  somebytes = array [6..10] of byte;
  somewords = array [3..10] of word;
  
var
  S : string;
  I : integer;
  bytes : somebytes;
  words : somewords;
  
begin
  S := '';
  for i := 1 to 10 do
  begin
    S := S + '*';
    writeln(length(S):2, ' : ', S);
  end;
  writeln('Bytes : ', length(bytes));
  writeln('Words : ', length(words));
end.
