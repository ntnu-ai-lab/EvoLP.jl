# Using PSO to minimise the Michalewicz function

This tutorial showcases how to use the built-in Particle Swarm Optimisation (PSO) algorithm for finding the minimum in a continuos setting.

We start by importing our necessary modules

```julia
using EvoLP
using Statistics
using OrderedCollections
```

For this example, we will use the Michalewicz function, which is a test function included in EvoLP:

```julia
@doc michalewicz
```

```julia
michalewicz(x; m=10)
```

> The **Michalewicz** function is a $d$-dimensional function with several steep valleys, where `m` controls the steepness. `m` is usually set at 10. For 2 dimensions, $x^* = [2.20, 1.57]$, with $f(x^*) = -1.8011$.
>
> $f(x) = -\sum_{i=1}^{d}\sin(x_i) \sin^{2m}\left(\frac{ix_i^2}{\pi}\right)$

In this case we will use $d=2$ and $m=10$, which are the default values implemented.

In PSO, we use *particles*. Each particle has a *position* and a *velocity*, and remembers the best position the whole swarm has visited. We can create a population of particles in multiple ways, but EvoLP provides 2 [**particle generators**](../man/generators.md) with random positions: either uniform or following a normal distribution.

Let's use the normal generator:**particle generators**

```julia
@doc normal_rand_particle_pop
```

```text
normal_rand_particle_pop(n, μ, Σ; rng=Random.GLOBAL_RNG)
```

> Generate a population of `n` [`Particle`](@ref) using a normal distribution with means `μ` and covariance`Σ`.
> `μ` expects a vector of length *l* (i.e. number of dimensions) while `Σ` expects an *l x l* matrix of covariances.

Since we are using the 2-dimensional version of the function, we need to provide a vector of 2 means and a $2 \times 2$ matrix of covariances:

```julia
population = normal_rand_particle_pop(50, [0, 0], [1 0; 0 1])
first(population, 3)
```

```text
3-element Vector{Any}:
    Particle([-0.22703948747578281, 1.7689889087227626], [0.0, 0.0], [-0.22703948747578281, 1.7689889087227626])
    Particle([0.9523372333139276, 1.8452380648469366], [0.0, 0.0], [0.9523372333139276, 1.8452380648469366])
    Particle([-1.2560899837782407, 0.15303679468484374], [0.0, 0.0], [-1.2560899837782407, 0.15303679468484374])
```

We can use the [`Logbook`](@ref) to save information about each iteration of the run. Let's save the average, median and best fitness:

```julia
statnames = ["avg_fit", "median_fit", "best_fit"]
callables = [mean, median, minimum]

thedict = LittleDict(statnames, callables)
logbook = Logbook(thedict)
```

```text
Logbook(LittleDict{AbstractString, Function, Vector{AbstractString}, Vector{Function}}("avg_fit" => Statistics.mean, "median_fit" => Statistics.median, "best_fit" => minimum), NamedTuple{(:avg_fit, :median_fit, :best_fit)}[])
```

Now we can use the built-in [`PSO`](@ref) algorithm:

```julia
@doc PSO
```

```text
PSO(f::Function, population, k_max; w=1, c1=1, c2=1)
PSO(logger::Logbook, f::Function, population, k_max; w=1, c1=1, c2=1)
```

> **Arguments**
>
> - `f::Function`: Objective function to minimise
> - `population`: Population—a list of [`Particle`](@ref) individuals
> - `k_max`: maximum iterations
> - `w`: Inertia weight. Optional, by default 1.
> - `c1`: Cognitive coefficient (my position). Optional, by default 1
> - `c2`: Social coefficient (swarm position). Optional, by default 1
>
> Returns a [`Result`](@ref).

Let's use the default parameters, and 30 iterations:

```julia
results = PSO(logbook, michalewicz, population, 30);
```

The output was suppressed so that we can analyse each part of the result separately using the [`Result`](@ref) functions:

```julia
@show optimum(results)
@show optimizer(results)
@show iterations(results)
@show f_calls(results)
```

```text
optimum(results) = -1.7945699649685944
optimizer(results) = Particle([2.4587719347604904, 1.5710645311634195], [-0.3065425967254033, 3.75884997817273e-5], [2.1824224667308583, 1.5710530344414129])
iterations(results) = 30
f_calls(results) = 4601
```

We can also take a look at the logbook's records and see how the calculated statistics changed throughout the run:

```julia
for (i, I) in enumerate(logbook.records)
    print("it: $(i) with best_pos: $(I[3]) and avg_pos: $(I[1]) \n")
end
```

```text
it: 1 with best_pos: -0.6906794768370129 and avg_pos: -0.005754793636862157 
it: 2 with best_pos: -0.9897012274595496 and avg_pos: -0.17476488948373003 
it: 3 with best_pos: -1.102946135488689 and avg_pos: -0.2783471388805291 
it: 4 with best_pos: -0.968940921732735 and avg_pos: -0.3095523155518831 
it: 5 with best_pos: -1.472368499905572 and avg_pos: -0.3379717198952197 
it: 6 with best_pos: -1.3055867468693856 and avg_pos: -0.3258715803445814 
it: 7 with best_pos: -1.3634607463646478 and avg_pos: -0.45466359334515916 
it: 8 with best_pos: -1.6705825784286839 and avg_pos: -0.6029634734635035 
it: 9 with best_pos: -1.5345866019317895 and avg_pos: -0.5501090751560626 
it: 10 with best_pos: -1.7212146343892145 and avg_pos: -0.5773626889249354 
it: 11 with best_pos: -1.779247279246615 and avg_pos: -0.6533233522934709 
it: 12 with best_pos: -1.7838823541946531 and avg_pos: -0.6378969618098259 
it: 13 with best_pos: -1.7931685047158967 and avg_pos: -0.6128555872381239 
it: 14 with best_pos: -1.7602231973069682 and avg_pos: -0.6399893054000261 
it: 15 with best_pos: -1.7903696633328317 and avg_pos: -0.5750118483927428 
it: 16 with best_pos: -1.7898716807412165 and avg_pos: -0.5954660432077975 
it: 17 with best_pos: -1.785632556103051 and avg_pos: -0.6282199097964665 
it: 18 with best_pos: -1.793412068667957 and avg_pos: -0.5967425923776992 
it: 19 with best_pos: -1.7945699649685944 and avg_pos: -0.5916369173134188 
it: 20 with best_pos: -1.7523847497822869 and avg_pos: -0.6651822602448447 
it: 21 with best_pos: -1.7851864041976486 and avg_pos: -0.5823099403323408 
it: 22 with best_pos: -1.7838001095222875 and avg_pos: -0.6533675831853937 
it: 23 with best_pos: -1.7739653477376558 and avg_pos: -0.6095419482154109 
it: 24 with best_pos: -1.7818070429845911 and avg_pos: -0.6334580923663595 
it: 25 with best_pos: -1.7849119381216694 and avg_pos: -0.5762643811160446 
it: 26 with best_pos: -1.7938521468057878 and avg_pos: -0.684789042512983 
it: 27 with best_pos: -1.7808066875854238 and avg_pos: -0.5577077719919309 
it: 28 with best_pos: -1.7608941215987302 and avg_pos: -0.6351975353921133 
it: 29 with best_pos: -1.7829383704900754 and avg_pos: -0.5261806929819258 
it: 30 with best_pos: -1.7905107361608266 and avg_pos: -0.575240903673051
```
