using Statistics, EvoLP

function main()
    m = 500
    k_max = 100
    population = rand_pop_normal(m, [0, 0], [1 0; 0 1])
    S = RankBasedSelection()
    C = SinglePointCrossover()
    M = GaussianMutation(0.5)
    result = GA(michalewicz, population, k_max, S, C, M)
    @show result
end

main()