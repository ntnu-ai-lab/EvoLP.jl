using EvoLP

# population = rand_particle_uniform(50, [0, 0], [5, 5])
population = rand_particle_normal(50, [0, 0], [1 0; 0 1])

best, final_pop = PSO(michalewicz, population, 200)
@show best
@show final_pop[1:3]