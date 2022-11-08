using EvoLP, Statistics
using OrderedCollections

# population = rand_particle_uniform(50, [0, 0], [5, 5])
population = rand_particle_normal(50, [0, 0], [1 0; 0 1])

logbook = Logbook(LittleDict(["avg_fit", "median_fit"], [mean, median]))
best, final_pop = PSO(logbook, michalewicz, population, 200)
@show best
@show final_pop[1:3]
@show logbook.records[end]
