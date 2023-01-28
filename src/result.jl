"A type for reporting results and utility functions"


"""
The result of an algorithm. The result contains information about the optimizer ``x^*``,
its evaluation ``f(x^*)``, the last state of the population, the number of iterations and
the number of function calls.
"""

struct Result
    xstar  # optimizer
    fxstar  # optimum
    population  # population at last state
    n_iters # right now it's just the value of k_max # TODO
    n_evals  # number of individual evaluations
    # runtime? # TODO
end

"""
    optimizer(result)

Returns solution found ``x^*``.
"""
optimizer(res) = res.xstar

"""
    optimum(result)

Returns evaluation of solution found ``f(x^*)``.
"""
optimum(res) = res.fxstar

"""
    f_calls(res)

Returns number of function evaluation calls of the result.
"""
f_calls(res) = res.n_evals

"""
    population(res)

Returns the final population of the algorithm.
"""
population(res) = res.population
