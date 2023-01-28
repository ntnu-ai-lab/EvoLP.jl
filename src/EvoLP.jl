module EvoLP

using Distributions, Random, Statistics
import OrderedCollections: LittleDict
import LinearAlgebra: norm, normalize
import NamedTupleTools: namedtuple
import StatsBase: ordinalrank

# generators
export rand_pop_binary, rand_pop_normal, rand_pop_uniform
export rand_particle_uniform, rand_particle_normal
# algorithms
export GA
export oneplusone
export Particle, PSO
# selection
export SelectionMethod
export TournamentSelection, TruncationSelection, RouletteWheelSelection, RankBasedSelection
export select
# mutation
export MutationMethod
export BitwiseMutation, GaussianMutation
export mutate
# crossover
export CrossoverMethod
export SinglePointCrossover, TwoPointCrossover, UniformCrossover, InterpolationCrossover
export cross
# benchmark functions
export onemax, leadingones, jumpk
export ackley, booth, circle, flower, michalewicz, rosenbrock
# results
export Result, optimizer, optimum, iterations, f_calls, population
# logbook
export Logbook, compute!


include("benchmarks.jl")
include("crossover.jl")
include("generators.jl")
include("mutation.jl")
include("selection.jl")
include("result.jl")
include("logbook.jl")

include("algorithms/ga.jl")
include("algorithms/ea.jl")
include("algorithms/swarm.jl")

end
