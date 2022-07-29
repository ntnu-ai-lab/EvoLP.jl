"""
    oneplusone(f, ind, k_max, M)

1+1 EA algorithm.

# Arguments

- `f`: Objective function to minimise
- `ind`: Individual to start the evolution
- `k_max`: Maximum number of iterations
- `M::MutationMethod`: A mutation method. See mutation.
"""
function oneplusone(f, ind, k_max, M)
	for _ in 1:k_max
        c = mutate(M, ind)
        if f(c) <= f(ind)
            ind = c
        end
	end
	return ind
end
