{-----------------------------------------------------}
program Cradle;
{-----------------------------------------------------}

{ Constant Declarations }
const TAB = ^I;
{-----------------------------------------------------}

{Variable Declarations }
var Look: char;
{-----------------------------------------------------}

procedure GetChar;
begin
  Read(Look);
end;
{-----------------------------------------------------}

procedure Error(s: string);
begin { Error }
   WriteLn;
   WriteLn(^G, 'Error: ', s, '.');
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

function GetName: char;
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
	Write(TAB, s);
end;
{-----------------------------------------------------} 

procedure EmitLn(s: string);
begin
	Write(TAB, s);
	WriteLn;
end;
{-----------------------------------------------------}

procedure Term;
begin
   EmitLn('MOVE #' + GetNum + ',D0')
end;
{-----------------------------------------------------}

procedure Add;
begin
   Match('+');
   Term;
   EmitLn('ADD D1,D0');
end;
{-----------------------------------------------------}

procedure Subtract;
begin
   Match('-');
   Term;
   EmitLn('SUB D1,D0');
end;
{-----------------------------------------------------}

procedure Expression;
begin
   Term;
   EmitLn('MOVE D0,D1');
   case Look of
     '+' : Add;
     '-' : Subtract;
   else Expected('Addop');
   end;
end;
{-----------------------------------------------------}

procedure Init;
begin
	GetChar;
end;

{ Main Program }
begin
   Init;
   Expression;
end.
{-----------------------------------------------------} 
