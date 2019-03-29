# Let's make a compoler using python
# step by step from pascal version
# python v3 source file
# cradle.py
def read_char(prompt):
    str_buffer = input(prompt)
    str_len = len(str_buffer)
    idx = 0
    
    while True:
        while idx < str_len:
            yield str_buffer[idx]
            idx += 1
        str_buffer = input(prompt)
        str_len = len(str_buffer)
        idx = 0
    print("** generator ends **")

    
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
    print
    EmitBell()
    print('Error: ' + string + '.')


def Abort(string):
    Error(string)
    quit()

    
def Expected(string):
    Abort(string + ' Expected')

def Match(ch):
    if Look == ch:
        GetChar()
    else:
        Expected('\'' + ch + '\'')
        
def GetNum():
    if not Look.isnumeric():
        Expected('Integer')
    ret_val = Look
    GetChar()
    return ret_val
    
def GetName():
    if not Look.isalpha():
        Expected('Name')
    ret_val = Look
    GetChar()
    return ret_val.upper()
    
def Emit(string):
    print('\t' + string, end = '')

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
    if Look == '+':
        Add()
    elif Look == '-':
        Subtract()

def main():

    start()
    expression()
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
