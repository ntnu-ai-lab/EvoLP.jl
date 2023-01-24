"""
    GA(f::Function, pop, k_max, S, C, M)
    GA(logbook::Logbook, f::Function, pop, k_max, S, C, M)

Generational Genetic Algorithm.

## Arguments
- `f`: Objective function to minimise
- `pop`: Population—a list of individuals.
- `k_max`: maximum iterations
- `S::SelectionMethod`: a selection method. See selection.
- `C::CrossoverMethod`: a crossover method. See crossover.
- `M::MutationMethod`: a mutation method. See mutation.

Returns a 2-tuple of the form `(best, pop)` of the best individual and the population.
"""
function GA(f::Function, pop, k_max, S, C, M)
	for _ in 1:k_max
		parents = select(S, f.(pop))
		offspring = [cross(C, pop[p[1]], pop[p[2]]) for p in parents]
		pop .= mutate.(Ref(M), offspring)  # whole population is replaced
	end

	best = pop[argmin(f.(pop))]
	return best, pop
end


function GA(logbook::Logbook, f::Function, pop, k_max, S, C, M)
	for k in 1:k_max
		parents = select(S, f.(pop))
		offspring = [cross(C, pop[p[1]], pop[p[2]]) for p in parents]
		pop .= mutate.(Ref(M), offspring) # whole population is replaced

        fitnesses = f.(pop)

        compute!(logbook, fitnesses)
	end

    best = pop[argmin(f.(pop))]
	return best, pop
end
