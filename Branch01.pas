program Branch01;
{$Apptype Console}
uses
  SysUtils;
const
  TAB = ^I;
var
  Look : char;              { Lookahead Character }
  Lcount : integer;         { Label Counter }

{ Read new character from input stream }
procedure GetChar;
begin
  Read(Look);
end;

{ Report an error }
procedure Error(s : string);
begin
  WriteLn;
  WriteLn(^G, 'Error: ', s, '.');
  ReadLn;
end;

{ Report error and halt }
procedure Abort(s : string);
begin
  Error(s);
  Halt;
end;

{ Report what was expected }
procedure Expected(s : string);
begin
  Abort(s + ' Expected');
end;

{ Match a specific input character }
procedure Match(x : char);
begin
  if Look = x then
    GetChar
  else
    Expected('''' + x + '''');
end;

{ Recognize an alpha character }
function IsAlpha(c : char): boolean;
begin
  IsAlpha := UpCase(c) in ['A'..'Z'];
end;

{ Recognize a decimal digit }
function IsDigit(c : char): boolean;
begin
  IsDigit := c in ['0'..'9'];
end;

{ Get an identifier }
function GetName : char;
begin
  if not IsAlpha(Look) then
    Expected('Name');
  GetName := UpCase(Look);
  GetChar;
end;

{ Get a number }
function GetNum: char;
begin
  if not IsDigit(Look) then
    Expected('Integer');
  GetNum := Look;
  GetChar;
end;

{ Output a string with tab }
procedure Emit(s : string);
begin
  Write(TAB, s);
end;

{ Output a string with tab and CRLF }
procedure EmitLn(s : string);
begin
  Emit(s);
  WriteLn;
end;

{ Generate a unique label }
function NewLabel : string;
var
  S : string;
begin
  Str(Lcount, S);
  NewLabel := '@L' + S;
  Inc(Lcount);
end;

{ Post a label To output }
procedure PostLabel(L : string);
begin
  WriteLn(L, ':');
end;

procedure Expression;
begin
  EmitLn('<expr>');
end;

{ Parse and translate a Boolean condition }
{ This version is a dummy }
procedure Condition;
begin
  EmitLn('<condition>');
end;

{ Recognize and translate an IF construct }
procedure Block(L : string); forward;
procedure DoIf(L : string);
var
  L1, L2 : string;
begin
  Match('i');
  Condition;
  L1 := NewLabel;
  L2 := L1;
  EmitLn('JE ' + L1);
  Block(L);
  if Look = 'l' then
  begin
    Match('l');
    L2 := NewLabel;
    EmitLn('JMP ' + L2);
    PostLabel(L1);
    Block(L);
  end;
  Match('e');
  PostLabel(L2);
end;

{ Parse and translate a WHILE statement }
procedure DoWhile;
var
  L1, L2 : string;
begin
  Match('w');
  L1 := NewLabel;
  L2 := NewLabel;
  PostLabel(L1);
  Condition;
  EmitLn('JE ' + L2);
  Block('');
  Match('e');
  EmitLn('JMP ' + L1);
  PostLabel(L2);
end;

procedure DoLoop;
var
  L1, L2 : string;
begin
  Match('p');
  L1 := NewLabel;
  L2 := NewLabel;
  PostLabel(L1);
  Block(L2);
  Match('e');
  EmitLn('JMP ' + L1);
  PostLabel(L2);
end;

procedure DoRepeat;
var
  L : string;
begin
  Match('r');
  L := NewLabel;
  PostLabel(L);
  Block('');
  Match('u');
  Condition;
  EmitLn('JE ' + L);
end;

procedure DoFor;
var
  L1, L2 : string;
  Name : char;
begin
  Match('f');
  L1 := NewLabel;
  L2 := NewLabel;
  Name := GetName;
  Match('=');
  Expression;
  EmitLn('MOV ' + Name + ', EAX');
  EmitLn('DEC ' + Name);
  Expression;
  EmitLn('PUSH EAX');
  PostLabel(L1);
  EmitLn('INC ' + Name);
  EmitLn('POP EAX');
  EmitLn('CMP ' + Name + ', EAX');
  EmitLn('JG ' + L2);
  EmitLn('PUSH EAX');
  Block('');
  Match('e');
  EmitLn('JMP ' + L1);
  PostLabel(L2);
end;

{ Parse and translate a DO statement }
procedure DoDo;
var
  L : string;
begin
  Match('d');
  L := NewLabel;
  Expression;
  EmitLn('PUSH ECX');
  EmitLn('MOV ECX, EAX');
  PostLabel(L);
  Block('');
  Match('e');
  EmitLn('LOOP ' + L);
  EmitLn('POP ECX');
end;

{ Recognize and translate an "Other" }
procedure Other;
begin
  EmitLn(GetName);
end;

{ Recognize and translate a BREAK }
procedure DoBreak(L : string);
begin
  Match('b');
  if L <> '' then
    EmitLn('JMP ' + L)
  else
    Abort('No loop to break from');
end;

{ Recognize and translate a statement block }
procedure Block(L : string);
begin
  while not(Look in ['e', 'l', 'u']) do
  begin
    case Look of
      'i' : DoIf(L);
      'w' : DoWhile;
      'p' : DoLoop;
      'r' : DoRepeat;
      'f' : DoFor;
      'd' : DoDo;
      'b' : DoBreak(L);
    else
      Other;
    end;
  end;
end;

{ Parse and translate a program }
procedure DoProgram;
begin
  Block('');
  if Look <> 'e' then
    Expected('End');
  WriteLn('//End of generated code');
end;

{ Initialize }
procedure Init;
begin
  Lcount := 0;
  GetChar;
end;

{ Main Program }
begin
  Init;
  DoProgram;
  ReadLn;
end.
