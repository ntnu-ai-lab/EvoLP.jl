"""
    DE(f, pop, k_max, S, C, M)
    GA(logbook::Logbook, f, population, k_max, S, C, M)
    GA(notebooks::Vector{Logbook}, f, population, k_max, S, C, M)

Differential Evaluation Algorithm.

## Arguments
- `f::Function`: objective function to **minimise**.
- `population::AbstractVector`: a list of vector individuals.
- `k_max::Integer`: number of iterations.
- `S::SelectionMethod`: one of the available [`SelectionMethod`](@ref).
- `C::CrossoverMethod`: one of the available [`CrossoverMethod`](@ref).
- `M::MutationMethod`: one of the available [`MutationMethod`](@ref).

Returns a [`Result`](@ref).
"""

function DE(
    f::Function,
    population::AbstractVector,
    k_max::Integer,
    S::SelectionMethod,
    C::CrossoverMethod,
    M::MutationMethod
)
    n = length(population)

    fitnesses = Vector{Float32}(undef, n)

    runtime = @elapsed @inbounds for _ in 1:k_max
        fitnesses = f.(population)  # O(k_max * n)
        parents = select(S, fitnesses)
        offspring = [cross(C, population[p[1]], population[p[2]]) for p in parents]
        population .= mutate.(Ref(M), offspring)  # whole population is replaced
    end

    best_i = argmin(fitnesses)
    best = population[best_i]
    n_evals = k_max * n

    return Result(fitnesses[best_i], best, population, k_max, n_evals, runtime)
end

# Logbook version
function DE(
    logbook::Logbook,
    f::Function,
    population::AbstractVector,
    k_max::Integer,
    S::SelectionMethod,
    C::CrossoverMethod,
    M::MutationMethod
)
    n = length(population)

    fitnesses = Vector{Float32}(undef, n)

    runtime = @elapsed @inbounds for _ in 1:k_max
        fitnesses = f.(population)  # O(k_max * n)
        parents = select(S, fitnesses)
        offspring = [cross(C, population[p[1]], population[p[2]]) for p in parents]
        population .= mutate.(Ref(M), offspring)  # whole population is replaced

        compute!(logbook, fitnesses)
    end

    best_i = argmin(fitnesses)
    best = population[best_i]
    n_evals = k_max * n

    return Result(fitnesses[best_i], best, population, k_max, n_evals, runtime)
end

# 2-logbook version
function DE(
    notebooks::Vector{Logbook},
    f::Function,
    population::AbstractVector,
    k_max::Integer,
    S::SelectionMethod,
    C::CrossoverMethod,
    M::MutationMethod
)
    n = length(population)

    fitnesses = Vector{Float32}(undef, n)

    runtime = @elapsed @inbounds for _ in 1:k_max
        fitnesses = f.(population)  # O(k_max * n)
        parents = select(S, fitnesses)
        offspring = [cross(C, population[p[1]], population[p[2]]) for p in parents]
        population .= mutate.(Ref(M), offspring)  # whole population is replaced

        compute!(notebooks, [fitnesses, population])
    end

    best_i = argmin(fitnesses)
    best = population[best_i]
    n_evals = k_max * n

    return Result(fitnesses[best_i], best, population, k_max, n_evals, runtime)
end
