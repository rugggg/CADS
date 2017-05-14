import random

f = open("rand_ints.txt", 'w')
for i in range(100000000):
	f.write(str(random.randint(0,1000000000)))
	f.write('\n')
