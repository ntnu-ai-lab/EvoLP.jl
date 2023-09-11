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
@inline binary_vector_pop(n, l; rng=Random.GLOBAL_RNG) = [bitrand(rng, l) for _ in 1:n]

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
    return [sample(rng, pool, d, replace=replacement, ordered=false) for _ in 1:n]
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
@inline function unif_rand_vector_pop(n, lb, ub; rng=Random.GLOBAL_RNG)
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
@inline function normal_rand_vector_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)
    D = MvNormal(μ, Σ)
    return [rand(rng, D) for _ in 1:n]
end

# Particles
# Normally only for continuous domains

"""
A single particle in the swarm, with a position `x`, a velocity `v`, the best position it
has encountered `x_best` and its evaluations `y` and `y_best`
"""
mutable struct Particle
    # TODO: Add datatypes?
    x
    v
    y
    x_best
    y_best
end

"""
    unif_rand_particle_pop(n, lb, ub; rng=Random.GLOBAL_RNG)

Generate a population of `n` [`Particle`](@ref) individuals using a uniformly random
distribution between lower bounds `lb` and upper bounds `ub`.

Both `lb` and `ub` must be arrays of the same dimensions.

# Examples

```julia
julia> unif_rand_particle_pop(3, [-1, -1], [1, 1])
3-element Vector{Particle}:
 Particle([1.0823301388655755, 0.1544036055233653], [0, 0], Inf, [1.0823301388655755, 0.1544036055233653], Inf)
 Particle([1.0718059584439532, 1.5793257162200343], [0, 0], Inf, [1.0718059584439532, 1.5793257162200343], Inf)
 Particle([1.732268523018161, 0.32172551959160556], [0, 0], Inf, [1.732268523018161, 0.32172551959160556], Inf)
```
"""
function unif_rand_particle_pop(n, lb, ub; rng=Random.GLOBAL_RNG)
    d = length(lb)
    population = Vector{Particle}(undef, n)
    y = Inf

    # TODO: Use another macro for inbounds repeat
    for i in 1:n
        x_pos = rand(rng, d) .* (ub - lb)
        @inbounds population[i] = Particle(x_pos, fill(0, d), y, x_pos, y)
    end

    return population
end

"""
    normal_rand_particle_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)

Generate a population of `n` [`Particle`](@ref) using a normal distribution with means `μ``
and covariance `Σ`.

`μ` expects a vector of length _l_ (i.e. number of dimensions) while `Σ` expects an _l x l_
matrix of covariances.

# Examples

```julia
julia> normal_rand_particle_pop(3, [0, 0], [1 0; 0 1])
3-element Vector{Particle}:
 Particle([-0.6025996585348097, -1.0055548956861133], [0.0, 0.0], Inf, [-0.6025996585348097, -1.0055548956861133], Inf)
 Particle([-0.7562454555135321, 1.9490439959687778], [0.0, 0.0], Inf, [-0.7562454555135321, 1.9490439959687778], Inf)
 Particle([0.5687241357408321, -0.7406267072113427], [0.0, 0.0], Inf, [0.5687241357408321, -0.7406267072113427], Inf)
```
"""
function normal_rand_particle_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)
    # TODO: Add y as optional parameter but default to Inf?
    D = MvNormal(μ, Σ)
    y = Inf
    pop = Vector{Particle}(undef, n)

    for i in 1:n
        x_pos = rand(rng, D)
        @inbounds pop[i] = Particle(x_pos, zeros(size(μ)), y, x_pos, y)
    end

    return pop
end
