def H(V): #Hadamard ratio (1に近いほど直交に近い "良い" 基底)
    under = 1
    for i in range (dim):
        under = under *  V[i].norm()
    Had = (abs(det(V)) / under)^(1/dim)
    return Had

#鍵生成
def NTRUkeycreation(f,g):
    fp = Rp(f); fq = Rq(f)
    Fp = Rp(1)/fp; Fq = Rq(1)/fq;
    h = Fq * Rq(g)
    return h

#暗号化
def NTRUencrypt(m,r,h):
    e = p * r * h + Rq(m)
    return e

#復号化
def NTRUdecrypt(e,f):
    fp = Rp(f)
    Fp = Rp(1)/fp
    a = Rq(f) * e
    ac = a.lift().map_coefficients(lambda c: c.lift_centered(), ZZ) #centerlift Rq -> R
    ap = Rp(ac)
    b = Fp * ap
    #mm = b.lift().map_coefficients(lambda c: c.lift_centered(), ZZ) #centerlift Rp -> R
    return b

def MhNTRU(h,q,N):
    Mh = Matrix(ZZ,2*N)
    for i in range(N):
        Mh[i,i] = 1
        Mh[i+N,i+N] = q
        for j in range(N,2*N):
            Mh[i,j] = h[(j-i)%N]
    return Mh
#Main
N = 7; p = 3; q = 41; d = 2 ; dim = 2*N
R = PolynomialRing(ZZ,x).quotient_ring(x^N - 1)
Rp = PolynomialRing(IntegerModRing(p),x).quotient_ring(x^N - 1)
Rq = PolynomialRing(IntegerModRing(q),x).quotient_ring(x^N - 1)
f =  (x^6 - x^4 + x^3 + x^2 - 1); g = (x^6 + x^4 - x^2 - x)
mx = -x^5 + x^3 + x^2 - x + 1
rx = x^6 - x^5 + x - 1
r = Rq(rx)

h = NTRUkeycreation(f,g)
t = lift(h)
M = MhNTRU(t,q,N)
ML = M.LLL()
e = NTRUencrypt(mx,r,h)
b = NTRUdecrypt(e,f)
print("Let's start the NTRU Public Key Cryptosystem.\n")
print("Public parameter (N,p,q,d) = ({0},{1},{2},{3})".format(N,p,q,d))
print("Alice chooses private key f in T(d+1,d) and g in T(d,d). f = {0},\ng = {1}".format(f,g))
print("And computes the inverse of f in Rq and Rp.")
print("Finally, she publishes the public key h = Fq * g \n h = ",lift(h))
print("\nNext, Bob chooses plaintext m in Rp and random r in T(d,d). \nm = ",mx)
print("r = ",rx)
print("He uses Alice's public key h to compute e = pr * h + m(mod q), \ne = ",lift(e))
print("And sends it to Alice.\n")
print("Alice computes f * e = pg * r + f * m(mod q)")
print("And center-lifts to a in R and compute b = Fp * a(mod p )")
print("b =",lift(b))
print("m =",mx)
mm = b.lift().map_coefficients(lambda c: c.lift_centered(), ZZ)
print("in Rp, b = m.")
print("(centerlift of b is )",mm)
print("M_h^NTRU = \n",M)
print("LLL to this. LLL(M) = \n",ML)
print("H(M) = ",n(H(M)))
print("H(LLL(M)) = ",n(H(ML)))