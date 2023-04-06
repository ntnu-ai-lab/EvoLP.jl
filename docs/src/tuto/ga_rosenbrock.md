# Generational GA for continuous optimisation

This tutorial details how to use the built-in Genetic Algorithm (GA) on a continuous test function.

We start by importing EvoLP. We will compute some statistics using the [`Logbook`](@ref) so we need some additional modules as well:

```julia
using Statistics
using EvoLP
using OrderedCollections
```

For this example we will use the **Rosenbrock** function, which is already included as a benchmark in EvoLP. We can look at the documentation like so:

```julia
@doc rosenbrock
```

```julia
rosenbrock(x; a=1, b=5)
```

> **Rosenbrock** benchmark function. With ``a=1`` and ``b=5``, minimum is at ``f([a, a^2]) = 0``
>
> ``f(x) = (a - x_1)^2 + b(x_2 - x_1^2)^2``

## Implementing the solution

Let's start creating the population. We can  use the [`normal_rand_vector_pop`](@ref) generator, which uses a normal distribution for initialisation:

```julia
@doc normal_rand_vector_pop
```

```text
normal_rand_vector_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)
```

> Generate a population of `n` vector individuals using a normal distribution with means `μ` and covariance `Σ`.
> `μ` expects a vector of length *l* (i.e. length of an individual) while `Σ` expects an *l x l* matrix of covariances.

The [`rosenbrock`](@ref) in our case is 2D, so we need a vector of 2 means, and a matrix of 2x2 covariances:

```julia
pop_size = 50
population = normal_rand_vector_pop(pop_size, [0, 0], [1 0; 0 1])
first(population, 3)
```

```text
3-element Vector{Vector{Float64}}:
    [-1.6427111696272696, 0.5882958618620507]
    [-1.0327502018102739, -0.12553291195289634]
    [0.16879891668759264, -0.41216354050954684]
```

In a GA, we have *selection*, *crossover* and *mutation*.

We can easily set up these operators using the built-ins provided by EvoLP. Let's use rank based selection and interpolation crossover with 0.5 as the scaling factor:

```julia
@doc InterpolationCrossover
```

> Interpolation crossover with scaling parameter ``λ``.

```julia
S = RankBasedSelectionGenerational()
C = InterpolationCrossover(0.5)
```

```text
InterpolationCrossover(0.5)
```

For mutation, we can use Gaussian noise:

```julia
@doc GaussianMutation
```

> Gaussian mutation with standard deviation `σ`, which should be a real number.

```julia
M = GaussianMutation(0.5)
```

```text
GaussianMutation(0.5)
```

Now we can set up the [`Logbook`](@ref) to record statistics about our run:

```julia
statnames = ["mean_eval", "max_f", "min_f", "median_f"]
fns = [mean, maximum, minimum, median]
thedict = LittleDict(statnames, fns)
thelogger = Logbook(thedict)
```

```text
Logbook(LittleDict{AbstractString, Function, Vector{AbstractString}, Vector{Function}}("mean_eval" => Statistics.mean, "max_f" => maximum, "min_f" => minimum, "median_f" => Statistics.median), NamedTuple{(:mean_eval, :max_f, :min_f, :median_f)}[])
```

And now we're ready to use the `GA` built-in algorithm:

```julia
@doc GA
```

```text
GA(f::Function, pop, k_max, S, C, M)
GA(logbook::Logbook, f::Function, pop, k_max, S, C, M)
```

> Generational Genetic Algorithm.
>
> **Arguments**
>
  > * `f`: Objective function to minimise
  > * `pop`: Population—a list of individuals.
  > * `k_max`: maximum iterations
  > * `S::SelectionMethod`: a selection method. See selection.
  > * `C::CrossoverMethod`: a crossover method. See crossover.
  > * `M::MutationMethod`: a mutation method. See mutation.
>
> Returns a [`Result`](@ref).

```julia
result = GA(thelogger, rosenbrock, population, 300, S, C, M);
```

The output was suppressed so that we can analyse each part of the result separately using functions instead:

```julia
@show optimum(result)

@show optimizer(result)

@show f_calls(result)

thelogger.records[end]
```

```text
optimum(result) = 0.0015029528354023858
optimizer(result) = [1.0367119356341026, 1.0803427525882299]
f_calls(result) = 50050

(mean_eval = 3.7839504926952294, max_f = 22.281919411164413, min_f = 0.0015029528354023858, median_f = 2.429775485243721)
```

The records in the `Logbook` are `NamedTuples`. This makes it easier to export and analyse using [DataFrames](https://dataframes.juliadata.org/stable/), for example:

```julia
using DataFrames
DataFrame(thelogger.records)
```

```text
500×4 DataFrame
 Row │ mean_eval  max_f     min_f        median_f 
     │ Float64    Float64   Float64      Float64  
─────┼────────────────────────────────────────────
   1 │   9.89648  134.066   0.149169      3.6715
   2 │   5.73033   40.1663  0.134373      2.94368
   3 │   4.65904   18.9003  0.181144      3.22389
   4 │   4.34055   52.1745  0.0813748     2.14014
   5 │   5.1239    42.4315  0.119411      2.83591
   6 │   3.70733   37.285   0.0413168     2.17732
   7 │   4.84669   66.9539  0.00445092    2.52908
   8 │   3.87748   26.8901  0.345194      1.75084
  ⋮  │     ⋮         ⋮           ⋮          ⋮
```
