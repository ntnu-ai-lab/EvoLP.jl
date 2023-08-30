"""
Abstract CrossoverMethod.
"""
abstract type CrossoverMethod end

"""
Crossover methods operate on two parents `a` and `b` to generate
a new candidate solution. Some of the `CrossoverMethod`s have
parameters to control how the reproduction is performed. All
operators return a new individual. No individual is modified in the process.
"""

# For numerical vector individuals
"""
Single point crossover.
"""
struct SinglePointCrossover <: CrossoverMethod end

"""
    cross(::SinglePointCrossover, a, b)

Single point crossover between parents `a` and `b`, at a
random point in the chromosome.
"""
function cross(::SinglePointCrossover, a, b; rng=Random.GLOBAL_RNG)
    i = rand(rng, 1:length(a))
    return vcat(a[1:i], b[i+1:end])
end

"""
Two point crossover.
"""
struct TwoPointCrossover <: CrossoverMethod end

"""
    cross(::TwoPointCrossover, a, b)

Two point crossover between parents `a` and `b`, at two
random points in the chromosome.
"""
function cross(::TwoPointCrossover, a, b; rng=Random.GLOBAL_RNG)
    i, j = rand(rng, 1:length(a), 2)

    if i > j
        i, j = j, i
    end

    return vcat(a[1:i], b[i+1:j], a[j+1:end])
end

"""
Uniform crossover.
"""
struct UniformCrossover <: CrossoverMethod end

"""
    crossover(::UniformCrossover, a, b)

Uniform crossover between parents `a` and `b`. Each gene
of the chromosome is randomly selected from one of the parents.
"""
function cross(::UniformCrossover, a, b; rng=Random.GLOBAL_RNG)
    child = copy(a)

    @inbounds for i in 1:length(a)
        if rand(rng) < 0.5
            child[i] = b[i]
        end
    end

    # TODO: Test against  sped up version

    return child
end

"""
Interpolation crossover with scaling parameter `λ`.
"""
struct InterpolationCrossover <: CrossoverMethod
    λ
end

"""
	cross(C::InterpolationCrossover, a, b)

Linear Interpolation crossover between parents `a` and `b`.
The resulting individual is the addition of a scaled version of
each of the parents, using `C.λ` as a control parameter.
"""
@inline cross(C::InterpolationCrossover, a, b) = (1 - C.λ) * a + C.λ * b

# For permutation vector individuals

"""
Order 1 crossover (OX1) for permutation-based individuals.
"""
struct OrderOneCrossover <: CrossoverMethod end

"""
    cross(::OrderOneCrossover, a, b)

Order 1 crossover between permutation parents `a` and `b`.
A substring from `a` is copied directly to the offspring, and the
remaining values are copied in the order they appear in `b`.
"""
function cross(::OrderOneCrossover, a, b; rng=Random.GLOBAL_RNG)
    indices = sample(rng, 2:length(a)-1, 2, replace=false, ordered=true)
    # Selected part from `a`
    chosen = a[indices[1]:indices[2]]
    # Values not copied from `a`
    rem_vals = vcat(a[begin:indices[1]-1], a[indices[2]+1:end])

    # Using the same order as in `b`, copy those values in rem_vals
    r = [v for v in vcat(b[indices[2]+1:end], b[begin:indices[2]]) if v in rem_vals]

    # Break down into slices
    s2 = r[begin:length(a)-indices[2]]
    s1 = r[length(s2)+1:end]

    # Returned individual is a concatenation of the slices and selected part from `a`
    return vcat(s1, chosen, s2)
end
