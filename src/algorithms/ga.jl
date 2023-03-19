"""
    GA(f, pop, k_max, S, C, M)
    GA(logbook::Logbook, f, pop, k_max, S, C, M)

Generational Genetic Algorithm.

## Arguments
- `f::Function`: objective function to **minimise**.
- `pop::AbstractVector`: population—a list of vector individuals.
- `k_max::Integer`: number of iterations.
- `S::SelectionMethod`: one of the available [`SelectionMethod`](@ref).
- `C::CrossoverMethod`: one of the available [`CrossoverMethod`](@ref).
- `M::MutationMethod`: one of the available [`MutationMethod`](@ref).

Returns a [`Result`](@ref).
"""
function GA(
    f::Function,
    pop::AbstractVector,
    k_max::Integer,
    S::SelectionMethod,
    C::CrossoverMethod,
    M::MutationMethod
)
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


function GA(
    logbook::Logbook,
    f::Function,
    pop::AbstractVector,
    k_max::Integer,
    S::SelectionMethod,
    C::CrossoverMethod,
    M::MutationMethod
)
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
