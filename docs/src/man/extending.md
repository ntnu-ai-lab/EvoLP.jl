# Creating your own blocks

If you want to experiment with new _building blocks_, you can create your own by using the _abstract_ block types as a supertype of your own mutators, selectors and crossover methods.
These abstract blocks are the following:

```@autodocs
Modules = [EvoLP]
Public = false
Order = [:type]
```

These abstract types are **not exported** in EvoLP, which means that you will not see them if you used `using EvoLP` in your code. You need to access them directly, by writing `EvoLP.<theabstractblock>`.

Once you have your own type, you need to explicitly code how the _block_ should operate. This is done by creating a new function: [`select`](@ref), [`cross`](@ref) or [`mutate`](@ref), depending on what your abstract supertype is.

After that, you can use the new blocks in your algorithms like any of the other built-in blocks.

## A hypothetical example

You can use the corresponding `AbstractType` to create a new mutation method called `MyCrazyMutation` like so:

```julia
struct MyCrazyMutation <: EvoLP.MutationMethod
    param1
    param2
    param3
end
```

Then, we will create a new function `mutate` which will look something like the following:

```julia
function mutate(M::MyCrazyMutation, ind; rng=Random.GLOBAL_RNG)
    mutant = deepcopy(ind)
    if rand(rng) < param3
        mutant[1] = mutant[1] + M.param1
        mutant[2] = mutant[2] - M.param2
    end

    return mutant
end
```

This `MyCrazyMutation` method will then operate on a hypothetical 2-dimensional individual `ind`, and will change its first dimension by its `param1`, and the second dimension using `param2` if a random number is less than its `param3`.

Then, you can use it in your algorithms as if it was any other block. Here is a fake snippet for illustration purposes:

```julia
function myalgorithm(...)
    M = MyCrazyMutation(p1, p2, p3)
    ...
    mutate(M, ind)
    ...
end
```

## A word about randomisation

If using random numbers (for example in crossover or mutation operators) it is always a good idea to pass to your function a random number generator instance. In this way, your code can be both used for unit testing as well as for constructing shareable examples that are reproducible for the sake of science.
