dim = 6

def myGSO(V):
    mu = Matrix(QQ,dim)
    VV = Matrix(QQ,dim)
    for i in range(dim):
        mu[i,i] = 1
        VV[i] = V[i]
    for i in range (1,dim):
        for j in range(i):
            mu[i,j] = V[i]*VV[j]/VV[j].norm()^2
            VV[i] -= mu[i,j] * VV[j]
    return VV,mu

def sizereduce(V,mu,i,j):
    if abs(mu[i,j]) > 0.5:
        q = round(mu[i,j])
        V[i] -= q*V[j]
        for l in range(j+1):
            mu[i,l] -= q * mu[j,l]
    return V,mu

def SizeReduce(V):
    VV,mu = myGSO(V)
    for i in range(1,n):
        for j in range (i-1,0,-1):
            V,mu = sizereduce(V,mu,i,j)
    return V,mu

def GSOupdate(mu,VN,k):
    nu = mu[k,k-1]
    B = VN[k]+nu*nu*VN[k-1]
    mu[k,k-1] = nu*VN[k-1]/B
    VN[k] = VN[k]*VN[k-1]/B
    VN[k-1] = B
    for j in range(k-1):
        t = mu[k-1,j]
        mu[k-1,j] = mu[k,j]
        mu[k,j] = t
    for i in range(k+1,dim):
        t = mu[i,k]
        mu[i,k] = mu[i,k-1] - nu*t
        mu[i,k-1] = t+mu[k,k-1]*mu[i,k]
    return mu,VN

def H(V): #Hadamard ratio (1に近いほど直交に近い "良い" 基底)
    under = 1
    for i in range (dim):
        under = under *  V[i].norm()
    Had = (abs(det(V)) / under)^(1/dim)
    return Had

def Mswap(V,n,m):
    tmp = vector(QQ,dim)
    tmp = V[n]
    V[n] = V[m]
    V[m] = tmp
    return V

def myLLL(V):
    VV,mu = myGSO(V)
    k = 1
    counter = 1
    VN = vector(QQ,dim)
    for i in range(dim):
        VN[i] = VV[i].norm()^2
    while k <= dim-1:
        for j in range (k-1,-1,-1):
            #print(k,j)
            #print(mu[k,j])
            #if abs(mu[k,j]) > 1/2:
                #m = round(mu[k,j])
                #V[k] -= m*V[j]
                #for l in range (j+1):
                    #mu[k,l] -= m*mu[j,l]
            V,mu = sizereduce(V,mu,k,j)
        if VN[k] >= (0.75-mu[k,k-1]^2)*VN[k-1]:
            k += 1
        else:
            counter += 1
            V = Mswap(V,k,k-1)
            #VV,mu = myGSO(V)
            mu,VN = GSOupdate(mu,VN,k)
            k = max(k-1,1)
            #for i in range(dim):
                #VN[i] = VV[i].norm()^2
    print("swap is ",counter)
    return V

#M = Matrix([[9,2,7],[8,6,1],[3,2,6]])
#M = Matrix([[-2,7,7,-5],[3,-2,6,-1],[2,-8,-9,-7],[8,-9,6,-4]])
M = Matrix([[19,2,32,46,3,33],[15,42,11,0,3,24],[43,15,0,24,4,16],[20,44,44,0,18,15],[0,48,35,16,31,31],[48,33,32,9,1,29]])
GSOM , mu = myGSO(M)
MMM = myLLL(M)
print("myLLL(M) = ",MMM)
print("LLL(M) = ",M.LLL())