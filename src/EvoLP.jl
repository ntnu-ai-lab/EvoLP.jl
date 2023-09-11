module EvoLP

import LinearAlgebra: norm, normalize
import NamedTupleTools: namedtuple
import OrderedCollections: LittleDict
import StatsBase: ordinalrank, sample

using Distributions
using Random
using Statistics

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
export RankBasedSelectionGenerational, RouletteWheelSelectionGenerational
export TournamentSelectionGenerational, TruncationSelectionGenerational
export RankBasedSelectionSteady, RouletteWheelSelectionSteady
export TournamentSelectionSteady, TruncationSelectionSteady
export select

# Mutation
export BitwiseMutation  # Binary
export GaussianMutation  # Continuous
export InsertMutation, InversionMutation, ScrambleMutation, SwapMutation  # Permutation
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

# Deprecated functionality
# Will be removed in the future
export circle
export flower


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

end
