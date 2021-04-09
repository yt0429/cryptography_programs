def SSP(M,S):
    x = vector(ZZ,len(M))
    for i in range (len(M)-1,-1,-1):
        if S >= M[i]:
            x[i] = 1
            S -= M[i]
        else:
            x[i] = 0
    return x

def Keycreate(r,A,B):
    M = vector(ZZ,len(r))
    for i in range (len(r)):
        M[i] = (A*r[i])%B
    return M

def Encrypt(x,M):
    S = vector(ZZ,len(r))
    S = x*M
    return S

def Decrypt(S,A,B):
    SS = (RB(1)/A)*RB(S)
    x = SSP(r,lift(SS))
    return x

def knapsackMat(M,S):
    n = len(M)
    V = Matrix(ZZ,n+1)
    for i in range(n):
        V[i,i] = 2
        V[n,i] = 1
        V[i,n] = M[i]
    V[n,n] = S
    return V


r = vector([3,11,24,50,115])
A = 113
B = 250
RB = Integers(B)
x = vector([1,0,1,0,1])
M = Keycreate(r,A,B)
S = Encrypt(x,M)
XX = Decrypt(S,A,B)
V = knapsackMat(M,S)
print("V = ",V)
VV = V.LLL()
x = V.solve_left(VV[0])
sum = x*V
print(sum)