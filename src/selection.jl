# Parent selection operators
# ==========================
# All selectors perform a single operation, as in a steady-state GA.
# Each selector returns a list of two indices.
# An array of fitnesses `y` is passed as a parameter and is used to obtain a pair of
# parents' indices (to be sliced from the population later in your algorithms)

"""
Abstract Selector for either Parent or Deme selection methods.
"""
abstract type Selector end

"""
Abstract Parent Selector
"""
abstract type ParentSelector <: Selector end

"""
Tournament parent selection with tournament size `T`.
"""
struct TournamentSelector <: ParentSelector
    T
end

"""
    select(t::TournamentSelector, y)

Select two parents which are the winners from two random tournaments of size `t.T`.
"""
function select(t::TournamentSelector, y; rng=Random.GLOBAL_RNG)
    getparent() = begin
        p = randperm(rng, length(y))
        p[argmin(y[p[1:t.T]])]
    end

    return [getparent(), getparent()]
end

"""
Truncation selection for selecting top `k` possible parents in the population.
"""
struct TruncationSelector <: ParentSelector
    k
end

"""
    select(t::TruncationSelector, y)

Select two random parents out from the top `t.k` in the population.
"""
function select(t::TruncationSelector, y; rng=Random.GLOBAL_RNG)
    p = sortperm(y)
    return p[rand(rng, 1:t.k, 2)]
end

"""
Roulette wheel parent selection.
"""
struct RouletteWheelSelector <: ParentSelector end

"""
    select(::RouletteWheelSelector, y)

Select two random parents with probability proportional to their fitness.
"""
function select(::RouletteWheelSelector, y; rng=Random.GLOBAL_RNG)
    y = maximum(y) .- y
    cat = Categorical(normalize(y, 1))
    return rand(rng, cat, 2)
end

"""
Rank-based parent selection.
"""
struct RankBasedSelector <: ParentSelector end

"""
	select(::RankBasedSelector, y)

Select two random parents with probability proportional to their ranks.
"""
function select(::RankBasedSelector, y; rng=Random.GLOBAL_RNG)
    ranks = ordinalrank(y, rev=true)
    cat = Categorical(normalize(ranks, 1))
    return rand(rng, cat, 2)
end
