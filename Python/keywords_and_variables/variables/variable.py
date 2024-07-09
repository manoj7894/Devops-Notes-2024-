name = "manoj"           # lower case
print(name)
print(type(name))

Full_name = "manoj"         # Snake_case
print(Full_name)
print(type(Full_name))
print("length of the name:", len(Full_name))

fullName = "manoj"
print(fullName)
print(type(fullName))
uppercase = fullName.upper()
print(uppercase)

# local variables
def addition():
    a = 15                      # if we keep values inside the funcation that is local variables
    b = 5
    print(a + b)
    
def sub():
     print(a + b)
    
addition()
sub()                  # Answer wont come because we keep values in local

# Global variables
a = 15                      # if we keep values inside the funcation that is global variables
b = 5
def addition(): 
    print(a + b)
    
def sub():
     print(a + b)
    
addition()
sub()  

# Global variables
a = 15                      # if we keep values inside the funcation that is global variables
b = 5
def addition(): 
    c = 10
    print(a + b + c)
    
def sub():
     print(a + b)
    
addition()
sub()


