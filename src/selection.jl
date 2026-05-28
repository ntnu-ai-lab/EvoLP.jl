# Abstract supertype for selectors
# ==========================

"""
Abstract Selector for either Parent or Deme selection methods.
"""
abstract type Selector end


# Parent selection operators
# ==========================
# All parent selectors perform a single operation, as in a steady-state GA.
# Each selector returns a list of two indices.
# An array of fitnesses `y` is passed as a parameter and is used to obtain a pair of
# parents' indices (to be sliced from the population later in your algorithms)

"""
Abstract Parent Selector
"""
abstract type ParentSelector <: Selector end


"""
Tournament parent selection with tournament size `T`.
"""
struct TournamentSelector <: ParentSelector
    T::Int
end

"""
    select(t::TournamentSelector, y)

Select `N` parents which are the winners from `N` random tournaments of size `t.T`.
"""
function select(t::TournamentSelector, y, N::Int = 2; rng = Random.GLOBAL_RNG)
    getparent() = begin
        p = randperm(rng, length(y))
        p[argmin(y[p[1:t.T]])]
    end

    return [getparent() for _ in 1:N]
end


"""
Truncation selection for selecting top `k` possible parents in the population.
"""
struct TruncationSelector <: ParentSelector
    k
end

"""
    select(t::TruncationSelector, y, N::Int = 2; rng = Random.GLOBAL_RNG)

Select `N` random parent indices out from the top `t.k` in the population.
"""
function select(t::TruncationSelector, y, N::Int = 2; rng = Random.GLOBAL_RNG)
    top_k_indices = _select_top_k(y, t.k)
    return rand(rng, top_k_indices, N)
end


"""
Roulette wheel parent selection.
"""
struct RouletteWheelSelector <: ParentSelector end

"""
    select(::RouletteWheelSelector, y, N::Int = 2; rng = Random.GLOBAL_RNG)

Select `N` random parent indices with probability proportional to their fitness.
"""
function select(::RouletteWheelSelector, y, N::Int = 2; rng = Random.GLOBAL_RNG)
    y = maximum(y) .- y
    cat = Categorical(normalize(y, 1))
    return rand(rng, cat, N)
end


"""
Rank-based parent selection.
"""
struct RankBasedSelector <: ParentSelector end

"""
	select(::RankBasedSelector, y, N::Int = 2; rng = Random.GLOBAL_RNG)

Select `N` random parent indices with probability proportional to their ranks.
"""
function select(::RankBasedSelector, y, N::Int = 2; rng = Random.GLOBAL_RNG)
    ranks = ordinalrank(y, rev = true)
    cat = Categorical(normalize(ranks, 1))
    return rand(rng, cat, N)
end


"""
Uniform parent selection for ES and EAs.
"""
struct UniformSelector <: ParentSelector end

"""
    select(::UniformSelector, y, N::Int = 2; rng = Random.GLOBAL_RNG)

Select `N` parent indices uniformly at random with replacement.
Useful for (μ, λ)-ES and EAs.
"""
function select(::UniformSelector, y, N::Int = 2; rng = Random.GLOBAL_RNG)
    return rand(rng, 1:length(y), N)
end


# Survival Selectors
# ==============
# Survival selectors are meant for selecting the entire population for the next generation.
# These selectors get the relevant fitnesses and return a set of indices to be sliced
# from the population in your algorithms.
# These selectors are deterministic.

"""
Abstract Survival Selector
"""
abstract type SurvivalSelector <: Selector end


"""
    CommaSelector(μ::Int)

``(\\mu, \\lambda)`` survival selection.
Selects the indices of the best `μ` individuals exclusively from the offspring population.
"""
struct CommaSelector <: SurvivalSelector
    μ::Int
end

"""
    select(S::CommaSelector, y_λ)

Return the indices of the best `μ` offspring.
"""
function select(S::CommaSelector, y_λ)
    # Comma selection chooses μ from λ fitnesses
    return _select_top_k(y_λ, S.μ)
end


"""
    PlusSelector(μ::Int)

``(\\mu + \\lambda)`` survival selection.
Selects the indices of the best `μ` individuals from the combined pool of parents and offspring.
"""
struct PlusSelector <: SurvivalSelector
    μ::Int
end

"""
    select(S::PlusSelector, y_μ, y_λ)

Return the indices of the best `μ` individuals from both parents and offspring.
"""
function select(S::PlusSelector, y_μ, y_λ)
    # Plus selection chooses μ from both μ + λ fitnesses
    y = vcat(y_μ, y_λ)
    return _select_top_k(y, S.μ)
end


# Deme Selectors
# ==============
# For use in island models, where a deme is a subset of the population.
# Empty selector types. The interfaces are defined in the `EvoLPIslands.jl` extension.

"""
Abstract Deme Selector
"""
abstract type DemeSelector <: EvoLP.Selector end

"""
Deme selector for obtaining a random sample of size `k`
"""
struct RandomDemeSelector <: DemeSelector
    k::Integer
end

"""
Deme selector for obtaining the worst `k` individuals
"""
struct WorstDemeSelector <: DemeSelector
    k::Integer
end


# Helpers
# ==============

function _select_top_k(y::AbstractArray{<:Real}, k::Int)
    if k > length(y)
        throw(ArgumentError("Cannot select $k individuals from a pool of $(length(y))."))
    end
    return partialsortperm(y, 1:k)
end
