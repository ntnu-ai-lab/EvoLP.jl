# Parent selection operators
# ==========================

"""
Abstract SelectionMethod.
"""
abstract type SelectionMethod end

"""
Truncation selection for selecting top `k` possible parents in the population.
"""
struct TruncationSelectionSteady <: SelectionMethod
    k
end
"""
Truncation selection for selecting top `k` possible parents in the population.
"""
struct TruncationSelectionGenerational <: SelectionMethod
    k
end

"""
Tournament parent selection with tournament size `k`.
"""
struct TournamentSelectionSteady <: SelectionMethod
    k
end
"""
Tournament parent selection with tournament size `k`.
"""
struct TournamentSelectionGenerational <: SelectionMethod
    k
end

"""
Roulette wheel parent selection.
"""
struct RouletteWheelSelectionSteady <: SelectionMethod end
"""
Roulette wheel parent selection.
"""
struct RouletteWheelSelectionGenerational <: SelectionMethod end

"""
Rank-based parent selection.
"""
struct RankBasedSelectionSteady <: SelectionMethod end
"""
Rank-based parent selection.
"""
struct RankBasedSelectionGenerational <: SelectionMethod end

# For steady-state GAs
# ====================

# Steady-state parent selection methods return a list of two indices.
# An array of fitnesses `y` is passed as a parameter and is used to obtain a pair of
# parents' indices (to be sliced from the population later in your algorithms)

"""
    select(t::TruncationSelectionSteady, y)

Select two random parents out from the top `t.k` in the population.
"""
function select(t::TruncationSelectionSteady, y; rng=Random.GLOBAL_RNG)
	p = sortperm(y)
	return p[rand(rng, 1:t.k, 2)]
end

"""
    select(t::TournamentSelectionSteady, y)

Select two parents which are the winners from two random tournaments of size `t.k`.
"""
function select(t::TournamentSelectionSteady, y; rng=Random.GLOBAL_RNG)
	getparent() = begin
		p = randperm(rng, length(y))
		p[argmin(y[p[1:t.k]])]
	end

	return [getparent(), getparent()]
end

"""
    select(::RouletteWheelSelectionSteady, y)

Select two random parents with probability proportional to their fitness.
"""
function select(::RouletteWheelSelectionSteady, y; rng=Random.GLOBAL_RNG)
	y = maximum(y) .- y
	cat = Categorical(normalize(y, 1))
	return rand(rng, cat, 2)
end

"""
	select(::RankBasedSelectionSteady, y)

Select two random parents with probability proportional to their ranks.
"""
function select(::RankBasedSelectionSteady, y; rng=Random.GLOBAL_RNG)
	ranks = ordinalrank(y, rev = true)
	cat = Categorical(normalize(ranks, 1))
	return rand(rng, cat, 2)
end

# For generational GAs
# ====================

# Generational parent selection methods are convenient variations on the steady operators.
# An array of fitnesses `y` is passed and used to obtain a pair of parents' indices
# (to be sliced from the population later in your algorithms) for all fitnesses in `y`.
# This means that methods instead return a list of lists, each sublist with two indices.

"""
    select(t::TruncationSelectionGenerational, y)

Select two random parents (from the top `t.k`) in the population for each fitness in `y`.
"""
function select(t::TruncationSelectionGenerational, y; rng=Random.GLOBAL_RNG)
	p = sortperm(y)
	return [p[rand(rng, 1:t.k, 2)] for _ in y]
end

"""
    select(t::TournamentSelectionGenerational, y)

Select two parents which are the winners from two random tournaments of size `t.k` for each
fitness in `y`.
"""
function select(t::TournamentSelectionGenerational, y; rng=Random.GLOBAL_RNG)
	getparent() = begin
		p = randperm(rng, length(y))
		p[argmin(y[p[1:t.k]])]
	end

	return [[getparent(), getparent()] for _ in y]
end

"""
    select(::RouletteWheelSelectionGenerational, y)

Select two random parents with probability proportional to their fitness, for each fitness
in `y`.
"""
function select(::RouletteWheelSelectionGenerational, y; rng=Random.GLOBAL_RNG)
	y = maximum(y) .- y
	cat = Categorical(normalize(y, 1))
	return [rand(rng, cat, 2) for _ in y]
end

"""
	select(::RankBasedSelectionGenerational, y)

Select two random parents with probability proportional to their ranks, for each fitness
in `y`.
"""
function select(::RankBasedSelectionGenerational, y; rng=Random.GLOBAL_RNG)
	ranks = ordinalrank(y, rev = true)
	cat = Categorical(normalize(ranks, 1))
	return [rand(rng, cat, 2) for _ in y]
end
