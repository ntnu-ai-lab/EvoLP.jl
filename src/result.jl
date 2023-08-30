"A type for reporting results and utility functions"


"""
A type for reporting results of an algorithm: the optimum ``f(x^*)``, the optimizer ``x^*``,
the population, the number of iterations and the number of function calls.
"""
struct Result
    fxstar  # optimum
    xstar  # optimizer
    population  # population at last state
    n_iters # pass the number of iterations
    n_evals  # number of individual evaluations
    runtime
end

"""
    optimum(result)

Returns evaluation of solution found ``f(x^*)``.
"""
optimum(res::Result) = res.fxstar

"""
    optimizer(result)

Returns solution found ``x^*``.
"""
optimizer(res::Result) = res.xstar

"""
    iterations(res::Result)

Returns the number of iterations of a result.
"""
iterations(res::Result) = res.n_iters

"""
    f_calls(res::Result)

Returns number of function evaluation calls of a result.
"""
f_calls(res::Result) = res.n_evals

"""
    population(res::Result)

Returns the resulting population of the algorithm.
"""
population(res::Result) = res.population

"""
    runtime(res::Result)

Returns the resulting runtime of the algorithm.
"""
runtime(res::Result) = res.runtime
