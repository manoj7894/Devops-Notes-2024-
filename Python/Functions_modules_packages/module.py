import function as basic_cal

basic_cal

import function as basic_cal

basic_cal.addition()


import sys
def addition(num1, num2):
    addition = (num1 + num2)
    return addition

def sub(num1, num2):
    sub = (num1 - num2)
    return sub

num1 = float(sys.argv[1])
operation = sys.argv[2]
num2 = float(sys.argv[3])

if operation == "addition":
    output = addition(num1, num2)
    print(output)
    
    
    
import os
    
print(os.getenv("password"))     # To print the terminal env variables
    