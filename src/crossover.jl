# Crossover methods
# =================
# Crossover methods (or recombinators) operate on two parents `a` and `b` to generate
# a new candidate solution. Some of the recombinators have parameters to control how
# reproduction is performed. All operators return a single, new individual and
# no individual is modified in the process.
#
# To obtain another individual during crossover, use the `cross` method swapping arguments:
# `cross(S, a, b)` for one offspring, and `cross(S, b, a)` for the other.

"""
Abstract recombinator.
"""
abstract type Recombinator end

"""
Abstract numeric recombinator.
"""
abstract type NumericRecombinator <: Recombinator end

"""
Abstract permutation recombinator.
"""
abstract type PermutationRecombinator <: Recombinator end

"""
Abstract continuous recombinator.
"""
abstract type ContinuousRecombinator <: NumericRecombinator end

# For numeric vector individuals
"""
Single point crossover.
"""
struct SinglePointRecombinator <: NumericRecombinator end

"""
    cross(::SinglePointRecombinator, a, b)

Single point crossover between parents `a` and `b`, at a
random point in the chromosome.
"""
function cross(::SinglePointRecombinator, a, b; rng=Random.GLOBAL_RNG)
    i = rand(rng, eachindex(a))
    return vcat(a[begin:i], b[i+1:end])
end

"""
Two point crossover.
"""
struct TwoPointRecombinator <: NumericRecombinator end

"""
    cross(::TwoPointRecombinator, a, b)

Two point crossover between parents `a` and `b`, at two
random points in the chromosome.
"""
function cross(::TwoPointRecombinator, a, b; rng=Random.GLOBAL_RNG)
    i, j = rand(rng, eachindex(a), 2)

    if i > j
        i, j = j, i
    end

    return vcat(a[begin:i], b[i+1:j], a[j+1:end])
end

"""
Uniform crossover.
"""
struct UniformRecombinator <: NumericRecombinator end

"""
    crossover(::UniformRecombinator, a, b)

Uniform crossover between parents `a` and `b`. Each gene
of the chromosome is randomly selected from one of the parents.
"""
function cross(::UniformRecombinator, a, b; rng=Random.GLOBAL_RNG)
    child = similar(a)

    for i in eachindex(a)
        @inbounds child[i] = rand(rng) < 0.5 ? b[i] : a[i]
    end

    return child
end

"""
Interpolation crossover with scaling parameter `λ`.
"""
struct InterpolationRecombinator <: ContinuousRecombinator
    λ
end

"""
	cross(C::InterpolationRecombinator, a, b)

Linear Interpolation crossover between parents `a` and `b`.
The resulting individual is the addition of a scaled version of
each of the parents, using `C.λ` as a control parameter.
"""
@inline cross(C::InterpolationRecombinator, a, b) = @fastmath (1 - C.λ) * a + C.λ * b

# For permutation vector individuals

"""
Order 1 crossover (OX1) for permutation-based individuals.
"""
struct OX1Recombinator <: PermutationRecombinator end

"""
    cross(::OX1Recombinator, a, b)

Order 1 crossover between permutation parents `a` and `b`.
A substring from `a` is copied directly to the offspring, and the
remaining values are copied in the order they appear in `b`.
"""
function cross(::OX1Recombinator, a, b; rng=Random.GLOBAL_RNG)
    # NOTE: Slow
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
