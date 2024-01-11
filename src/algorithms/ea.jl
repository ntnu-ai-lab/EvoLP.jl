"""
    oneplusone(f, ind, k_max, M)
    oneplusone(logger::Logbook, f, ind, k_max, M)

1+1 Evolutionary Algorithm.

# Arguments

- `f::Function`: objective function to **minimise**.
- `ind::AbstractVector`: individual to start the evolution.
- `k_max::Integer`: number of iterations.
- `M::Mutator`: one of the available [`Mutator`](@ref).

Returns a [`Result`](@ref).
"""
function oneplusone(f::Function, ind::AbstractVector, k_max::Integer, M::Mutator)
    fx = Inf  # works only on minimisation problems
    runtime = @elapsed @inbounds for _ in 1:k_max
        c = mutate(M, ind)
        fx, fc = f(ind), f(c)
        if fc <= fx
            ind = c
            fx = fc
        end
    end

    n_evals = 2 * k_max

    return Result(fx, ind, [ind], k_max, n_evals, runtime)
end

# Logbook version
function oneplusone!(
    logger::Logbook, f::Function, ind::AbstractVector, k_max::Integer, M::Mutator
)
    fx = Inf  # works only on minimisation problems
    runtime = @elapsed @inbounds for _ in 1:k_max
        c = mutate(M, ind)
        fx, fc = f(ind), f(c)
        if fc <= fx  # O(2 * k_max)  # minimisation problem
            ind = c
            fx = fc
        end

        compute!(logger, [fx])
    end

    n_evals = 2 * k_max

    return Result(fx, ind, [ind], k_max, n_evals, runtime)
end
