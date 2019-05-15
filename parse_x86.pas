program Parse;
{$Apptype Console}
uses
  SysUtils;
const
   TAB = ^I;
{ DOS & Windows }
{ CR = ^M; } 

{ Linux & BSD }
   CR =  ^J;
var
   Look: char;   { Lookahead Character }

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

{ Alpha or Numeric }
function IsAlNum(c: char): boolean;
begin
	IsAlNum := IsAlpha(c) or IsDigit(c);
end;

{ Add operator check }
function IsAddop(c : char): boolean;
begin
   IsAddop := c in ['+', '-'];
end;

{ Recognize white space }
function IsWhite(c : char) : boolean;
begin
   IsWhite := c in [' ', TAB];
end;

{ Skip over leading white space }
procedure SkipWhite;
begin
   while IsWhite(Look) do
      GetChar;
end;

{ Match a specific input character }
procedure Match(x : char);
begin
  if Look = x then
  begin
     GetChar;
     SkipWhite;
  end
  else
    Expected('''' + x + '''');
end;

{ Get an identifier }
function GetName : string;
var
   Token : string;
begin
   Token := '';
   if not IsAlpha(Look) then
      Expected('Name');
   while IsAlNum(Look) do
   begin
      Token := Token + UpCase(Look);
      GetChar;
   end;
   GetName := Token;
   SkipWhite;
end;

{ Get a number }
function GetNum: string;
var
   Value : string;
begin
   Value := '';
   if not IsDigit(Look) then
      Expected('Integer');
   while IsDigit(Look) do
   begin
      Value := Value + Look;
      GetChar;
   end;
   GetNum := Value;
   SkipWhite;
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

{ Idetify Routine }
procedure Ident;
var Name : string[8];
begin
   Name := GetName;
   if Look = '(' then
   begin
      Match('(');
      Match(')');
      EmitLn('CALL ' + Name);
   end
   else
      EmitLn('MOV %EAX ' + Name)
end;

{ process a factor/x86 }
procedure Expression; forward;
procedure Factor;
begin
   if Look = '(' then 
   begin
      Match('(');
      Expression;
      Match(')');
   end
   else if IsAlpha(Look) then
      Ident
   else
      EmitLn('MOV %EAX, ' + GetNum)
end;

{ Multiplication Routine }
procedure Multiply;
begin
   Match('*');
   Factor;
   EmitLn('POP %ECX');
   EmitLn('IMUL %ECX');
end;

{ Division Routine }
procedure Divide;
begin
   Match('/');
   Factor;
   EmitLn('MOV %ECX, %EAX');
   EmitLn('POP %EAX');
   EmitLn('XOR %EDX, %EDX');
   EmitLn('IDIV %ECX');
end;

{ process a term }
procedure Term;
begin
   Factor;
   while Look in ['*', '/'] do begin
      EmitLn('PUSH %EAX');
      case Look of
	'*' : Multiply;
	'/' : Divide;
      else Expected('Mulop');
      end;
   end;
end;

{ Addition Routine }
procedure Add;
begin
   Match('+');
   Term;
   EmitLn('POP %ECX');
   EmitLn('ADD %EAX, %ECX');
end;

{ Subtract Routine }
procedure Subtract;
begin
   Match('-');
   Term;
   EmitLn('POP %ECX');
   EmitLn('SUB %EAX, %ECX');
   EmitLn('NEG %EAX');
end;

{ Process expression }
procedure Expression;
begin
   if IsAddop(Look) then
      EmitLn('XOR %EAX, %EAX')
   else
      Term;
   while IsAddop(Look) do begin
      EmitLn('PUSH %EAX');
      case Look of
	'+' : Add;
	'-' : Subtract;
      end;
   end;
end;

{ Assignment Routine }
procedure Assignment;
var Name : string[8];
begin
   Name := GetName;
   Match('=');
   Expression;
   EmitLn('MOV ' + Name + ', %EAX');
end;

{ Initialize }
procedure Init;
begin
   GetChar;
   SkipWhite;
end;

{ Main Program }
begin
   Init;
   Assignment;
   if Look <> CR then
      Expected('Newline');
   ReadLn;
end.
