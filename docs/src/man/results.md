# Reporting results

EvoLP provides a type for reporting results that you can use as the return vale of an algorithm.
The type has different data fields conveniently stored in a single variable, which allows for further inspection if desired (for example for post-mortem visualisation and analysis.)

```@docs
Result
```

Some _getter_ functions are also included to obtain specific information about the result.

```@docs
optimum
optimizer
population
iterations
f_calls
runtime
```

All built-in [algorithms](algorithms.md) in EvoLP use the `Result` as their return value.
