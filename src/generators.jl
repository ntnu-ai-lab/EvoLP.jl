"""
Population generators.
"""

# Vector-based populations

"""
    rand_pop_uniform(n, lb, ub)

Generate a population of `n` vector individuals using
a uniformly random distribution between lower bounds `lb`
and upper bounds `ub`.

Both `lb` and `ub` must be arrays of the same dimensions.
"""
function rand_pop_uniform(n, lb, ub; rng = Random.GLOBAL_RNG)
	d = length(lb)
	return [lb + rand(rng, d) .* (ub - lb) for _ in 1:n]
end

"""
    function rand_pop_normal(n, μ, Σ)

Generate a population of `n` vector individuals using a
normal distribution with means `μ` and covariance `Σ`.

`μ` expects a vector of length _l_ (i.e. length of an individual)
while `Σ` expects an _l x l_ matrix of covariances
"""
function rand_pop_normal(n, μ, Σ; rng = Random.GLOBAL_RNG)
	D = MvNormal(μ, Σ)
	return [rand(rng, D) for _ in 1:n]
end

"""
    rand_pop_binary(l, n)

Generate a population of `n` vector binary individuals, each of length `l`.
"""
function rand_pop_binary(l, n; rng = Random.GLOBAL_RNG)
	return [bitrand(rng, l) for _ in 1:n]
end

# Particles

"""
	rand_particle_uniform(n, lb, ub)

Generate a population of `n` Particle individuals using
a uniformly random distribution between lower bounds `lb`
and upper bounds `ub`.
	
Both `lb` and `ub` must be arrays of the same dimensions.

"""
function rand_particle_uniform(n, lb, ub; rng = Random.GLOBAL_RNG)
	d = length(lb)
	pop = []
	for i in 1:n
		x_pos = rand(rng, d) .* (ub - lb)
		push!(pop, Particle(x_pos, fill(0, d), x_pos))
	end
	return pop
end

"""
	rand_particle_normal(n, μ, Σ)

Generate a population of `n` particles using a
normal distribution with means `μ` and covariance `Σ`.

`μ` expects a vector of length _l_ (i.e. number of dimensions)
while `Σ` expects an _l x l_ matrix of covariances.
"""
function rand_particle_normal(n, μ, Σ; rng = Random.GLOBAL_RNG)
	D = MvNormal(μ, Σ)
	pop = []
	for i in 1:n
		x_pos = rand(rng, D)
		push!(pop, Particle(x_pos, zeros(size(μ)), x_pos))
	end
	return pop
end
