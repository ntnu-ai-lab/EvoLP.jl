"""
    GA(f, pop, k_max, S, C, M)

Generational Genetic Algorithm.

## Arguments
- `f`: Objective function to minimise
- `pop`: Population—a list of individuals.
- `k_max`: maximum iterations
- `S::SelectionMethod`: a selection method. See selection.
- `C::CrossoverMethod`: a crossover method. See crossover.
- `M::MutationMethod`: a mutation method. See mutation.
"""
function GA(f, pop, k_max, S, C, M)
	for _ in 1:k_max
		parents = select(S, f.(pop))
		offspring = [cross(C, pop[p[1]], pop[p[2]]) for p in parents]
		pop .= mutate.(Ref(M), offspring)  # whole population is replaced
	end
	best = pop[argmin(f.(pop))]
	return best, pop
end


function GA(stats::AbstractVector{EvoStat}, f, pop, k_max, S, C, M)
	for k in 1:k_max
		parents = select(S, f.(pop))
		offspring = [cross(C, pop[p[1]], pop[p[2]]) for p in parents]
		pop .= mutate.(Ref(M), offspring) # whole population is replaced
	end
	fitnesses = f.(pop)
	best = pop[argmin(fitnesses)]
	for m in stats
		computeStat!(m, fitnesses)
	end
	return best, pop, stats
end