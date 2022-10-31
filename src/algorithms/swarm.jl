"Swarm-based algorithms"


"""
A single particle in the swarm, with a position `x`,
a velocity `v` and the best position it's been `x_best`
"""
mutable struct Particle
    x
    v
    x_best
end

"""
    PSO(f, population, k_max; w = 1, c1 = 1, c2 = 1)

## Arguments
- `f`: Objective function to minimise
- `population`: Population—a list of `Particle` individuals.
- `k_max`: maximum iterations
- `w`: Inertia weight. Optional, by default 1.
- `c1`: Cognitive coefficient (my position). Optional, by default 1
- `c2`: Social coefficient (swarm position). Optional, by default 1.
"""
function PSO(f, population, k_max; w=1, c1=1, c2=1)
    n = length(population[1].x)
    x_best, y_best = copy(population[1].x_best), Inf

    # evaluation loop
    for P in population
        y = f(P.x)

        if y < y_best
            x_best[:] = P.x
            y_best = y
        end
    end

    for k in 1:k_max
        for P in population
            r1, r2 = rand(n), rand(n)
            P.x += P.v
            P.v = w*P.v + c1*r1 .* (P.x_best - P.x) + c2*r2 .* (x_best - P.x)
            y = f(P.x)

            if y < y_best
                x_best[:] = P.x
                y_best = y
            end

            if y < f(P.x_best)
                P.x_best[:] = P.x
            end
        end
    end

    best = population[argmin([f(P.x) for P in population])]
    return best, population
end
