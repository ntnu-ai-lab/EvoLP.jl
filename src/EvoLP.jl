module EvoLP

import LinearAlgebra: norm, normalize
import NamedTupleTools: namedtuple
import OrderedCollections: LittleDict
import StatsBase: ordinalrank, sample

using Distributions
using Random
using Statistics

# Generators
export rand_pop_binary  # Binary
export rand_pop_normal, rand_pop_uniform  # Continuous
export rand_pop_int_perm  # Permutation
export rand_particle_normal, rand_particle_uniform  # Particles
# Algorithms
export GA
export oneplusone
export Particle, PSO
# Selection
export SelectionMethod  # Do we need this?
export RankBasedSelectionGenerational, RouletteWheelSelectionGenerational
export TournamentSelectionGenerational, TruncationSelectionGenerational
export RankBasedSelectionSteady, RouletteWheelSelectionSteady
export TournamentSelectionSteady, TruncationSelectionSteady
export select
# Mutation
export MutationMethod  # Do we need this?
export BitwiseMutation  # Binary
export GaussianMutation  # Continuous
export InsertMutation, InversionMutation, ScrambleMutation, SwapMutation  # Permutation
export mutate
# Crossover
export CrossoverMethod  # Do we need this?
export SinglePointCrossover, TwoPointCrossover, UniformCrossover, InterpolationCrossover
export OrderOneCrossover
export cross
# Benchmark functions
export onemax, leadingones, jumpk  # Pseudoboolean
export ackley, booth, circle, flower, michalewicz, rosenbrock  # Continuous
# Results
export Result
export optimum, optimizer, iterations, f_calls, population
# Logbook
export Logbook
export compute!


include("benchmarks.jl")
include("crossover.jl")
include("generators.jl")
include("logbook.jl")
include("mutation.jl")
include("result.jl")
include("selection.jl")

include("algorithms/ga.jl")
include("algorithms/ea.jl")
include("algorithms/swarm.jl")

end
