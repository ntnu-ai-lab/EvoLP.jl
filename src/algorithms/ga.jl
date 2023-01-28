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
    n = length(pop)
	for _ in 1:k_max
		parents = select(S, f.(pop)) # O(k_max * n)
		offspring = [cross(C, pop[p[1]], pop[p[2]]) for p in parents]
		pop .= mutate.(Ref(M), offspring)  # whole population is replaced
	end

    # x, fx
	best, best_i = findmin(f, pop) # O(n)
    n_evals = k_max * n + n
    result = Result(best, pop[best_i], pop, k_max, n_evals)
	return result
end


function GA(logbook::Logbook, f::Function, pop, k_max, S, C, M)
    n = length(pop)
	for _ in 1:k_max
		parents = select(S, f.(pop)) # O(k_max * n)
		offspring = [cross(C, pop[p[1]], pop[p[2]]) for p in parents]
		pop .= mutate.(Ref(M), offspring) # whole population is replaced

        fitnesses = f.(pop) # O(k_max * n)

        compute!(logbook, fitnesses)
	end

    # x, fx
	best, best_i = findmin(f, pop) # O(n)
	n_evals = 2 * k_max * n + n
    result = Result(best, pop[best_i], pop, k_max, n_evals)
	return result
end
