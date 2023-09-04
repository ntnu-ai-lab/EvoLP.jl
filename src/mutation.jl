"""
Abstract MutationMethod.
"""
abstract type MutationMethod end

"""
Mutation methods here operate on a single individual.
A `MutationMethod` type has a probability associated with it
that dictates how mutation is carried out. All operators return
a copy. No individual is being modified.
"""

# For binary individuals
"""
Bitwise mutation with probability `λ` of flipping each bit.
"""
struct BitwiseMutation <: MutationMethod
    λ
end

"""
    mutate(M::BitwiseMutation, ind)

Randomly flips each bit with a probability `λ`.
"""
@inline mutate(M::BitwiseMutation, ind; rng=Random.GLOBAL_RNG) = [rand(rng) < M.λ ? !v : v for v in ind]

# For continuous individuals
"""
Gaussian mutation with standard deviation `σ`, which should be a real number.
"""
struct GaussianMutation <: MutationMethod
    σ
end

"""
    mutate(M::GaussianMutation, ind)

Randomly add Gaussian noise to the `ind` candidate solution, with a standard
deviation of `σ`.
"""
@inline mutate(M::GaussianMutation, ind; rng=Random.GLOBAL_RNG) = @fastmath ind + randn(rng, length(ind)) * M.σ

# For permutation individuals
"""
Swap mutation for permutation-based individuals.
"""
struct SwapMutation <: MutationMethod end

"""
    mutate(::SwapMutation, ind)

Randomly swap the position of two alleles in the `ind` candidate solution.
"""
function mutate(::SwapMutation, ind; rng=Random.GLOBAL_RNG)
    indices = sample(rng, 1:length(ind), 2, replace=false)
    aux = ind[indices[1]]
    c = deepcopy(ind)
    c[indices[1]], c[indices[2]] = c[indices[2]], aux
    return c
end

"""
Insert mutation for permutation-based individuals.
"""
struct InsertMutation <: MutationMethod end

"""
    mutate(::InsertMutation, ind)

Randomly choose two positions `a` and `b` from `ind`,
insert at `a`+1 the element at position `b``, and shift the rest of the elements.
"""
function mutate(::InsertMutation, ind; rng=Random.GLOBAL_RNG)
    indices = sample(rng, 1:length(ind), 2, replace=false, ordered=true)
    removed = splice!(ind, indices[2])
    insert!(ind, indices[1] + 1, removed)
    return ind
end

"""
Scramble mutation for permutation-based individuals.
"""
struct ScrambleMutation <: MutationMethod end


"""
    mutate(::ScrambleMutation, ind)

Randomly scramble the subsequence between two random points in `ind`.
"""
function mutate(::ScrambleMutation, ind; rng=Random.GLOBAL_RNG)
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
struct InversionMutation <: MutationMethod end

"""
    mutate(::InversionMutation, ind)

Invert the subsequence between two random points in `ind`.
"""
function mutate(::InversionMutation, ind; rng=Random.GLOBAL_RNG)
    indices = sample(rng, 1:length(ind), 2, replace=false, ordered=true)
    c = deepcopy(ind)
    shift = c[indices[1]:indices[2]]
    c[indices[1]:indices[2]] = shift[end:-1:1]

    return c
end
