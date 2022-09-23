module EvoLP

using Distributions, Random
import LinearAlgebra:normalize

export rand_pop_binary, rand_pop_normal, rand_pop_uniform
       # algorithms
       GA, oneplusone,
       # selection
       SelectionMethod, TournamentSelection, TruncationSelection,
       RouletteWheelSelection,
       select,
       # mutation
       MutationMethod, BitwiseMutation, GaussianMutation,
       # crossover
       CrossoverMethod, SinglePointCrossover, TwoPointCrossover,
       InterpolationCrossover, InterpolationCrossover,
       cross,
       # benchmark functions
       onemax, leading_ones, rosenbrock,
       # stats
       meanFit, bestFit, computeStat!


include("benchmarks.jl")
include("crossover.jl")
include("generators.jl")
include("mutation.jl")
include("selection.jl")
include("stats.jl")

include("algorithms/ga.jl")
include("algorithms/oneplusone.jl")

end
