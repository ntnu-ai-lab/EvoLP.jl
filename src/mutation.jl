"""
Abstract MutationMethod.
"""
abstract type MutationMethod end

"""
Bitwise mutation with probability `λ`.
"""
struct BitwiseMutation <: MutationMethod
    λ
end

"""
Gaussian mutation with standard deviation `σ`.
"""
struct GaussianMutation <: MutationMethod
    σ
end

"""
Mutation methods here operate on a single individual.
A `MutationMethod` type has a probability associated with it
that dictates how mutation is carried out. All operators return
a copy. No individual is being modified.
"""

"""
    mutate(M::BitwiseMutation, ind)

Randomly flips each bit with a probability `λ`.
"""
function mutate(M::BitwiseMutation, ind; rng=Random.GLOBAL_RNG)
	return [rand(rng) < M.λ ? !v : v for v in ind]
end

"""
    mutate(M::GaussianMutation, ind)

Randomly add Gaussian noise to the `ind` candidate solution,
with a standard deviation of `σ`.
"""
function mutate(M::GaussianMutation, ind; rng=Random.GLOBAL_RNG)
	return ind + randn(rng, length(ind)) * M.σ
end
