# Let's make a compoler using python
# step by step from pascal version
# python v3 source file
# cradle.py
def read_char(prompt):
    str_buffer = input(prompt)
    str_buffer += '\n'
    str_len = len(str_buffer)
    idx = 0

    while True:
        while idx < str_len:
            yield str_buffer[idx]
            idx += 1
        str_buffer = input(prompt)
        str_len = len(str_buffer)
        idx = 0


def windowsBell():
    winsound.Beep(500, 300)


def macosBell():
    print('\a')


def linuxBell():
    print('\a')


def GetChar():
    global Look
    Look = next(char_gen)


def Error(string):
    print()
    EmitBell()
    print('Error: ' + string + '.')


def Abort(string):
    Error(string)
    quit()


def Expected(string):
    Abort(string + ' Expected')


def IsAddop(ch):
    ret_val = ch in {'+', '-'}
    return ret_val


def skip_white():
    # python isspace() includes '\n' & fail
    while Look == '\t' or Look == ' ':
        GetChar()


def GetNum():
    value = ''
    if not Look.isnumeric():
        Expected('Integer')
    
    while Look.isnumeric():
        value += Look
        GetChar()
        
    ret_val = value
    skip_white()
    return ret_val


def GetName():
    token = ''
    if not Look.isalpha():
        Expected('Name')

    while (Look.isalpha() or Look.isnumeric()):
        token += Look
        GetChar()

    ret_val = token
    skip_white()
    return ret_val.upper()


def Emit(string):
    print('\t' + string, end='')


def EmitLn(string):
    print('\t' + string)


def Match(ch):
    if Look == ch:
        GetChar()
        skip_white()
    else:
        Expected('\'' + ch + '\'')


def ident():
    name = ''
    name = GetName()
    if Look == '(':
        Match('(')
        Match(')')
        EmitLn('BSR ' + name)
    else:
        EmitLn('MOVE ' + name + '(PC),D0')


def Multiply():
    Match('*')
    Factor()
    EmitLn('MULS (SP)+,D0')


def Divide():
    Match('/')
    Factor()
    EmitLn('MOVE (SP)+,D1')
    EmitLn('DIVS D0,D1')
    EmitLn('MOVE D1,D0')


def Add():
    Match('+')
    Term()
    EmitLn('ADD (SP)+,D0')


def Subtract():
    Match('-')
    Term()
    EmitLn('SUB (SP)+,D0')
    EmitLn('NEG D0')


def start():
    GetChar()
    skip_white()


def Factor():
    if Look == '(':
        Match('(')
        expression()
        Match(')')
    elif Look.isalpha():
        ident()
    else:
        EmitLn('MOVE #' + GetNum() + ',D0')


def Term():
    Factor()
    while Look in {'*', '/'}:
        EmitLn('MOVE D0,-(SP)')
        if Look == '*':
            Multiply()
        elif Look == '/':
            Divide()
        else:
            Expected('Mulop')   


def expression():
    if IsAddop(Look):
        EmitLn('CLR D0')
    else:
        Term()
    while Look in {'+', '-'}:
        EmitLn('MOVE D0,-(SP)')
        if Look == '+':
            Add()
        elif Look == '-':
            Subtract()
        else:
            Expected('Addop')


def assignment():
    name = ''
    name = GetName()
    Match('=')
    expression()
    EmitLn('LEA ' + name + '(PC),A0')
    EmitLn('MOVE D0,(A0)')



def main():
    start()
    assignment()
    if Look != '\n':
        Expected('Newline')
    
    return 0


# Global variable
# Look character for parser
Look = ''
char_gen = read_char("Enter any string: ")
if __name__ == "__main__":
    # Try reading several files varying the buffer size
    import sys

    os = sys.platform
    if os == 'win32':
        import winsound
        EmitBell = windowsBell
    elif os == 'linux':
        EmitBell = linuxBell
    elif os == 'darwin':
        EmitBell = macosBell

    ret_val = main()
    sys.exit(ret_val)
