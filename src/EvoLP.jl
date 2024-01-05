module EvoLP

using LinearAlgebra: norm, normalize
using NamedTupleTools: namedtuple
using OrderedCollections: LittleDict
using StatsBase: ordinalrank, sample

using Distributions
using Random
using Statistics
using UnicodePlots

include("crossover.jl")
include("generators.jl")
include("logbook.jl")
include("mutation.jl")
include("result.jl")
include("selection.jl")
include("testfunctions.jl")

include("algorithms/ga.jl")
include("algorithms/ea.jl")
include("algorithms/swarm.jl")

include("deprecated.jl")

# Random population generators
export binary_vector_pop  # Binary vectors
export normal_rand_vector_pop, unif_rand_vector_pop  # Continuous vectors
export permutation_vector_pop  # Permutation vectors
export Particle, normal_rand_particle_pop, unif_rand_particle_pop  # Particles

# Algorithms
export GA
export oneplusone
export PSO

# Selection
export RankBasedSelector
export RouletteWheelSelector
export TournamentSelector
export TruncationSelector
export select

# Mutation
export BitwiseMutator # Binary
export GaussianMutator # Continous
export InsertMutator, InversionMutator, ScrambleMutator, SwapMutator

export mutate

# Crossover
export SinglePointCrossover, TwoPointCrossover, UniformCrossover, InterpolationCrossover
export OrderOneCrossover
export cross

# Optimisation test functions
export onemax, leadingones, jumpk  # Pseudoboolean
export ackley, booth, branin, michalewicz, rosenbrock, wheeler  # Continuous

# Results
export Result
export optimum, optimizer, iterations, f_calls, population, runtime

# Logbook
export Logbook
export compute!
export summarise

# |=== Deprecated functionality ===|
#
export circle
export flower

export RankBasedSelectionGenerational, RankBasedSelectionSteady
export RouletteWheelSelectionGenerational, RouletteWheelSelectionSteady
export TournamentSelectionGenerational, TournamentSelectionSteady
export TruncationSelectionGenerational, TruncationSelectionSteady

export BitwiseMutation
export GaussianMutation
export InsertMutation, InversionMutation, ScrambleMutation, SwapMutation

end
