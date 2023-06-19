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
 [-0.25289759101653736, 1.0150132241600427]
 [-0.9053394512418402, 0.6058801355483802]
 [0.5784934203305488, -0.20665678122470943]
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
M = GaussianMutation(0.05)
```

```text
GaussianMutation(0.05)
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
GA(f::Function, population, k_max, S, C, M)
GA(logbook::Logbook, f::Function, population, k_max, S, C, M)
```

> Generational Genetic Algorithm.
>
> **Arguments**
>
  > * `f`: Objective function to minimise
  > * `population`: a list of individuals.
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
optimum(result) = 0.00015325530365919114
optimizer(result) = [0.9295343671510049, 0.9158201966396184]
f_calls(result) = 25000

(mean_eval = 0.07544433008393486, max_f = 0.43255087263181813, min_f = 0.00015325530365919114, median_f = 0.0424343220731829)
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
