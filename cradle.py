def GetChar():
    look = input('Please input an expression: ')

def Error(string):
    print
    winsound.Beep(500, 300)
    print('Error: ' + string + '.')

def Abort(string):
    Error(string)
    quit()
    
def Expected(string):
    Abort(string + ' Expected')

def Match(ch):
    if look == ch:
        GetChar()
    else:
        Expected('\'' + ch + '\'')
        
def GetNum():
    if not look.isnumeric():
        Expected('Integer')
    ret_val = look
    GetChar()
    return ret_val
    
def GetName():
    if not look.isalpha():
        Expected('Name')
    ret_val = look
    GetChar()
    return ret_val.upper()
    
def Emit(string):
    print('\t' + string, end='')

def EmitLn(string):
    print('\t' + string)
    
def Add():
    Match('+')
    Term()
    EmitLn('ADD D1,D0')
    
def Subtract():
    Match('-')
    Term()
    EmitLn('SUB D1,D0')
    
def start():
    GetChar()

def Term():
    EmitLn('MOVE #' + GetNum() + ',D0')

def expression():
    Term()
    EmitLn('MOVE D0,D1')
    if look == '+':
        Add()
    elif look == '-':
        Subtract()

def main():

    start()
    expression()
    return 0

if __name__ == "__main__":
    # Try reading several files varying the buffer size
    import sys
    
    os = sys.platform
    if os == 'win32':
        import winsound
    elif os == 'linux':
        pass
    
    look = ''
    
    if len(sys.argv) == 1:
        pass
    elif len(sys.argv) == 2:
        first_arg = int(sys.argv[1])
        print('First arg = ' + first_arg)
    else:
        first_arg = sys.argv[1]
        print('First arg = ' + first_arg)
        other_args  = sys.argv[2:]
        print('Other args = ')
        for x in other_args:
            print(x)
    
    print('Here comes the main routine')
    ret_val = main()
    
    sys.exit(ret_val)
