name = "manoj"     # We should write string like that
print(name)         # It print the name
print(type(name))   # It shows the data type


# Length
name = "manojvarma"
length = len(name)
print("length of the name:", length)

text = "Python is awesome"
uppercase = text.upper()
lowercase = text.lower()
print("Uppercase:", uppercase)
print("Lowercase:", lowercase)

text = "Python is awesome"
new_text = text.replace("awesome", "great")
print("Modified text:", new_text)

text = "Python is awesome"      # It split the sentances
words = text.split()
print("Words:", words)

text = "Python is awesome"       # It remove the is word in line
words = text.split("is")
print("Words:", words)

text = "   Some spaces around   "      # It remove the spaces
stripped_text = text.strip()
print("Stripped text:", stripped_text)

text = "Python is awesome"
substring = "is"
if substring in text:
    print(substring, "found in the text")

Data = "raju went to home"
substring = "home"
if substring in Data:
    print(substring, "found in the data")
    
# Membership operator in string    
channelName = "surech is awesome"
print("awesome" in channelName)
print("hello" not in channelName)

channelName = "surech is awesome"
print("awesome" in channelName)
print("hello" in channelName)

# Accessing characters in a string
# Indexing
channelName = 'Suresh Tech'
print(channelName[0])
print(channelName[-1])

# Slicing
channelName = 'Suresh Tech'
print(channelName[0:5])

# Note: Step by default value is 1
channelName = 'Suresh Tech'
print(channelName[1:4:5])     # doubt
print(channelName[:4])
print(channelName[:])
print(channelName[::2])        # doubt
print(channelName[::-1])


# # Deleting/updating a string
# # update string
# name = 'suresh'
# name = 'harish'
# print(name)  # Output: harish

name = 'harish'
del name
print(name)

# # modification
# name = 'suresh'
# # Change 'r' at index 2 to 'w'
# name = name[:2] + 'w' + name[3:]
# print(name)  # Output: suwesh
# print(type(name))


# Final overview about string
name = "manoj"
print(name)
print(type(name))
print("length of the name: ", len(name))  # length of the name
uppercase = name.upper()                  # Uppercase
print(uppercase)                          
lowercase = name.lower()                  # lowercase
print(lowercase)
replace = name.replace("manoj", "varma")          # replace the name
print(replace)
candidate = "Manoj varma"
print(candidate)
split = candidate.split()                # it split the names
print(split)
remove = candidate.split("varma")
print(remove)
item = "  mango  "                 # It remove the spaces strip
word = item.strip()
print(word)                 
person = "varun"                   # index accesing
print(person[1])
print(person[0:3])                  # Slice accessing
del person                          # to delete



