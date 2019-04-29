{-----------------------------------------------------}
program Cradle;
{-----------------------------------------------------}

{ Constant Declarations }
const 
TAB = ^I;

{ DOS & Windows }
{ CR = ^M; } 

{ Linux & BSD }
CR = ^J;
{-----------------------------------------------------}

{Variable Declarations }
var 
Look: char;
{-----------------------------------------------------}

procedure GetChar;
begin
  Read(Look);
end;
{-----------------------------------------------------}

procedure Error(s: string);
begin { Error }
   writeln;
   writeln(^G, 'Error: ', s, '.');
end; { Error }
{-----------------------------------------------------}

procedure Abort(s: string);
begin { Abort }
   Error(s);
   Halt;
end; { Abort }
{-----------------------------------------------------}

procedure Expected(s: string);
begin 
	Abort(s + ' Expected');
end;
{-----------------------------------------------------}

procedure Match(x: char);
begin
	if Look = x then GetChar
	else Expected('''' + x + '''');
end;
{-----------------------------------------------------}
	
function IsAlpha(c: char): boolean;
begin
	IsAlpha := upcase(c) in ['A'..'Z'];
end;
{-----------------------------------------------------} 

function IsDigit(c: char): boolean;
begin
	IsDigit := c in ['0'..'9'];
end;
{-----------------------------------------------------} 

function IsAlNum(c: char): boolean;
begin
	IsAlNum := IsAlpha(c) or IsDigit(c);
end;
{-----------------------------------------------------}

function IsAddop(c : char): boolean;
begin
   IsAddop := c in ['+', '-'];
end;
{-----------------------------------------------------}

function GetName   : char;
begin
	if not IsAlpha(Look) then Expected('Name');
	GetName := UpCase(Look);
	GetChar;
end;
{-----------------------------------------------------}

function GetNum: char;
begin
   if not IsDigit(Look) then Expected('Integer');
   GetNum := Look;
   GetChar;
end;
{-----------------------------------------------------}

procedure Emit(s: string);
begin
	write(TAB, s);
end;
{-----------------------------------------------------} 

procedure EmitLn(s: string);
begin
	write(TAB, s);
	writeln;
end;
{-----------------------------------------------------}

procedure Ident;
var Name: char;
begin
   Name := GetName;
   if Look = '(' then
   begin
      Match('(');
      Match(')');
      EmitLn('BSR ' + Name);
   end
   else
      EmitLn('MOVE ' + Name + '(PC),D0')
end;
{-----------------------------------------------------}

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
      EmitLn('MOVE #' + GetNum + ',D0')
end;
{-----------------------------------------------------}

procedure Multiply;
begin
   Match('*');
   Factor;
   EmitLn('MULS (SP)+,D0')
end;
{-----------------------------------------------------}

procedure Divide;
begin
   Match('/');
   Factor;
   EmitLn('MOVE (SP)+,D1');
   EmitLn('DIVS D0,D1');
   EmitLn('MOVE D1,D0');
end;
{-----------------------------------------------------}

procedure Term;
begin
   Factor;
   while Look in ['*', '/'] do begin
      EmitLn('MOVE D0,-(SP)');
      case Look of
	'*' : Multiply;
	'/' : Divide;
      else Expected('Mulop');
      end;
   end;
end;
{-----------------------------------------------------}

procedure Add;
begin
   Match('+');
   Term;
   EmitLn('ADD (SP)+,D0');
end;
{-----------------------------------------------------}

procedure Subtract;
begin
   Match('-');
   Term;
   EmitLn('SUB (SP)+,D0');
   EmitLn('NEG D0');
end;
{-----------------------------------------------------}

procedure Expression;
begin
   if IsAddop(Look) then
      EmitLn('CLR D0')
   else
      Term;
   while Look in ['+', '-'] do begin
      EmitLn('MOVE D0,-(SP)');
      case Look of
	'+' : Add;
	'-' : Subtract;
      else Expected('Addop');
      end;
   end;
end;
{-----------------------------------------------------}

procedure Assignment;
var Name: char;
begin
   Name := GetName;
   Match('=');
   Expression;
   EmitLn('LEA ' + Name + '(PC),A0');
   EmitLn('MOVE D0,(A0)')
end;
{-----------------------------------------------------}

procedure Init;
begin
	GetChar;
end;

{ Main Program }
(* var msg: String; *)
begin
   Init;
   Assignment;
   (* Str(Ord(Look), msg);
   writeln('Look = ' + msg);
   Str(Ord(CR), msg);
   writeln('CR = ' + msg); *)
   if Look <> CR then Expected('Newline');
end.
{-----------------------------------------------------} 
