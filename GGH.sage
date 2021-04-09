#GGH algorhism
dim = 3 # 行列の次元

def H(V): #Hadamard ratio (1に近いほど直交に近い "良い" 基底)
    under = 1
    for i in range (dim):
        under = under *  V[i].norm()
    Had = (abs(det(V)) / under)^(1/dim)
    return Had

#公開鍵作成

def GGHcreate(V,U):
    W = U*V
    return W

#暗号化

def GGHencrypt(m,r,W):
    e = m*W+r
    return e

#復号化途中まで

def GGHdecrypt(e,V,W):
    X = V.solve_left(e)
    #Y = vector(ZZ,dim)
    for i in range (dim):
        X[i] = round(X[i]) 
    v = X*V
    # 本来以下を返り値にする
    # return v * W.inverse()
    return v

# Main 

V =matrix([[-97,19,19],[-36,30,86],[-184,-64,78]])
U = matrix([[4327,-15447,23454],[3297,-11770,17871],[5464,-19506,29617]])
m = vector([86,-35,-32]) #ここをいじる
#m = random_vector(ZZ,dim,x = -100, y = 100)
r = vector([-4,-3,2])
#r = random_vector(ZZ,dim,x = -15,y = 15 )
W = GGHcreate(V,U)
e = GGHencrypt(m,r,W)
WL = W.LLL()
v = GGHdecrypt(e,V,W)
vv = GGHdecrypt(e,WL,W)
# Eve's attack
print(n(H(W.LLL())))
e1 = e*W.inverse()
for i in range (dim):
    e1[i]= round(e1[i])
v1 = e1*W

e2 = e*WL.inverse()
for i in range(dim):
    e2[i] = round(e2[i])
v2 = e2 * WL
X = WL.solve_left(v2)
for i in range(dim):
    X[i] = round(X[i])

print("Let's start the GGH cryptosystem\nFirst, Alice take a good basis\nV = ",V)
print("V is good basis ,\n H(v1,v2,v3) = ",n(H(V)))
print("\nand an integer matrix(satisfying det(U) = +-1\nU=",U)
print("\nShe compute a bad basis W = UV. \n W = ",W)
print("W is bad basis , \nH(w1,w2,w3) = ",n(H(W)))
print("\nBob choose plaintext \n m = ",m)
print("and choose random small vector \n r = ",r)
print("Bob compute ciphertext e and send it to Alice. \n e = ",e)
print("Alice use Babai's algorithm to compute v in L closest to e. \n v = ",v)
print("At last , \n m = v*W^(-1) = ", v*W.inverse())
print("Eve try to attack")
print("the vector which is close to e\n v' = ",v1)
print("But \n m' = v'*W^(-1)= ",v1*W.inverse())
print("||e - v|| = ",n((e-v).norm()))
print("||e - v'|| = ",n((e-v1).norm()))
print("Eve use LLL algorithm to W")
print("LLL(W) = ",WL)
print("vector second = ",v2)
print("m = v2 * W^(-1) = ",v2*W.inverse())