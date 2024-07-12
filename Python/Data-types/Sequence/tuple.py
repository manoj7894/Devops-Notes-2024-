marks = (10,23,45)
print(marks)
print(type(marks))

marks = 10,13,34,34         # we can create without parenthesis
print(marks)
print(type(marks))

marks = 23,235,245,45
total = 123,123,456,67
sum = marks + total
print("addtion:", sum)
print(type(sum))

friends = ("ravi","raja","seshu")
marks = 10,243,46,friends                     # nested list
print(marks)
print(type(marks))

marks = 12,45,64,64
print(marks[0])

marks = 12,45,64,64
print(marks[1:3])
print(marks[-1])


marks = 20,50,80
friend = ("nadhu","raja","tani",[20,78,29])
print(type(marks))
print(type(friend))
print(marks[0])
print(friend[-1])
print(friend[3][-1])
friend[3][1] = "ravi"
print(friend)

# What is the difference between list and tuple
# List
friends = ["ravi", "seshu", "hari"]
print(friends)
friends.append("vamsi")
print(type(friends))
print(friends)

#Tuple
friends = ("ravi", "seshu", "hari")
print(friends)
friends.append("vamsi")
print(type(friends))
print(friends)


# Final overview of tuple
name = ("raja", "ravi")
print(type(name))
print(name)
marks = ("14", "34", "45", name)        # nested list
print(marks)
print(marks[0])                          # index accesing
print(marks[0][-1])
print(marks[0:1])                        # slice accessing






