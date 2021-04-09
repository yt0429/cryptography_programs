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

M = matrix([[66586820,65354729],[6513996,6393464]])
MM = Gaussian(M)
print(MM)