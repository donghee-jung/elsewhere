Program Test07;

Uses sysutils;

type
  somebytes = array [6..10] of byte;
  somewords = array [3..10] of word;
  
var
  S : string;
  I : integer;
  bytes : somebytes;
  words : somewords;
  Look : char;
  rpt_flag : boolean;
  rpt_no : integer;

procedure GetChar;
begin
  Read(Look);
end;

procedure Start;
begin
  GetChar;
end;

function IsAlpha(c: char): boolean;
begin
  IsAlpha := upcase(c) in ['A'..'Z'];
end;

function IsDigit(c: char): boolean;
begin
  IsDigit := c in ['0'..'9'];
end;

function Match(x: char): boolean;
begin
  Match := true;
  if Look = x then GetChar
  else Match := false;
end;
  
procedure Expression;
begin
  if Match('e') then
    if Match('n') then
      if Match('d') then
      begin
        rpt_flag := false;
        exit;
      end;
        
  if IsAlpha(Look) then
  begin
    write('alpha: ');
    write(Look);
    write('^t');
  end
  else if IsDigit(Look) then
  begin
    write('number: ');
    write(Look);
    write('^t');
  end
  else
  begin
    write('[');
    write(Look);
    Write(']');
  end;
  GetChar;
  rpt_no += 1;
end;

begin
  S := '';
  for i := 1 to 10 do
  begin
    S := S + '*';
    writeln(length(S):2, ' : ', S);
  end;
  writeln('Bytes : ', length(bytes));
  writeln('Words : ', length(words));
  
  Start;
  rpt_flag := true;
  rpt_no := 0;
  while rpt_flag = true do
  begin
    Expression;
    writeln('I completed ' + IntToStr(rpt_no) + ' exprs');
  end;
end.
