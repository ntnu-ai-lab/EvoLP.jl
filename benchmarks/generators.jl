using EvoLP
using BenchmarkTools
using StableRNGs

myrng = StableRNG(123)

@btime binary_vector_pop(50, 10, rng=myrng)
@btime permutation_vector_pop(30, 8, 1:8; replacement=false, rng=myrng)
@btime normal_rand_vector_pop(3000, [0, 0], [1 0; 0 1], rng=myrng)
@btime unif_rand_vector_pop(3000, [0, 0], [1, 1], rng=myrng)
@btime normal_rand_particle_pop(3000, [0, 0], [1 0; 0 1], rng=myrng)
@btime unif_rand_particle_pop(3000, [0, 0], [1, 1], rng=myrng)
