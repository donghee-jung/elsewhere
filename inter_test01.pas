{-----------------------------------------------------}
program InterpreterTest01;
{-----------------------------------------------------}

{ Constant Declarations }
const
   TAB = ^I;
   CR  = ^M;
   LF  = ^J;

type
   TSetVars =  record
      Keys: string;
      Values: integer;
end;

{ Variable Declarations }
var
Look: char;       { Lookahead Character }
Table: Array[1..30] of TSetVars;

{ Init Table Array }
procedure InitTable;
var i: integer;
begin
   for i := 0 to 30 do
   begin
      Table[i].Keys := '';
      Table[i].Values := 0;
   end;
end;

{ Put variable into Table }
procedure PutTable(key: string; val: integer);
begin
   Table[1].Values := val;
end;

{ Get variable from Table }
function GetTable(key: string): integer;
begin
   GetTable := Table[1].Values;
end;

{ Main Program }
begin
   InitTable;
   PutTable('A12', 9);
   PutTable('BBC1', 12);
   WriteLn(GetTable('A12'));
   WriteLn(GetTable('BB1'));
end.
