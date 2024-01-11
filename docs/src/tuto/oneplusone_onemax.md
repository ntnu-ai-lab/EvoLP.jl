# 1+1 EA for maximising a pseudoboolean function

This tutorial showcases how to use the built-in 1+1 Evolutionary Algorithm (EA).

First, we import our modules like so:

```julia
using EvoLP
using OrderedCollections
using Statistics
```

For this example, we will use the [`onemax`](@ref) test function, which is already included in EvoLP:

```julia
@doc onemax
```

> The **OneMax** function returns the sum of the individual. For an individual of length ``n``, maximum is achieved with ``n`` ones.
>
> ``\text{OneMax}(\mathbf{x}) = \sum_{i=1}^n x_i``

In an EA we use vectors as _individuals_. The 1+1 EA features 1 _parent_ and 1 _offspring_ each iteration.

Let's start creating the first individual. We can generate it manually, or use a generator. Let's do the latter:

```julia
@doc binary_vector_pop
```

```text
binary_vector_pop(n, l; rng=Random.GLOBAL_RNG)
```

> Generate a population of `n` vector binary individuals, each of length `l`.

It is important to note that the return value of the [`binary_vector_pop`](@ref) generator is a  _population_:  a list. This means we only want the first (and only) element inside:

```julia
ind_size = 15
firstborn = binary_vector_pop(1, ind_size)[1]
```

```text
15-element BitVector:
    0
    0
    1
    1
    0
    0
    1
    0
    0
    1
    1
    0
    1
    0
    1
```

Since the 1+1 EA works on a single individual, we only have the _mutation step_. We can set up the appropriate mutation operator: [`BitwiseMutator`](@ref).

```julia
@doc BitwiseMutator
```

> Bitwise mutation with probability `λ` of flipping each bit.

This mutation operator needs a probability ``\lambda`` for flipping each bit, so we pass it like so:

```julia
Mut = BitwiseMutator(1/ind_size)
```

```text
BitwiseMutator(0.06666666666666667)
```

Now on to the fitness function. Since EvoLP is built for _minimisation_, in order to do _maximisation_ we need to optimise for the _negative_ of **OneMax**:

```julia
f(x) = -onemax(x)
```

```text
f (generic function with 1 method)
```

Let's use the `Logbook` to record the fitness value on each iteration. We can do so by the `Base.identity` function as it will return the same value as the fitness:

```julia
statnames = ["fit"]
callables = [identity]
thedict = LittleDict(statnames, callables)
logbook = Logbook(thedict)
```

```text
Logbook(LittleDict{AbstractString, Function, Vector{AbstractString}, Vector{Function}}("fit" => identity), NamedTuple{(:fit,)}[])
```

We are now ready to use the [`oneplusone`](@ref) built-in algorithm:

```julia
@doc oneplusone
```

```text
oneplusone(f::Function, ind, k_max, M)
oneplusone(logger::Logbook, f::Function, ind, k_max, M)
```

> 1+1 EA algorithm.
>
> **Arguments**
>
> - `f`: Objective function to minimise
> - `ind`: Individual to start the evolution
> - `k_max`: Maximum number of iterations
> - `M::Mutator`: A mutation method. See mutation.
>
> Returns a [`Result`](@ref).

```julia
result = oneplusone(logbook, f, firstborn, 50, Mut);
```

The output was suppressed so that we can analyse each part of the result separately using the [`Result`](@ref) functions:

```julia
@show optimum(result)
@show optimizer(result)
@show iterations(result)
@show f_calls(result)
```

```text
optimum(result) = -15
optimizer(result) = Bool[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
iterations(result) = 50
f_calls(result) = 102
```

We can also take a look at the logbook records and see how the statistics changed throughout the run (although in this case we just logged the fitness):

```julia
first(logbook.records, 20)
```

```text
20-element Vector{NamedTuple{(:fit,)}}:
    (fit = [-7],)
    (fit = [-7],)
    (fit = [-8],)
    (fit = [-9],)
    (fit = [-9],)
    (fit = [-9],)
    (fit = [-9],)
    (fit = [-9],)
    (fit = [-9],)
    (fit = [-9],)
    (fit = [-9],)
    (fit = [-9],)
    (fit = [-9],)
    (fit = [-10],)
    (fit = [-10],)
    (fit = [-10],)
    (fit = [-10],)
    (fit = [-11],)
    (fit = [-11],)
    (fit = [-11],)
```
