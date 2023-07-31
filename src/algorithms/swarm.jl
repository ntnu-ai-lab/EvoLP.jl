"Swarm-based algorithms"

"""
    PSO(f, population, k_max; w=1, c1=1, c2=1)
    PSO(logger::Logbook, f, population, k_max; w=1, c1=1, c2=1)

## Arguments

- `f::Function`: Objective function to **minimise**.
- `population::Vector{Particle}`: a list of [`Particle`](@ref) individuals.
- `k_max::Integer`: number of iterations.

## Keywords

- `w`: inertia weight. Optional, by default 1.
- `c1`: cognitive coefficient (own's position). Optional, by default 1.
- `c2`: social coefficient (others' position). Optional, by default 1.

Returns a [`Result`](@ref).
"""
function PSO(
    f::Function, population::Vector{Particle}, k_max::Integer;
    w=1, c1=1, c2=1
)
    d = length(population[1].x)
    x_best, y_best = copy(population[1].x_best), Inf

    # evaluation loop
    for P in population
        P.y = f(P.x)  # O(pop)

        if P.y < y_best
            x_best[:] = P.x
            y_best = P.y
        end
    end

    for _ in 1:k_max
        for P in population
            r1, r2 = rand(d), rand(d)
            P.x += P.v
            P.v = w*P.v + c1*r1 .* (P.x_best - P.x) + c2*r2 .* (x_best - P.x)
            P.y = f(P.x)  # O(k_max * pop)

            if P.y < y_best
                x_best[:] = P.x
                y_best = P.y
            end

            if P.y < P.y_best
                P.x_best[:] = P.x
                P.y_best = P.y
            end
        end
    end

    best_i = argmin([P.y_best for P in population])
    best = population[best_i]
    n_evals = length(population) + k_max  * length(population)

    result = Result(best.y_best, best.x_best, population, k_max, n_evals)
    return result
end

# Logbook version
function PSO(
    logger::Logbook, f::Function, population::Vector{Particle}, k_max::Integer;
    w=1, c1=1, c2=1
)
    d = length(population[1].x)
    x_best, y_best = copy(population[1].x_best), Inf

    # evaluation loop
    for P in population
        P.y = f(P.x)  # O(pop)

        if P.y < y_best
            x_best[:] = P.x
            y_best = P.y
        end
    end

    for _ in 1:k_max
        for P in population
            r1, r2 = rand(d), rand(d)
            P.x += P.v
            P.v = w*P.v + c1*r1 .* (P.x_best - P.x) + c2*r2 .* (x_best - P.x)
            P.y = f(P.x)  # O(k_max * pop)

            if P.y < y_best
                x_best[:] = P.x
                y_best = P.y
            end

            if P.y < P.y_best
                P.x_best[:] = P.x
                P.y_best = P.y
            end
        end
        compute!(logger, [P.y for P in population])
    end

    best_i = argmin([P.y_best for P in population])
    best = population[best_i]
    n_evals = length(population) + k_max  * length(population)

    result = Result(best.y_best, best.x_best, population, k_max, n_evals)
    return result
end
