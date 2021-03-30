def Keycreate(f,g):
    h = (Rq(1)/f)*g
    return h

def Encrypt(m,q,h):
    rend = round(sqrt(q/2))
    r = randint(1,rend)
    print("r = ",r)
    e = (r*h + m)
    return e

def Decrypt(e,f,g):
    a = f*e
    b = (Rg(1)/f)*Rg(a)
    return b

def Gaussian(V):
    m = 1
    while (m!=0):
        if (V[1].norm() <= V[0].norm()):
            tmp = V[1]
            V[1] = V[0]
            V[0] = tmp
        m = round(V[0]*V[1]/(V[0].norm())^2)
        #print("m=",m)
        V[1] -= m*V[0]
        #print("V = ",V)
    return V


q = 122430513841
f = 231231
g = 195698
m = 123456
Rq = Integers(q)
Rg = Integers(g)
h = Keycreate(f,g)
hh = lift(h)
V = Matrix([[1,hh],[0,q]])
e = Encrypt(m,q,h)
b = Decrypt(e,f,g)
VV = Gaussian(V)
print("b = ",b)
print("VV = ",VV)