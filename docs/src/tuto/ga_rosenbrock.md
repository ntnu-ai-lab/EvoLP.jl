# Generational GA for continuous optimisation

This tutorial details how to use the built-in Genetic Algorithm (GA) on a continuous test function.

We start by importing EvoLP. We will compute some statistics using the [`Logbook`](@ref) so we need some additional modules as well:

```@example ros
using Statistics
using EvoLP
using OrderedCollections
```

For this example we will use the **Rosenbrock** function, which is already included as a benchmark function in EvoLP. We can look at the documentation like so:

```@docs; canonical=false
rosenbrock
```

## Implementing the solution

Let's start creating the population. We can  use the [`normal_rand_vector_pop`](@ref) generator, which uses a normal distribution for initialisation:

```@docs; canonical=false
normal_rand_vector_pop
```

```@example ros
pop_size = 50
population = normal_rand_vector_pop(pop_size, [0, 0], [1 0; 0 1])
first(population, 3)
```

In a GA, we have *selection*, *crossover* and *mutation*.

We can easily set up these operators using the built-ins provided by EvoLP. Let's use rank based selection and interpolation crossover with 0.5 as the scaling factor:

```@docs; canonical=false
InterpolationRecombinator
```

```@example ros
S = RankBasedSelector()
C = InterpolationRecombinator(0.5)
```

For mutation, we can use Gaussian noise:

```@docs; canonical=false
GaussianMutator
```

```@example ros
M = GaussianMutator(0.05)
```

Now we can set up the [`Logbook`](@ref) to record statistics about our run:

```@example ros
statnames = ["mean_eval", "max_f", "min_f", "median_f"]
fns = [mean, maximum, minimum, median]
thedict = LittleDict(statnames, fns)
thelogger = Logbook(thedict)
```

And now we're ready to use the `GA` built-in algorithm:

```@docs; canonical=false
GA
```

```@example ros
result = GA(thelogger, rosenbrock, population, 300, S, C, M);
```

The output was suppressed so that we can analyse each part of the result separately using functions instead:

```@example ros
@show optimum(result)
```

```@example ros
@show optimizer(result)
```

```@example ros
@show f_calls(result)
```

```@example ros
thelogger.records[end]
```

The records in the `Logbook` are `NamedTuples`. This makes it easier to export and analyse using [DataFrames](https://dataframes.juliadata.org/stable/), for example:

```julia
using DataFrames
DataFrame(thelogger.records)
```

```text
500×4 DataFrame
 Row │ mean_eval   max_f       min_f        median_f  
     │ Float64     Float64     Float64      Float64   
─────┼────────────────────────────────────────────────
   1 │ 22.0251     406.9       0.447041     6.78992
   2 │  3.61617     36.062     0.124031     1.96466
   3 │  1.13189      3.18343   0.127583     1.07601
   4 │  0.781777     1.6644    0.309661     0.711803
   5 │  0.593735     0.935043  0.294026     0.588684
   6 │  0.527621     0.766033  0.315916     0.518089
   7 │  0.522381     0.745129  0.37027      0.527158
   8 │  0.493569     0.807639  0.275269     0.498038
  ⋮ │     ⋮           ⋮            ⋮           ⋮
```
