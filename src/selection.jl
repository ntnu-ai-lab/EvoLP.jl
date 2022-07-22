using Random
import LinearAlgebra:normalize

"""
Selection methods here are based on fitness. An array of
fitnesses `y` is passed as a parameter and is used to
obtain a pair of parents' indices (to be sliced from the
population later). All methods return a list of lists,
each with two indices for every fitness passed.
"""

abstract type SelectionMethod end
	
struct TruncationSelection <: SelectionMethod
    k
end

struct TournamentSelection <: SelectionMethod
    k
end

struct RouletteWheelSelection <: SelectionMethod end

"""
    select(t::TruncationSelection, y)

Selects two random parents (from the top `k`) in the population
for each fitness in `y`.
"""
function select(t::TruncationSelection, y; rng = Random.GLOBAL_RNG)
	p = sortperm(y)
	return [p[rand(rng, 1:t.k, 2)] for _ in y]
end

"""
    select(t::TournamentSelection, y)

Selects two random parents from a tournament of size `k` for each
fitness in `y`.
"""
function select(t::TournamentSelection, y; rng = Random.GLOBAL_RNG)
	getparent() = begin
		p = randperm(rng, length(y))
		p[argmin(y[p[1:t.k]])]
	end
	return [[getparent(), getparent()] for _ in y]
end

"""
    select(::RouletteWheelSelection, y)

Selects two random parents with proportional probability, for each
fitness in `y`
"""
function select(::RouletteWheelSelection, y; rng = Random.GLOBAL_RNG)
	y = maximum(y) .- y
	cat = Categorical(normalize(y, 1))
	return [rand(rng, cat, 2) for _ in y]
end
