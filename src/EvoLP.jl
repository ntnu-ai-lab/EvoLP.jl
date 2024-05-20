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
include("algorithms/sa.jl")
include("algorithms/swarm.jl")

include("deprecated.jl")

# Random population generators
export binary_vector_pop  # Binary vectors
export normal_rand_vector_pop, unif_rand_vector_pop  # Continuous vectors
export permutation_vector_pop  # Permutation vectors
export Particle, normal_rand_particle_pop, unif_rand_particle_pop  # Particles

# Algorithms
export GA, GA!
export SA
export oneplusone, oneplusone!
export PSO, PSO!

# Selection
export RankBasedSelector
export RouletteWheelSelector
export TournamentSelector
export TruncationSelector
export select

# Mutation
export BitwiseMutator # Binary
export GaussianMutator # Continous
export InsertionMutator, InversionMutator, ScrambleMutator, SwapMutator
export mutate

# Crossover
export SinglePointRecombinator, TwoPointRecombinator, UniformRecombinator  # Numeric
export InterpolationRecombinator  # Continuous
export OX1Recombinator  # Permutation
export cross

# Optimisation test functions
export onemax, leadingones, jumpk  # Pseudoboolean
export booth, branin, rosenbrock, wheeler  # Continuous unimodal
export ackley, eggholder, michalewicz, rana # Continuous multimodal

# Results
export Result
export optimum, optimizer, iterations, f_calls, population, runtime

# Logbook
export Logbook
export compute!
export summarise

# |=== Deprecated functionality ===|

# Test functions
export circle
export flower

# Selection methods
export RankBasedSelectionGenerational, RankBasedSelectionSteady
export RouletteWheelSelectionGenerational, RouletteWheelSelectionSteady
export TournamentSelectionGenerational, TournamentSelectionSteady
export TruncationSelectionGenerational, TruncationSelectionSteady

# Mutation methods
export BitwiseMutation
export GaussianMutation
export InsertMutation, InversionMutation, ScrambleMutation, SwapMutation

# Crossover methods
export SinglePointCrossover, TwoPointCrossover, UniformCrossover
export InterpolationCrossover
export OrderOneCrossover
end
