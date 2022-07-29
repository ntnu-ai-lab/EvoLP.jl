using Random
using StableRNGs
using StatsBase

include("../generators.jl")
include("../benchmarks.jl")
#stepsize
F = 0.4 # [0.4, 0.9]
c = 0.1 # [0.1, 1]
rng = StableRNG(123)
pop = rand_pop_uniform(100, [-2, -2], [2, 2])
k_max = 100
N = length(pop)
n = length(pop[1])
trial = empty(pop)

f(x) = rosenbrock(x)

for k in k_max
    for i = 1:N
        pool = deleteat!(Vector(1:N), i)
        r = sample(rng, pool, 3, replace = false)
        mutant = pop[r[1]] + F * (pop[r[2]] - pop[r[3]])
        Ir = rand(rng, 1:n, 1)
        push!(trial, copy(pop[i]))

        for j in 1:n
            if (rand(rng) < c || j == Ir)
                trial[i][j] = mutant[j]
            end
        end       
    end
    popfit = f.(pop)
    trialfit = f.(trial)
    
    for i in 1:N
        if trialfit[i] < popfit[i]
            pop[i] = trial[i]
        end
    end
end

@show pop[argmin(f.(pop))]