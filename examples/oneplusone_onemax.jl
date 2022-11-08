using Random, EvoLP, Statistics
using OrderedCollections

firstborn = rand_pop_binary(10,1)[1]
@show firstborn
k = 50
M = BitwiseMutation(1/10)
myf(x) = -onemax(x)

statnames = ["fx"]
fns = [identity]
thedict = LittleDict(statnames, fns)
logbook = Logbook(thedict)
c = oneplusone(logbook, myf, firstborn, k, M)
@show c
@show logbook.records[end]
