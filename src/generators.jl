"""
Population generators.
"""

# Vector-based populations

## Discrete domains
"""
    binary_vector_pop(n, l; rng=Random.GLOBAL_RNG)

Generate a population of `n` vector binary individuals, each of length `l`.

# Examples

```julia
julia> using EvoLP

julia> binary_vector_pop(2, 5)
2-element Vector{BitVector}:
 [1, 0, 1, 1, 0]
 [0, 1, 0, 0, 0]
```
"""
function binary_vector_pop(n, l; rng=Random.GLOBAL_RNG)
	return [bitrand(rng, l) for _ in 1:n]
end

"""
    permutation_vector_pop(n, d, pool; replacement=false, rng=Random.GLOBAL_RNG)

Generate a population of `n` permutation vector individuals, of size `d`
and with values sampled from `pool`. Usually `d` would be equal to `length(pool)`.

Sampling is **without replacement** by default (generating permutations if `pool` is a set).
When `replacement=true` then it generates combinations of (possibly) repeated values.

# Examples

```julia
julia> permutation_vector_pop(1, 8, 1:8)
1-element Vector{Vector{Int64}}:
 [7, 3, 8, 1, 5, 6, 4, 2]

julia> permutation_vector_pop(2, 5, ["a", "b", "c", "d", "e"]; replacement=false)
2-element Vector{Vector{String}}:
 ["e", "b", "c", "d", "a"]
 ["b", "d", "a", "e", "c"]
```
"""
function permutation_vector_pop(n, d, pool; replacement=false, rng=Random.GLOBAL_RNG)
    thepop = [sample(rng, pool, d, replace=replacement, ordered=false) for i in 1:n]
    return thepop
end

## Continuous domains
"""
    unif_rand_vector_pop(n, lb, ub; rng=Random.GLOBAL_RNG)

Generate a population of `n` vector individuals using a uniformly random distribution
between lower bounds `lb` and upper bounds `ub`.

Both `lb` and `ub` must be arrays of the same dimensions.

# Examples

```julia
julia> unif_rand_vector_pop(3, [-1, -1], [1, 1])
3-element Vector{Vector{Float64}}:
 [-0.16338687344459046, 0.31576097298524064]
 [-0.941510876597899, 0.8219576462978224]
 [-0.377090051761797, -0.28434454028992096]
```
"""
function unif_rand_vector_pop(n, lb, ub; rng=Random.GLOBAL_RNG)
	d = length(lb)
	return [lb + rand(rng, d) .* (ub - lb) for _ in 1:n]
end

"""
    normal_rand_vector_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)

Generate a population of `n` vector individuals using a normal distribution with means `μ`
and covariance `Σ`.

`μ` expects a vector of length _l_ (i.e. length of an individual) while `Σ` expects an
_l x l_ matrix of covariances.

# Examples

```julia
julia> normal_rand_vector_pop(3, [0, 0], [1 0; 0 1])
3-element Vector{Vector{Float64}}:
 [-0.15290525182234904, 0.8715880371871617]
 [-1.1283800329864322, -0.9256584563613383]
 [-0.5384758126777555, -0.8141702145510666]
```
"""
function normal_rand_vector_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)
	D = MvNormal(μ, Σ)
	return [rand(rng, D) for _ in 1:n]
end

# Particles
# Normally only for continuous domains

"""
A single particle in the swarm, with a position `x`, a velocity `v` and the best position
it has encountered `x_best`.
"""
mutable struct Particle
    x
    v
    x_best
end

"""
    unif_rand_particle_pop(n, lb, ub; rng=Random.GLOBAL_RNG)

Generate a population of `n` [`Particle`](@ref) individuals using a uniformly random
distribution between lower bounds `lb` and upper bounds `ub`.

Both `lb` and `ub` must be arrays of the same dimensions.

# Examples

```julia
julia> unif_rand_particle_pop(3, [-1, -1], [1, 1])
3-element Vector{Any}:
 Particle([0.012771979849810489, 1.5375945897550218], [0, 0], [0.012771979849810489, 1.5375945897550218])
 Particle([1.4615231729898166, 0.7340438556735969], [0, 0], [1.4615231729898166, 0.7340438556735969])
 Particle([0.26586910036555356, 0.22012991705951324], [0, 0], [0.26586910036555356, 0.22012991705951324])
```
"""
function unif_rand_particle_pop(n, lb, ub; rng=Random.GLOBAL_RNG)
	d = length(lb)
	pop = []

	for i in 1:n
		x_pos = rand(rng, d) .* (ub - lb)
		push!(pop, Particle(x_pos, fill(0, d), x_pos))
	end

	return pop
end

"""
    normal_rand_particle_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)

Generate a population of `n` [`Particle`](@ref) using a normal distribution with means `μ
and covariance `Σ`.

`μ` expects a vector of length _l_ (i.e. number of dimensions) while `Σ` expects an _l x l_
matrix of covariances.

# Examples

```julia
julia> normal_rand_particle_pop(3, [-1, -1], [1 0; 0 1])
3-element Vector{Any}:
 Particle([-2.3026589618390214, 0.25907687184121864], [0.0, 0.0], [-2.3026589618390214, 0.25907687184121864])
 Particle([-0.5118786279984703, -0.5948648935657292], [0.0, 0.0], [-0.5118786279984703, -0.5948648935657292])
 Particle([-1.3230210847731094, -1.6234307114658497], [0.0, 0.0], [-1.3230210847731094, -1.6234307114658497])
```
"""
function normal_rand_particle_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)
	D = MvNormal(μ, Σ)
	pop = []

	for i in 1:n
		x_pos = rand(rng, D)
		push!(pop, Particle(x_pos, zeros(size(μ)), x_pos))
	end

	return pop
end
