Look = ''

def read_chars(prompt):
    str_buffer = input(prompt)
    str_len = len(str_buffer)
    
    return str_buffer

        
if __name__ == "__main__":
    while True:
        string = read_chars("Enter any string: ")
        str_len = len(string)
        
        print("Your string is " + str(str_len) + " long")
        print("input is " + "'" + string + "'")
        print("")
