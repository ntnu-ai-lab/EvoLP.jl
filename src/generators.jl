using Distributions
using Random

"""
Population generators.
"""

"""
    rand_pop_uniform(n, lb, ub)

Generates a population of `n` individuals using
a uniformly random distribution between lower bounds `lb`
and upper bounds `ub`.

Both `lb` and `ub` should be arrays of the same dimensions.
"""
function rand_pop_uniform(n, lb, ub)
	d = length(lb)
	return [lb + rand(d) .* (ub - lb) for i in 1:n]
end

"""
    function rand_pop_normal(n, μ, Σ)

Generates a population of `n` individuals using a
normal distribution with means `μ` and covariance `Σ`.

`μ` expects a vector of length _l_ (i.e. length of an individual)
while `Σ` expects an _l x l_ matrix of covariances
"""
function rand_pop_normal(n, μ, Σ)
	D = MvNormal(μ, Σ)
	return [rand(D) for i in 1:n]
end

"""
    rand_pop_binary(l, n)

Generates a population of `n` binary individuals, each of length `l`.
"""
rand_pop_binary(l, n) = [bitrand(l) for _ in 1:n]
