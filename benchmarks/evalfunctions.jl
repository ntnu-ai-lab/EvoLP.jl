using EvoLP
using BenchmarkTools
using StableRNGs

myrng = StableRNG(123)

a = fill(rand, 10000)

@btime wheeler(a)
