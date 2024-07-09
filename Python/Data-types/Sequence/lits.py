marks = [10,45,35,]
print(marks)
print(type(marks))

marks = [50, 20, 90, 30, "suresh"]    # heterogeneous data
print(marks)
print(type(marks))

friends = ["ravi","raja","vamsi"]        # Ordered collection of items
print(friends)
print(type(friends))
print("length of the friends:", len(friends))

marks = [10,34,25]           # Aloow the duplicate values
print(marks)
marks = [10,40,25]
print(marks)


friends = ["vasu","vamsi","varun","seshu"]
print(friends)
print(type(friends))
print("how many words:", len(friends))
marks =[10,45,67,friends]                 # to nested list
print(marks)

# Accessing characters in list
# Indexing
friends = ["vasu","vamsi","varun","seshu"]
print(friends[0])
print(friends[-1])

# Slicing
friends = ["vasu","vamsi","varun","seshu"]
print(friends[1:5])

# Note: Step by default value is 1
friends = ["vasu","vamsi","varun","seshu"]
print(friends[1:4:5])     # doubt
print(friends[:4])
print(friends[:])
print(friends[::2])        # doubt
print(friends[::-1])

# Change list of item
friends = ["vamsi","sai","hari"]
print(friends)
friends[0] = "raja"
print(friends)

# Concatenation and repeating to the list
marks = ["10","49","76"]
friends = ["varma","sai","ajay"]
print(marks + friends)
sum = (marks + friends)
print("how many words:", len(sum))

# Add the items
marks = [10,45,78]
print(marks)
marks.append(67)     # To add the single item we use append
print(marks)

friends = ["raja","bhanu","riya"]
print(friends)
friends.extend(["kavitha","gopi"])    # To add the mulitple items we use extend
print(friends)


# How to add item at specific position
friends = ["sham", "shiva", "gowtham"]
print(friends)
friends.insert(0,"harish")
print(friends)

marks = [27,46,278,23]
print(marks)
marks[5:1]=["a","b"]        # doubt [it is called slicing]
print(marks)


# Delete and remove the list
marks = [13,53,456,35]
print(marks)
del marks

marks = [13,53,456,35]
print(marks)
del marks[0]
print(marks)

friends = ["roja","ravi","balu"]
print(friends)
friends.remove("roja")
print(friends)

friends = ["roja","ravi","balu"]
print(friends.pop(0))               # It will delete first letter in friends
print(friends)

friends = ["roja","ravi","balu"]
print(friends.pop())               # It will delete last letter in friends
print(friends)

marks = [19,23,27,23]
print(marks)
marks.clear()