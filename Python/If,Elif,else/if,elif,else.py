# import sys

# type = sys.argv[1]

# if type == "t2.micro":
#     print("it will create the ec2_instance")
    

# import sys

# type = sys.argv[1]

# if type == "t2.micro":
#     print("it will create the ec2_instance")
# else:
#     print("it wont create the ec2_instacne")
    
    
    
import sys

type = sys.argv[1]

if type == "t2.micro":
    print("it will create the ec2_instance")
elif type == "t3.medium":
    print("it will t3.medium instance")
else:
    print("provide vaild type")
    
    

