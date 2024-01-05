# Mutation methods
# ================
# Mutators operate on a single individual and return a copy. No individual
# is being modified. Some mutator composite types have parameters that
# dictate how mutation is carried out.
# Control the probability of performing a mutation directly in your algorithms.

"""
Abstract Mutation Method.
"""
abstract type Mutator end

"""
Abstract Mutator for real-valued individuals.
"""
abstract type ContinuousMutator <: Mutator end

"""
Abstract Mutator for binary individuals.
"""
abstract type BinaryMutator <: Mutator end

"""
Abstract Mutator for permutation individuals.
"""
abstract type PermutationMutator <: Mutator end


# For binary individuals
"""
Bitwise mutation with probability `λ` of flipping each bit.
"""
struct BitwiseMutator <: BinaryMutator
    λ
end

"""
    mutate(M::BitwiseMutator, ind)

Randomly flips each bit with a probability `λ`.
"""
@inline function mutate(M::BitwiseMutator, ind; rng=Random.GLOBAL_RNG)
    return [rand(rng) < M.λ ? !v : v for v in ind]
end

# For continuous individuals
"""
Gaussian mutation with standard deviation `σ`, which should be a real number.
"""
struct GaussianMutator <: ContinuousMutator
    σ
end

"""
    mutate(M::GaussianMutator, ind)

Randomly add Gaussian noise to the `ind` candidate solution, with a standard
deviation of `σ`.
"""
@inline function mutate(M::GaussianMutator, ind; rng=Random.GLOBAL_RNG)
    return @fastmath ind + randn(rng, length(ind)) * M.σ
end

# For permutation individuals
"""
Swap mutation for permutation-based individuals.
"""
struct SwapMutator <: PermutationMutator end

"""
    mutate(::SwapMutator, ind)

Randomly swap the position of two alleles in the `ind` candidate solution.
"""
function mutate(::SwapMutator, ind; rng=Random.GLOBAL_RNG)
    indices = sample(rng, 1:length(ind), 2, replace=false)
    aux = ind[indices[1]]
    c = deepcopy(ind)
    c[indices[1]], c[indices[2]] = c[indices[2]], aux
    return c
end

"""
Insert mutation for permutation-based individuals.
"""
struct InsertionMutator <: PermutationMutator end

"""
    mutate(::InsertionMutator, ind)

Randomly choose two positions `a` and `b` from `ind`,
insert at `a`+1 the element at position `b``, and shift the rest of the elements.
"""
function mutate(::InsertionMutator, ind; rng=Random.GLOBAL_RNG)
    indices = sample(rng, 1:length(ind), 2, replace=false, ordered=true)
    removed = splice!(ind, indices[2])
    insert!(ind, indices[1] + 1, removed)
    return ind
end

"""
Scramble mutation for permutation-based individuals.
"""
struct ScrambleMutator <: PermutationMutator end


"""
    mutate(::ScrambleMutator, ind)

Randomly scramble the subsequence between two random points in `ind`.
"""
function mutate(::ScrambleMutator, ind; rng=Random.GLOBAL_RNG)
    indices = sample(rng, 1:length(ind), 2, replace=false, ordered=true)
    c = deepcopy(ind)
    shift = c[indices[1]:indices[2]]
    shuffle!(rng, shift)
    c[indices[1]:indices[2]] = shift
    return c
end

"""
Inversion mutation for permutation-based individuals.
"""
struct InversionMutator <: PermutationMutator end

"""
    mutate(::InversionMutator, ind)

Invert the subsequence between two random points in `ind`.
"""
function mutate(::InversionMutator, ind; rng=Random.GLOBAL_RNG)
    indices = sample(rng, 1:length(ind), 2, replace=false, ordered=true)
    c = deepcopy(ind)
    shift = c[indices[1]:indices[2]]
    c[indices[1]:indices[2]] = shift[end:-1:1]

    return c
end
