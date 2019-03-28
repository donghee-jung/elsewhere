Look = ''

def read_char(prompt):
    print("[ GENERATOR begin ]")
    str_buffer = input(prompt)
    str_len = len(str_buffer)
    idx = 0
    rpt_no = 0
    
    while True:
        while idx < str_len:
            print("< YIELD before >")
            yield str_buffer[idx]
            print("< YIELD after >")
            idx += 1
            print("idx = " + str(idx))
            
        print("Buffer empty, reload required")
        rpt_no += 1
        str_buffer = input(str(rpt_no) + "th reload: ")
        str_len = len(str_buffer)
        idx = 0
        
    print("[ GENERATOR end ]")

        
if __name__ == "__main__":
    read_gen = read_char("Enter any string: ")
    while True:
        Look = next(read_gen)
        print('[' + Look + ':' + str(ord(Look)) + ']')
