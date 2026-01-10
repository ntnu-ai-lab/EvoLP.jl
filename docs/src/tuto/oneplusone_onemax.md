# 1+1 EA for maximising a pseudoboolean function

This tutorial showcases how to use the built-in 1+1 Evolutionary Algorithm (EA).

First, we import our modules like so:

```@example om
using EvoLP
using OrderedCollections
using Statistics
```

For this example, we will use the [`onemax`](@ref) test function, which is already included in EvoLP:

```@docs; canonical=false
onemax
```

In an EA we use vectors as _individuals_. The 1+1 EA features 1 _parent_ and 1 _offspring_ each iteration.
Let's start creating the first individual. We can generate it manually, or use a generator. Let's do the latter:

```@docs; canonical=false
binary_vector_pop
```

It is important to note that the return value of the [`binary_vector_pop`](@ref) generator is a  _population_:  a list. This means we only want the first (and only) element inside:

```@example om
ind_size = 16
firstborn = binary_vector_pop(1, ind_size)[1]
```

Since the 1+1 EA works on a single individual, we only have the _mutation step_. We can set up the appropriate mutation operator: [`BitwiseMutator`](@ref).

```@docs; canonical=false
BitwiseMutator
```

This mutation operator needs a probability ``\lambda`` for flipping each bit, so we pass it like so:

```@example om
Mut = BitwiseMutator(1/ind_size)
```

Now on to the fitness function. Since EvoLP is built for _minimisation_, in order to do _maximisation_ we need to optimise for the _negative_ of **OneMax**:

```@example om
f(x) = -onemax(x)
```

Let's use the `Logbook` to record the fitness value on each iteration. We can do so by the `Base.identity` function as it will return the same value as the fitness:

```@example om
statnames = ["fit"]
callables = [identity]
thedict = LittleDict(statnames, callables)
logbook = Logbook(thedict)
```

We are now ready to use the [`oneplusone`](@ref) built-in algorithm:

```@docs; canonical=false
oneplusone
```

```@example om
result = oneplusone(logbook, f, firstborn, 64, Mut);
```

The output was suppressed so that we can analyse each part of the result separately using the [`Result`](@ref) functions:

```@example om
@show optimum(result)
```

```@example om
@show optimizer(result)
```

```@example om
@show f_calls(result)
```

We can also take a look at the logbook records and see how the statistics changed throughout the run (although in this case we just logged the fitness):

```@example om
first(logbook.records, 20)
```
