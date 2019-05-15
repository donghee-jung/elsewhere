{-----------------------------------------------------}
program Interpreter;
{-----------------------------------------------------}

{ Constant Declarations }
const
   TAB = ^I;
   CR  = ^M;
   LF  = ^J;
{-----------------------------------------------------}
type
   TVarTable = record
		  Key	: string;
		  Value	: integer;
	       end;	
   Tindex    =  1..30;

{ Variable Declarations }
var
   Look	 : char;       { Lookahead Character }
   Table : Array[1..30] of TVarTable;
   index : Tindex;
{-----------------------------------------------------}
{ Read New Character From Input Stream }
procedure GetChar;
begin
   Read(Look);
end;
{--------------------------------------------------------------}
{$IFDEF WINDOWS}
const ENDL = CR;
procedure NewLine;
begin
   if Look = CR then begin
      GetChar;
      if Look = LF then
	 GetChar;
   end;
end;
{$ENDIF}
{--------------------------------------------------------------}
{$IFDEF UNIX}
const ENDL = LF;
procedure NewLine;
begin
   if Look = LF then
      GetChar;
end;
{$ENDIF}
{--------------------------------------------------------------}
{ Report an Error }
procedure Error(s: string);
begin
   WriteLn;
   WriteLn(^G, 'Error: ', s, '.');
end;
{--------------------------------------------------------------}
{ Report Error and Halt }
procedure Abort(s: string);
begin
   Error(s);
   Halt;
end;
{--------------------------------------------------------------}
{ Report What Was Expected }
procedure Expected(s: string);
begin
   Abort(s + ' Expected');
end;
{--------------------------------------------------------------}
{ Recognize white spaces }
function IsWhite(c: char): boolean;
begin
   IsWhite := c in [' ', TAB];
end;
{--------------------------------------------------------------}
{ Recognize an Alpha Character }
function IsAlpha(c: char): boolean;
begin
   IsAlpha := upcase(c) in ['A'..'Z'];
end;
{--------------------------------------------------------------}
{ Recognize a Decimal Digit }
function IsDigit(c: char): boolean;
begin
   IsDigit := c in ['0'..'9'];
end;
{--------------------------------------------------------------}
{ Is alphanumeric }
function IsAlNum(c: char): boolean;
begin
   IsAlNum := IsAlpha(c) or IsDigit(c);
end;

{ Recognize an Addop }
function IsAddop(c: char): boolean;
begin
   IsAddop := c in ['+', '-'];
end;
{--------------------------------------------------------------}
{ Skips white spaces }
procedure SkipWhite;
begin
   while IsWhite(Look) do
      GetChar;
end;
{--------------------------------------------------------------}
{ Match a Specific Input Character }
procedure Match(x: char);
begin
   if Look = x then begin
      GetChar;
      SkipWhite;
   end
   else Expected('''' + x + '''');
end;
{--------------------------------------------------------------}
{ Get an Identifier }
function GetName: string;
var
   Token : string;
begin
   Token := '';
   if not IsAlpha(Look) then Expected('Name');
   while IsAlNum(Look) do
      begin
	 Token := Token + UpCase(Look);
	 GetChar;
      end;
   GetName := Token;
   SkipWhite;
end;
{--------------------------------------------------------------}
{ Get a Number }
function GetNum: integer;
var Value: integer;
begin
   Value := 0;
   if not IsDigit(Look) then Expected('Integer');
   while IsDigit(Look) do begin
      Value := 10 * Value + Ord(Look) - Ord('0');
      GetChar;
   end;
   GetNum := Value;
   SkipWhite
end;
{--------------------------------------------------------------}
{ Output a String with Tab }
procedure Emit(s: string);
begin
   Write(TAB, s);
end;
{--------------------------------------------------------------}
{ Output a String with Tab and CRLF }
procedure EmitLn(s: string);
begin
   Emit(s);
   WriteLn;
end;
{--------------------------------------------------------------}
{ Find key outof Table }
function FindKey(key : string): integer;
var idx	: Tindex;
begin
   FindKey := 0;
   for idx := 1 to 30 do
   begin
      if Table[idx].Key = key then begin
	 FindKey := idx;
	 break;
      end;
   end;
end;

{ Put variable into Table }
procedure PutTable(key : string; val : integer);
var idx	: integer;
begin
   idx := FindKey(key);
   if idx = 0 then begin
      Table[index].key := key;
      Table[index].Value := val;
      if index = 30 then index := 1
      else index := index + 1;
   end
   else begin
      {Table[idx].Key := key;}
      Table[idx].Value := val;
   end;
end;

{ Get variable from Table }
function GetTable(key : string): integer;
var idx	: integer;
begin
   idx := FindKey(key);
   if idx = 0 then
      GetTable := -1
   else
      GetTable := Table[idx].Value;
end;

{ Parse and Translate a Math Factor }
function Expression: integer; Forward;
function Factor:integer;
var flag : integer;
begin
   if Look = '(' then
   begin
      Match('(');
      Factor := Expression;
      Match(')');
   end
   else if IsAlpha(Look) then begin
      flag := GetTable(GetName);
      if flag = -1 then
	 Expected('Name')
      else
	 Factor := flag;
   end
   else
      Factor := GetNum;
end;
{--------------------------------------------------------------}
{ Parse and Translate a Math Term }
function Term: integer;
var Value: integer;
begin
   Value := Factor;
   while Look in ['*', '/'] do begin
      case Look of
         '*':
         begin
            Match('*');
            Value := Value * Factor;
         end;
         '/':
         begin
            Match('/');
            Value := Value div Factor;
         end;
      end;
   end;
   Term := Value;
end;
{--------------------------------------------------------------}
{ Parse and Translate an Expression }
function Expression: integer;
var Value: integer;
begin
   if IsAddop(Look) then
      Value := 0
   else
      Value := Term;
   while IsAddop(Look) do begin
      case Look of
         '+': 
         begin
            Match('+');
            Value := Value + Term;
         end;
         '-':
         begin
            Match('-');
            Value := Value - Term;
         end;
      end;
   end;
   Expression := Value;
end;
{--------------------------------------------------------------}
{ Input Routine }
procedure Input;
var
   val : integer;
   key : string;
begin
   Match('?');
   key := GetName;
   Match('=');
   val := GetNum;
   PutTable(key, val);
end;
{--------------------------------------------------------------}
{ Output Routine }
procedure Output;
begin
   Match('!');
   WriteLn(GetTable(GetName));
end;
{--------------------------------------------------------------}
{ Parse and Translate an Assignment Statement }
procedure Assignment;
var
   Name: string;
   Value: integer;
begin
   Name := GetName;
   Match('=');
   Value := Expression;
   PutTable(Name, Value);
end;
{--------------------------------------------------------------}
{ Initialize the Variable Area }
procedure InitTable;
var i: integer;
begin
   for i := 1 to 30 do
   begin
      Table[i].Key := '';
      Table[i].Value := 0;
   end;
   index := 1;
end;
{--------------------------------------------------------------}
{ Initialize }
procedure Init;
begin
	InitTable;
	GetChar;
end;
{--------------------------------------------------------------}

{ Main Program }
begin
   Init;
   repeat
      case Look of
	'?' : Input;
	'!' : Output;
	else Assignment;
      end;
      NewLine;
   until Look = '.';
end.
{--------------------------------------------------------------}
