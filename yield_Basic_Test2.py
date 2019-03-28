# python3 version source
# yield generator test source
# yield_Basic_Test.py


def number_generator(n):
    print("Function Start")
    while n < 6:
        yield n
        n += 1
    print("Function End")


if __name__ == "__main__":
    num_gen = number_generator(0)
    
    for i in num_gen:
        print(i)
        
    num1 = next(num_gen)
    num2 = next(num_gen)
    num3 = next(num_gen)
    print(num1)
    print(num2)
    print(num3)
    
    num4 = next(num_gen)
    print(num4)
    num5 = next(num_gen)
    print(num5)
    num6 = next(num_gen)
    print(num6)
    num7 = next(num_gen)
    print(num7)
    