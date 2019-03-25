def GetChar:
    look = input()

def GetNum:
    if 
def Emit(string):
    print('\t' + string, end='')

def EmitLn(string):
    print('\t' + string)
    
def init:
    GetChar

def Term:
    EmitLn('MOVE #' + GetNum() + ',D0')

def expression:
    Term
    EmitLn('MOVE D0,D1')
    if look == '+':
        Add
    elif look == '-':
        Subtract

def main():
    """Test skeleton for python programming
    devised by jdh69@paran.com

    """
    init
    expression
    
if __name__ == "__main__":
    # Try reading several files varying the buffer size
    import sys
    
    look = ''
    
    first_arg = int(sys.argv[1])
    other_args  = sys.argv[2:]
    print('First arg = ' + first_arg)
    print('Other args = ')
    for x in other_args:
        print(x)
        
    sys.exit(main())























































