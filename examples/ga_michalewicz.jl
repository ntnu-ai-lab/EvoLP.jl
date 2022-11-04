using Statistics, EvoLP
import OrderedCollections: LittleDict

function main()
    m = 500
    k_max = 100
    population = rand_pop_normal(m, [0, 0], [1 0; 0 1])
    S = RankBasedSelection()
    C = SinglePointCrossover()
    M = GaussianMutation(0.5)

    statnames = ["mean_eval", "max_f", "min_f", "median_f"]
    fns = [mean, maximum, minimum, median]
    thedict = LittleDict(statnames, fns)
    thelogger = Logbook(thedict)

    best, thepop = GA(thelogger, michalewicz, population, k_max, S, C, M)

    @show best
    @show thepop[1:5]
    @show thelogger.records[end]

    return nothing
end

main()
