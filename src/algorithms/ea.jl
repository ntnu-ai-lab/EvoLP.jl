"""
    oneplusone(f, ind, k_max, M)
    oneplusone(logger::Logbook, f, ind, k_max, M)

1+1 Evolutionary Algorithm.

# Arguments

- `f::Function`: objective function to **minimise**.
- `ind::AbstractVector`: individual to start the evolution.
- `k_max::Integer`: number of iterations.
- `M::MutationMethod`: one of the available [`MutationMethod`](@ref).

Returns a [`Result`](@ref).
"""
function oneplusone(f::Function, ind::AbstractVector, k_max::Integer, M::MutationMethod)
	for _ in 1:k_max
        c = mutate(M, ind)

        if f(c) <= f(ind)  # O(2 * k_max)
            ind = c
        end
	end

    f_ind = f(ind) # O(1)
    n_evals = 2 * k_max + 1
    result = Result(f_ind, ind, [ind], k_max, n_evals)

	return result
end

function oneplusone(
    logger::Logbook, f::Function, ind::AbstractVector, k_max::Integer, M::MutationMethod
)
	for _ in 1:k_max
        c = mutate(M, ind)

        if f(c) <= f(ind)  # O(2 * k_max)
            ind = c
        end

        compute!(logger, [f(ind)])  # O(1)
	end

	f_ind = f(ind) # O(1)
    n_evals = 2 * k_max + 2
    result = Result(f_ind, ind, [ind], k_max, n_evals)

	return result
end
