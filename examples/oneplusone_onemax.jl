using Random, EvoLP

firstborn = rand_pop_binary(10,1)[1]
@show firstborn
k = 50
M = BitwiseMutation(1/10)
myf(x) = -onemax(x)
c = oneplusone(myf, firstborn, k, M)
@show c