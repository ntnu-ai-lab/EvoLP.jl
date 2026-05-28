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
include("utils.jl")

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
export GA, GA!
export oneplusone, oneplusone!
export PSO, PSO!

# Selection
#-- Parent
export RankBasedSelector
export RouletteWheelSelector
export TournamentSelector
export TruncationSelector
export UniformSelector
#-- Survival
export CommaSelector
export PlusSelector
export select

# Mutation
export BitwiseMutator  # Binary
export GaussianMutator  # Continous
export InsertionMutator, InversionMutator, ScrambleMutator, SwapMutator  # Permutation
export mutate

# Crossover
export SinglePointRecombinator, TwoPointRecombinator, UniformRecombinator  # Numeric
export InterpolationRecombinator  # Continuous
export OX1Recombinator  # Permutation
export cross

# Optimisation test functions
export zeromax, onemax, twomax  # Pseudo-Boolean simple
export leadingones, trailingzeros  # Pseudo-Boolean linked
export jumpk, triangle, peakedLO  # Pseudo-Boolean complex
export booth, branin, rosenbrock, wheeler  # Continuous unimodal
export ackley, eggholder, michalewicz, rana # Continuous multimodal

# Results
export Result
export optimum, optimizer, iterations, f_calls, population, runtime

# Logbook
export Logbook
export compute!
export summarise

# Utilities
export force_boolean
export global_entropy
export ind2dec, ind2str
export dec2ind, str2ind
export get_neighbourhood, get_neighbourhood_ixs

# |=== EvoLPIslands extension ===|
# Island types
# export DemeSelector
export RandomDemeSelector
export WorstDemeSelector

# Migration operators
function drift end
function strand end
function reinsert! end

export drift
export strand
export reinsert!

# Island GA
function islandGA! end
export islandGA!

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
