module EvoLP

using Distributions, Random, Statistics
import LinearAlgebra: normalize
import StatsBase: ordinalrank

export rand_pop_binary, rand_pop_normal, rand_pop_uniform,
       rand_particle_uniform, rand_particle_normal,
       # algorithms
       GA, oneplusone, Particle, PSO,
       # selection
       SelectionMethod, TournamentSelection, TruncationSelection,
       RouletteWheelSelection, RankBasedSelection,
       select,
       # mutation
       MutationMethod, BitwiseMutation, GaussianMutation,
       mutate,
       # crossover
       CrossoverMethod, SinglePointCrossover, TwoPointCrossover,
       UniformCrossover, InterpolationCrossover,
       cross,
       # benchmark functions
       onemax, leadingones, rosenbrock, michalewicz,
       # stats
       meanFit, bestFit, computeStat!


include("benchmarks.jl")
include("crossover.jl")
include("generators.jl")
include("mutation.jl")
include("selection.jl")
include("stats.jl")

include("algorithms/ga.jl")
include("algorithms/ea.jl")
include("algorithms/swarm.jl")

end
