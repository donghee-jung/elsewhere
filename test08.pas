Program Test08;
  
var
  Look : char;

const
  {TAB = ^I;}
  TAB = ' ';

procedure GetChar;
begin
  Read(Look);
end;

function Match(x: char): boolean;
begin
  Match := true;
  if Look = x then GetChar
  else Match := false;
end;

begin
  while true do
  begin
    GetChar;
    write('[' + Look + ':');
    write(ord(Look));
    write(']');
    writeln(TAB);
    if Match('e') then
      if Match('n') then
        if Match('d') then
          break;
  end;
  writeln('Progarm ends peacefully')
end.
