"""
    SA(f, pop, k_max, S, C, M; T_init)

Simulated annealing.

## Arguments
- `f::Function`: objective function to **minimise**.
- `population::AbstractVector`: a list of vector individuals.
- `k_max::Integer`: number of iterations.
- `S::ParentSelector`: one of the available [`ParentSelector`](@ref).
- `C::CrossoverMethod`: one of the available [`CrossoverMethod`](@ref).
- `M::MutationMethod`: one of the available [`MutationMethod`](@ref).
- `T₀::Real=100.0`: initial temperature
- `α::Real=0.99`: cooling rate

Returns a [`Result`](@ref).
"""
function SA(
    f::Function,
    population::AbstractVector,
    k_max::Integer,
    S::ParentSelector,
    C::Recombinator,
    M::Mutator;
    T₀::Real=100.0,
    α::Real=0.99
)
    fx = Inf
    best_ind = copy(population)  # Initialize the best individual
    T = T₀ # Initialize the temperature

    runtime = @elapsed begin
        for _ in 1:k_max
            c = mutate(M, population)
            fc = f(c)
            ΔE = fc - fx  # Calculate the difference in objective function values

            # Acceptance probability function
            if ΔE < 0 || rand() < exp(-ΔE / T)
                population = copy(c)
                fx = fc
            end

            fx < f(best_ind) && (best_ind = copy(population))

            T *= α
        end
    end

    n_evals = k_max

    return Result(fx, best_ind, [best_ind], k_max, n_evals, runtime)
end

