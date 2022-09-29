using Statistics, EvoLP

function main()
    m = 500
    k_max = 100
    population = rand_pop_normal(m, [0, 0], [1 0; 0 1])
    S = RankBasedSelection()
    C = SinglePointCrossover()
    M = GaussianMutation(0.5)
    s1 = meanFit()
    s2 = bestFit()
    measures = [s1, s2]
    best, pop, mystats = GA(measures, rosenbrock, population, k_max, S, C, M)
    @show best
    @show mystats
end

main()