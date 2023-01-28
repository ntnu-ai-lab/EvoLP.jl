"Swarm-based algorithms"


"""
A single particle in the swarm, with a position `x`,
a velocity `v` and the best position it has encountered `x_best`.
"""
mutable struct Particle
    x
    v
    x_best
end

"""
    PSO(f::Function, population, k_max; w=1, c1=1, c2=1)
    PSO(logger::Logbook, f::Function, population, k_max; w=1, c1=1, c2=1)

## Arguments
- `f::Function`: Objective function to minimise
- `population`: Population—a list of `Particle` individuals
- `k_max`: maximum iterations
- `w`: Inertia weight. Optional, by default 1.
- `c1`: Cognitive coefficient (my position). Optional, by default 1
- `c2`: Social coefficient (swarm position). Optional, by default 1

Returns a 2-tuple of the form `(best, pop)` of the best individual and the population.
"""
function PSO(f::Function, population, k_max; w=1, c1=1, c2=1)
    n = length(population[1].x)
    x_best, y_best = copy(population[1].x_best), Inf

    # evaluation loop
    for P in population
        y = f(P.x)  # O(pop)

        if y < y_best
            x_best[:] = P.x
            y_best = y
        end
    end

    for _ in 1:k_max
        for P in population
            r1, r2 = rand(n), rand(n)
            P.x += P.v
            P.v = w*P.v + c1*r1 .* (P.x_best - P.x) + c2*r2 .* (x_best - P.x)
            y = f(P.x)  # O(k_max * pop)

            if y < y_best
                x_best[:] = P.x
                y_best = y
            end

            if y < f(P.x_best)  # O(k_max * pop)
                P.x_best[:] = P.x
            end
        end
    end


    best_i = argmin([f(P.x_best) for P in population])
    best = population[best_i]
    n_evals = 2 * length(population) + 2 * k_max  * length(population) + 1

    result = Result(best, f(best.x_best), population, k_max, n_evals)
    return result
end

function PSO(logger::Logbook, f::Function, population, k_max; w=1, c1=1, c2=1)
    n = length(population[1].x)
    x_best, y_best = copy(population[1].x_best), Inf

    # evaluation loop
    for P in population
        y = f(P.x)  # O(pop)

        if y < y_best
            x_best[:] = P.x
            y_best = y
        end
    end

    for _ in 1:k_max
        for P in population
            r1, r2 = rand(n), rand(n)
            P.x += P.v
            P.v = w*P.v + c1*r1 .* (P.x_best - P.x) + c2*r2 .* (x_best - P.x)
            y = f(P.x)  # O(k_max * pop)

            if y < y_best
                x_best[:] = P.x
                y_best = y
            end

            if y < f(P.x_best)  # O(k_max * pop)
                P.x_best[:] = P.x
            end
        end
        compute!(logger, [f(P.x) for P in population])  # O(k_max * pop)
    end

    best_i = argmin([f(P.x_best) for P in population]) # O(pop)
    best = population[best_i]
    n_evals = 2 * length(population) + 3 * k_max  * length(population) + 1

    result = Result(best, f(best.x_best), population, k_max, n_evals)
    return result
end
