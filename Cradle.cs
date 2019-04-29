// Let's make a compoler using C#
// step by step from python version
// cradle.cs
using System;

class Parser 
{
    // constructor
    public Parser()
    {
        GetChar();
    }

    public Parser(string msg) 
    {
        Console.WriteLine(msg);
        GetChar();
    }
    
    // property
    protected char look 
    {
        get;
        set;
    }
    
    // method
    protected void GetChar()
    {
        int x;
        x = Console.Read();
        try
        {
            look = Convert.ToChar(x);
        }
        catch (OverflowException e)
        {
            Console.WriteLine("{0} Value read = {1}.", e.Message, x);
            look = '0';
        }
    }

    protected void Error(string msg)
    {
        Console.Beep();
        Console.WriteLine(msg);
    }

    protected void Abort(string msg)
    {
        Error(msg);
        throw new ArgumentException();
    }

    protected void Expected(string msg)
    {
        Abort(msg + " Expected");
    }

    protected void SkipWhite()
    {
        while (look == '\t' || look == ' ')
            GetChar();
    }

    protected string GetNum()
    {
        string value = "";
        if (Char.IsNumber(look) == false)
            Expected("Integer");
        while (Char.IsNumber(look))
        {
            value += look;
            GetChar();
        }
        SkipWhite();
        return  value;
    }

    protected string GetName()
    {
        string token = "";
        if (Char.IsLetter(look) == false)
            Expected("Name");
        while (Char.IsLetter(look) || Char.IsNumber(look))
        {
            token += look;
            GetChar();
        }
        SkipWhite();
        return token;
    }

    protected void Emit(string msg)
    {
        Console.Write(msg);
    }

    protected void EmitLn(string msg)
    {
        Console.WriteLine(msg);
    }

    protected void Match(char ch)
    {
        if (look == ch)
        {
            GetChar();
            SkipWhite();
        }
        else
        {
            Expected("\'" + ch + "\'");
        }
    }

    protected void Ident()
    {
        string name;
        name = GetName();
        if (look == '(')
        {
            Match('(');
            Match(')');
            EmitLn("BSR " + name);
        }
        else
        {
            EmitLn("MOVE " + name + "(PC),D0");
        }
    }

    protected void Multiply()
    {
        Match('*');
        Factor();
        EmitLn("MULS (SP)+,D0");
    }

    protected void Divide()
    {
        Match('/');
        Factor();
        EmitLn("MOVE (SP)+,D1");
        EmitLn("DIVS D0,D1");
        EmitLn("MOVE D1,D0");
    }

    protected void Add()
    {
        Match('+');
        Term();
        EmitLn("ADD (SP)+,D0");
    }

    protected void Subtract()
    {
        Match('-');
        Term();
        EmitLn("SUB (SP)+,D0");
        EmitLn("NEG D0");
    }

    protected void Factor()
    {
        if (look == '(')
        {
            Match('(');
            Expression();
            Match(')');
        }
        else if (Char.IsLetter(look))
        {
            Ident();
        }
        else
        {
            EmitLn("MOVE #" + GetNum() + ",D0");
        }
    }

    protected void Term()
    {
        Factor();
        while (look == '*' || look == '/')
        {
            EmitLn("MOVE D0,-(SP)");
            switch (look)
            {
                case '*':
                    Multiply();
                    break;
                case '/':
                    Divide();
                    break;
                default:
                    Expected("Mulop");
                    break;
            }
        }
    }

    protected void Expression() {
        if (look == '+' || look == '-')
            EmitLn("CLR D0");
        else
            Term();
        while (look == '+' || look == '-')
        {
            EmitLn("MOVE D0,-(SP)");
            switch (look)
            {
                case '+':
                    Add();
                    break;
                case '-':
                    Subtract();
                    break;
                default:
                    Expected("Addop");
                    break;
            }
        }
    }

    public void Assignment()
    {
        string name;
        name = GetName();
        Match('=');
        Expression();
        EmitLn("LEA " + name + "(PC),A0");
        EmitLn("MOVE D0,(A0)");
    }
}

class Cradle 
{
    static void Main() 
    {
        string usage = "\nType a string of any expression : A = B * (C + D)\n";
    
        Parser my_parser = new Parser(usage);
        my_parser.Assignment();
    }
}
     