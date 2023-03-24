# Genetic Algorithm

This notebook showcases how to use the built-in Genetic Algorithm (GA)


```julia
using Statistics
using EvoLP
using OrderedCollections
```

For this example we will use the **Rosenbrock** function:


```julia
@doc rosenbrock
```


```
rosenbrock(x; a=1, b=5)
```

**Rosenbrock** benchmark function. With $a=1$ and $b=5$, minimum is at $f([a, a^2]) = 0$

$$
f(x) = (a - x_1)^2 + b(x_2 - x_1^2)^2
$$



In a GA, we use vectors as _individuals_.

Let's start creating the population. For that, we can use a generator. Let's use the normal generator:


```julia
@doc normal_rand_vector_pop
```


```
normal_rand_vector_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)
```

Generate a population of `n` vector individuals using a normal distribution with means `μ` and covariance `Σ`.

`μ` expects a vector of length *l* (i.e. length of an individual) while `Σ` expects an *l x l* matrix of covariances.

# Examples

```julia
julia> normal_rand_vector_pop(3, [0, 0], [1 0; 0 1])
3-element Vector{Vector{Float64}}:
 [-0.15290525182234904, 0.8715880371871617]
 [-1.1283800329864322, -0.9256584563613383]
 [-0.5384758126777555, -0.8141702145510666]
```




```julia
pop_size = 50
population = normal_rand_vector_pop(pop_size, [0, 0], [1 0; 0 1])
first(population, 3)
```


    3-element Vector{Vector{Float64}}:
     [-1.6427111696272696, 0.5882958618620507]
     [-1.0327502018102739, -0.12553291195289634]
     [0.16879891668759264, -0.41216354050954684]


In a GA, we have _selection_, _crossover_ and _mutation_.

We can easily set up these operators using the built-ins provided by EvoLP.

Let's use rank based selection and interpolation crossover with 0.5 as the scaling factor:


```julia
@doc InterpolationCrossover
```


Interpolation crossover with scaling parameter `λ`.




```julia
S = RankBasedSelectionGenerational()
C = InterpolationCrossover(0.5)
```


    InterpolationCrossover(0.5)


For mutation, we can use a Gaussian approach:


```julia
@doc GaussianMutation
```


Gaussian mutation with standard deviation `σ`, which should be a real number.




```julia
M = GaussianMutation(0.7)
```


    GaussianMutation(0.7)


We can use the `Logbook` to record statistics about our run:


```julia
statnames = ["mean_eval", "max_f", "min_f", "median_f"]
fns = [mean, maximum, minimum, median]
thedict = LittleDict(statnames, fns)
thelogger = Logbook(thedict)
```


    Logbook(LittleDict{AbstractString, Function, Vector{AbstractString}, Vector{Function}}("mean_eval" => Statistics.mean, "max_f" => maximum, "min_f" => minimum, "median_f" => Statistics.median), NamedTuple{(:mean_eval, :max_f, :min_f, :median_f)}[])


And now we're ready to use the `GA` built-in algorithm:


```julia
@doc GA
```


```
GA(f::Function, pop, k_max, S, C, M)
GA(logbook::Logbook, f::Function, pop, k_max, S, C, M)
```

Generational Genetic Algorithm.

## Arguments

  * `f`: Objective function to minimise
  * `pop`: Population—a list of individuals.
  * `k_max`: maximum iterations
  * `S::SelectionMethod`: a selection method. See selection.
  * `C::CrossoverMethod`: a crossover method. See crossover.
  * `M::MutationMethod`: a mutation method. See mutation.

Returns a `Result` type of the form:

$$
\big( f(x^*), x^*, pop, k_{max}, f_{calls} \big)
$$




```julia
result = GA(thelogger, rosenbrock, population, 300, S, C, M);
```

The output was suppressed so that we can analyse each part of the result separately:


```julia
@show optimum(result)

@show optimizer(result)

@show f_calls(result)

@show thelogger.records[end]
```

    optimum(result) = 0.019865167619196974
    optimizer(result) = [0.8673659191990879, 0.7736467155644884]
    f_calls(result) = 30050
    thelogger.records[end] = (mean_eval = 15.113532690769519, max_f = 268.03367553524595, min_f = 0.019865167619196974, median_f = 3.3583402289395234)



    (mean_eval = 15.113532690769519, max_f = 268.03367553524595, min_f = 0.019865167619196974, median_f = 3.3583402289395234)

