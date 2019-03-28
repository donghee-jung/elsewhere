def GetChar:
    look = input()

def Error(string):
    print
    winsound.Beep(500, 300)
    print('Error: ' + string + '.')

def Abort(string):
    Error(string)
    quit()
    
def Expected(string):
    Abors(string + ' Expected')

def Match(ch):
    if look == ch:
        GetChar()
    else:
        Expected('\'' + ch + '\'')
        
def GetNum:
    if not look.isnumeric():
        Expected('Integer')
    ret_val = look
    GetChar()
    return ret_val
    
def GetName:
    if not look.isalpha():
        Expected('Name')
    ret_val = look
    GetChar()
    return ret_val.upper()
    
def Emit(string):
    print('\t' + string, end='')

def EmitLn(string):
    print('\t' + string)
    
def Add:
    Match('+')
    Term()
    EmitLn('ADD D1,D0')
    
def Subtract:
    Match('-')
    Term()
    EmitLn('SUB D1,D0')
    
def init:
    GetChar()

def Term:
    EmitLn('MOVE #' + GetNum() + ',D0')

def expression:
    Term
    EmitLn('MOVE D0,D1')
    if look == '+':
        Add()
    elif look == '-':
        Subtract()

def main():
    """Test skeleton for python programming
    devised by jdh69@paran.com

    """
    init
    expression
    
if __name__ == "__main__":
    # Try reading several files varying the buffer size
    import sys
    
    os = sys.platform
    if os == 'win32':
        import winsound
    elif os == 'linux':
        pass
    
    look = ''
    
    first_arg = int(sys.argv[1])
    other_args  = sys.argv[2:]
    print('First arg = ' + first_arg)
    print('Other args = ')
    for x in other_args:
        print(x)
        
    sys.exit(main())
