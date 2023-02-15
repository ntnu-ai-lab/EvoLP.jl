"A type for reporting results and utility functions"


"""
The result of an algorithm. The result contains information about the optimizer ``x^*``,
its evaluation ``f(x^*)``, the last state of the population, the number of iterations and
the number of function calls.
"""
struct Result
    fxstar  # optimum
    xstar  # optimizer
    population  # population at last state
    n_iters # pass the number of iterations
    n_evals  # number of individual evaluations
    # runtime? # TODO
end

"""
    optimum(result)

Returns evaluation of solution found ``f(x^*)``.
"""
optimum(res) = res.fxstar

"""
    optimizer(result)

Returns solution found ``x^*``.
"""
optimizer(res) = res.xstar

"""
    iterations(res)

Returns the number of iterations of a result.
"""
iterations(res) = res.n_iters

"""
    f_calls(res)

Returns number of function evaluation calls of a result.
"""
f_calls(res) = res.n_evals

"""
    population(res)

Returns the resulting population of the algorithm.
"""
population(res) = res.population
