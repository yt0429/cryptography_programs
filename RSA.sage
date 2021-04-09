p=17;q=19
N = p*q
L = lcm(p-1,q-1)
while(1):
    E = randint(1,144)
    if gcd(E,L) == 1:
        break
EE = IntegerModRing(L)(E)
D = IntegerModRing(L)(1)/EE
m = randint(1,N)
e = mod(m^E,N)
print("m = ",m)
print("chipertext e = ",e)
print("m = ",mod(e^D,N))