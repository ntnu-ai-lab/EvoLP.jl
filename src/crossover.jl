"""
Abstract CrossoverMethod.
"""
abstract type CrossoverMethod end

"""
Single point crossover.
"""
struct SinglePointCrossover <: CrossoverMethod end

"""
Two point crossover.
"""
struct TwoPointCrossover <: CrossoverMethod end

"""
Uniform crossover.
"""
struct UniformCrossover <: CrossoverMethod end

"""
Interpolation crossover with scaling parameter `λ`.
"""
struct InterpolationCrossover <: CrossoverMethod
    λ
end

"""
Crossover methods operate on two parents `a` and `b` to generate
a new candidate solution. Some of the `CrossoverMethod`s have
parameters to control how the reproduction is performed. All
operators return a new individual. No individual is modified.
"""

"""
    cross(::SinglePointCrossover, a, b)

Single point crossover between parents `a` and `b`, at a
random point in the chromosome.
"""
function cross(::SinglePointCrossover, a, b; rng = Random.GLOBAL_RNG)
	i = rand(rng, 1:length(a))
	return vcat(a[1:i], b[i+1:end])
end

"""
    cross(::TwoPointCrossover, a, b)

Two point crossover between parents `a` and `b`, at two
random points in the chromosome.
"""
function cross(::TwoPointCrossover, a, b; rng = Random.GLOBAL_RNG)
	n = length(a)
	i, j = rand(1:n, 2)
	if i > j
		(i, j) = (j, i)
	end
	return vcat(a[1:i], b[i+1:j], a[j+1:n])
end

"""
    crossover(::UniformCrossover, a, b)

Uniform crossover between parents `a` and `b`. Each gene
of the chromosome is randomly selected from one of the parents.
"""
function cross(::UniformCrossover, a, b; rng = Random.GLOBAL_RNG)
	child = copy(a)
	for i in 1:length(a)
		if rand() < 0.5
			child[i] = b[i]
		end
	end
	return child
end

"""
	cross(C::InterpolationCrossover, a, b)

Linear Interpolation crossover between parents `a` and `b`.
The resulting individual is the addition of a scaled version of
each of the parents, using `C.λ` as a control parameter.
"""
cross(C::InterpolationCrossover, a, b) = (1 - C.λ)*a + C.λ*b
