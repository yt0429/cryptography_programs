###
#メッセージdを伝える時、良い基底を知っているSamanthaは、dに近い格子点をBabai's algorithm で構成できる。そのため、Samanthaが書いたことが証明できる。
#Eveがなりすまそうとしても、悪い基底ではdに近い格子点を構成できず、検証に失敗する。
###
dim = 3
def Babai_algorithm(d,V):
    X = V.solve_left(d)
    for i in range (dim):
        X[i] = round(X[i]) 
    v = X*V
    return v

d = vector([678846,651685,160467])
V =matrix([[-97,19,19],[-36,30,86],[-184,-64,78]])
U = matrix([[4327,-15447,23454],[3297,-11770,17871],[5464,-19506,29617]])
W = U*V
s = Babai_algorithm(d,V)
X = W.solve_left(s)  # XW = s つまり X = sW^(-1)を計算して, s = a1w1 + a2w2 + a3w3 なる (a1,a2,a3)を求める
for i in range (dim):
    X[i] = round(X[i])
ss = Babai_algorithm(d,W)
print("Samantha decides to sign the document,")
print("document d = ",d)
print("She uses Babai's algorithm to find a vector s = ",s)
print("\nThat is close to d , ||s-d|| =", n((s-d).norm()))
print("Next she expresses s in terms of the bad basis, and publishes (a1, a2, a3) = ",X)
print("This is her signature for the document d.")
print("\nVictor verifies the signature by using the public basis to compute")
print("s = a1w1 + a2w2 + a3w3 = ",X*W)
print("This is a vector in L , and ||s-d|| is very small.")
print("\nBy the way, Eve attempts to sign d using Babai's algorithm with the bad basis W, she signature that she obtains is ")
print("ss = ",ss)
print("||ss-d|| = ", n((ss-d).norm()))
print("So Victor can verify that d is not written by Eve.")