dim = 4 # 行列の次元

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

def GSOupdate_deep(mu,VN,i,k):
    P = vector(QQ,dim)
    D = vector(QQ,dim)
    S = vector(QQ,dim)
    P[k] = VN[k] ; D[k] = VN[k]
    for j in range(k-1,i-1,-1):
        P[j] = mu[k,j]*VN[j]
        D[j] = D[j+1] + mu[k,j]*P[j]
    for count in range(i+2,dim):
        S[count] = 0
    for j in range(k,i,-1):
        T = mu[k,j-1]/D[j]
        for l in range(dim-1,k,-1):
            S[l] += mu[l,j]* P[j]
            mu[l,j] = mu[l,j-1] - T*S[l]
        for l in range(k,j,-1):
            S[l] += mu[l-1,j]* P[j]
            mu[l,j] = mu[l-1,j-1] - T*S[l]
    T = 1/D[i]
    for l in range(dim-1,k,-1):
        mu[l,i] = T*(S[l]+mu[l,i]*P[i])
    for l in range(k,i+1,-1):
        mu[l,i] = T*(S[l]+mu[l-1,i]*P[i])
    mu[i+1,i] = T*P[i]
    for j in range(i):
        e = mu[k,j]
        for l in range(k,i,-1):
            mu[l,j] = mu[l-1,j]
        mu[i,j] = e
    for j in range(k,i,-1):
        VN[j] = D[j]*VN[j-1]/D[j-1]
    VN[i] = D[i]
    return VN,mu

def deepLLL(V,delta):
    VV,mu = myGSO(V)
    VN = vector(QQ,dim)
    for i in range(dim):
        VN[i] = VV[i].norm()^2
    k = 1
    while k <= dim-1:
        for j in range(k-1,-1,-1):
            V,mu = sizereduce(V,mu,k,j)
        C = V[k].norm()^2
        i = 0
        while i < k:
            if C >= delta*VN[i]:
                C -= (mu[k,i]^2)*VN[i]
                i += 1
            else:
                tmp = V[k]
                for j in range(k,i,-1):
                    V[j] = V[j-1]
                V[i] = tmp
                VN,mu = GSOupdate_deep(mu,VN,i,k)
                k = max(i,1) - 1
        k += 1
    return V

#M = Matrix([[9,2,7],[8,6,1],[3,2,6]])
#M = Matrix([[-2,7,7,-5],[3,-2,6,-1],[2,-8,-9,-7],[8,-9,6,-4]])
M = Matrix([[84,3,34,17],[20,48,66,19],[69,14,63,78],[28,72,36,57]])
#M = Matrix([[19,2,32,46,3,33],[15,42,11,0,3,24],[43,15,0,24,4,16],[20,44,44,0,18,15],[0,48,35,16,31,31],[48,33,32,9,1,29]])
MMM = deepLLL(M,0.75)
print("mydeepLLL(M) = ",MMM)
print("LLL(M) = ",M.LLL())