include("../src/generators.jl")
include("../src/selection.jl")
include("../src/crossover.jl")
include("../src/mutation.jl")
include("../src/ga.jl")
include("../src/benchmarks.jl")

m = 500
k_max = 100
population = rand_pop_normal(m, [0, 0], [1 0; 0 1])
S = TournamentSelection(5)
C = SinglePointCrossover()
M = GaussianMutation(0.5)
x = GA(rosenbrock, population, k_max, S, C, M)
@show x
