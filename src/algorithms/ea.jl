"""
    oneplusone(f::Function, ind, k_max, M)
    oneplusone(logger::Logbook, f::Function, ind, k_max, M)

1+1 EA algorithm.

# Arguments

- `f`: Objective function to minimise
- `ind`: Individual to start the evolution
- `k_max`: Maximum number of iterations
- `M::MutationMethod`: A mutation method. See mutation.

Returns a `Result` type of the form:

```math
\\big( f(x^*), x^*, pop, k_{max}, f_{calls} \\big)
```
"""
function oneplusone(f::Function, ind, k_max, M)
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

function oneplusone(logger::Logbook, f::Function, ind, k_max, M)
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
