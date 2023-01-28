using EvoLP, Statistics
using OrderedCollections

population = rand_particle_normal(50, [0, 0], [1 0; 0 1])

logbook = Logbook(LittleDict(["avg_fit", "median_fit", "best_fit"], [mean, median, minimum]))
result = PSO(logbook, michalewicz, population, 100)
@show optimum(result)
@show optimizer(result)
@show iterations(result)
@show f_calls(result)

for (i, I) in enumerate(logbook.records)
    print("it: $(i) with best_pos: $(I[3]) and avg_pos: $(I[1]) \n")
end
