# Using PSO to minimise the Michalewicz function

This tutorial showcases how to use the built-in Particle Swarm Optimisation (PSO) algorithm for finding the minimum in a continuos setting.

We start by importing our necessary modules

```@example mich
using EvoLP
using Statistics
using OrderedCollections
```

For this example, we will use the Michalewicz function, which is a test function included in EvoLP:

```@docs; canonical=false
michalewicz
```

In this case we will use `d=2` and `m=10`, which are the default values implemented.

In PSO, we use *particles*. Each particle has a *position* and a *velocity*, and remembers the best position the whole swarm has visited. We can create a population of particles in multiple ways, but EvoLP provides 2 [**particle generators**](../man/generators.md) with random positions: either uniform or following a normal distribution.

Let's use the normal generator:**particle generators**

```@docs; canonical=false
normal_rand_particle_pop
```

Since we are using the 2-dimensional version of the function, we need to provide a vector of 2 means and a `2 \times 2` matrix of covariances:

```@example mich
population = normal_rand_particle_pop(50, [0, 0], [1 0; 0 1])
first(population, 3)
```

We can use the [`Logbook`](@ref) to save information about each iteration of the run. Let's save the average, median and best fitness:

```@example mich
statnames = ["avg_fit", "median_fit", "best_fit"]
callables = [mean, median, minimum]
thedict = LittleDict(statnames, callables)
logbook = Logbook(thedict)
```

Now we can use the built-in [`PSO`](@ref) algorithm:

```@docs; canonical=false
PSO
```

Let's use the default parameters, and 30 iterations:

```@example mich
result = PSO(logbook, michalewicz, population, 30);
```

The output was suppressed so that we can analyse each part of the result separately using the [`Result`](@ref) functions:

```@example mich
@show optimum(result)
```

```@example mich
@show optimizer(result)
```

```@example mich
@show f_calls(result)
```

We can also take a look at the logbook's records and see how the calculated statistics changed throughout the run:

```@example mich
for (i, I) in enumerate(logbook.records)
    print("it: $(i) with best_pos: $(I[3]) and avg_pos: $(I[1]) \n")
end
```
