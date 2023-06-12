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

> The **Michalewicz** function is a `d`-dimensional function with several steep valleys, where `m` controls the steepness. `m` is usually set at 10. For 2 dimensions, ``x^* = [2.20, 1.57]``, with ``f(x^*) = -1.8011``.
>
> ``f(x) = -\sum_{i=1}^{d}\sin(x_i) \sin^{2m}\left(\frac{ix_i^2}{\pi}\right)``

In this case we will use `d=2` and `m=10`, which are the default values implemented.

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

Since we are using the 2-dimensional version of the function, we need to provide a vector of 2 means and a `2 \times 2` matrix of covariances:

```julia
population = normal_rand_particle_pop(50, [0, 0], [1 0; 0 1])
first(population, 3)
```

```text
3-element Vector{Particle}:
 Particle([0.4040308336567521, -1.0956708260389603], [0.0, 0.0], Inf, [0.4040308336567521, -1.0956708260389603], Inf)
 Particle([-0.5690754175927688, -1.9016076908148127], [0.0, 0.0], Inf, [-0.5690754175927688, -1.9016076908148127], Inf)
 Particle([0.9895469924697422, -1.2022337920748436], [0.0, 0.0], Inf, [0.9895469924697422, -1.2022337920748436], Inf)
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
PSO(f::Function, population::Vector{Particle}, k_max::Integer; w=1, c1=1, c2=1)
PSO(logger::Logbook, f::Function, population::Vector{Particle}, k_max::Integer; w=1, c1=1, c2=1)
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
optimum(results) = -1.7987560672102798
optimizer(results) = [2.1935299266534836, 1.5760612400982805]
iterations(results) = 30
f_calls(results) = 1550
```

We can also take a look at the logbook's records and see how the calculated statistics changed throughout the run:

```julia
for (i, I) in enumerate(logbook.records)
    print("it: $(i) with best_pos: $(I[3]) and avg_pos: $(I[1]) \n")
end
```

```text
it: 1 with best_pos: -0.7504688680623768 and avg_pos: 0.027014191784156233 
it: 2 with best_pos: -0.7906765701486448 and avg_pos: -0.11592097787713364 
it: 3 with best_pos: -0.8012991501612791 and avg_pos: -0.17770241942233952 
it: 4 with best_pos: -0.7963864986732629 and avg_pos: -0.17023969225290894 
it: 5 with best_pos: -0.8726099514277835 and avg_pos: -0.2928504362404555 
it: 6 with best_pos: -1.1697700406204043 and avg_pos: -0.33670799217170105 
it: 7 with best_pos: -1.6221334762010642 and avg_pos: -0.3834145274427395 
it: 8 with best_pos: -0.9285497521300503 and avg_pos: -0.37119067568197167 
it: 9 with best_pos: -1.7520089205738312 and avg_pos: -0.42151516296756136 
it: 10 with best_pos: -1.587048845608525 and avg_pos: -0.3869242929292781 
...
it: 27 with best_pos: -1.7971172748131834 and avg_pos: -0.4865895651379651 
it: 28 with best_pos: -1.787184774482611 and avg_pos: -0.4625727297276257 
it: 29 with best_pos: -1.7916306274124452 and avg_pos: -0.42381102968626794 
it: 30 with best_pos: -1.77202650821346 and avg_pos: -0.46380678949496384 
```
