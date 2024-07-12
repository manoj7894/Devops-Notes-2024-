# Input
cash = input()
print("Amount is =",cash)

cash = input()
remainingAmount = 4000
print('Take your cash',cash,remainingAmount,sep="->")
print('Thank you')

cash = input()
remainingAmount = 4000
print('Take your cash',cash,remainingAmount,sep="->",end="->")
print('Thank you')

cash = input("enter the cash value:" )
remainingAmount = 4000
print('Take your cash',cash,remainingAmount,sep="->",end="->")
print('Thank you',end="\t")
print('welcome')


cash = input("enter the cash value:" )
print(type(cash))
remainingAmount = 4000
print(type(remainingAmount))
changetype = int(cash)
print(type(changetype))
sum = changetype + remainingAmount
print(sum)
print(type(sum))

# How to take the money from ATM 
print("please insert the card")
pin = input("Enter the PIN number: ",)
print("Sucessfully enter the PIN value")
Amount = int(input("Enter the amount: ", ))
print(Amount)
Totalamount = 5000
remainingAmount = Totalamount - Amount
print("Balance money:",remainingAmount)

marks = input("enter the marks:").split()
print(marks)

marks = input("enter the marks:").split(",")
print(marks)

pin, cash = input('Enter your pin and cash').split(',')
print('pin and cash',pin,cash)

# Output

cash = 1000
remainingAmount = 4000
print('Take your cash',cash,remainingAmount,sep="-")



