ec2_instance = {
    "name": "Instance1",
    "instance_type": "t2.micro",
    "key_pair": "manoj"
}

print(ec2_instance, type(ec2_instance))
print(ec2_instance["name"])               # Accessing
ec2_instance["subnet_id"] = "123.8.9.0"    # adding
print(ec2_instance)
ec2_instance["name"] = "instance"
print(ec2_instance)                   # Modifying
del ec2_instance["subnet_id"]         # Deleting
print(ec2_instance)
