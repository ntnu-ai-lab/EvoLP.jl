abstract type MutationMethod end
	
struct BitwiseMutation <: MutationMethod
    λ
end

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
    mutate(M::BitwiseMutation, child)

Randomly flips each bit with a probability `λ`.
"""
function mutate(M::BitwiseMutation, child; rng = Random.GLOBAL_RNG)
	return [rand(rng) < M.λ ? !v : v for v in child]
end

"""
    mutate(M::GaussianMutation, child)

Randomly add Gaussian noise to the `child` candidate solution,
with a standard deviation of `σ`.
"""
function mutate(M::GaussianMutation, child; rng = Random.GLOBAL_RNG)
	return child + randn(rng, length(child)) * M.σ
end
