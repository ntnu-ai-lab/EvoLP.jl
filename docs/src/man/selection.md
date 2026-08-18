# Selection operators

Parent and Survivor selection operators (a.k.a. _selectors_) in EvoLP are based on fitness and are used to select individuals for **crossover** or survival for the next generation.
The selectors always return **indices** so that individuals can be selected from the population later.

## Parent Selectors

Parent selectors are used to generate the mating pool (the offspring) in evolutionary algorithms.
Since `EvoLP.jl` v2.1, all parent selectors can now optionally take a sample size `N` to generate an entire mating pool in a single function call.
If `N` is omitted, they default to `2`, as in a  _steady-state_ genetic algorithm where 2 parents create 1 offspring.

For _generational_ algorithms, you need to pass the appropriate value for ``N``, for example, once per each individual in the population, or $N=\mu$.

Parent selectors are derived from the [`EvoLP.ParentSelector`](@ref) abstract type, which is itself derived from the [`EvoLP.Selector`](@ref) abstract super type.
Some of the selectors have parameters you can adjust.

```@docs
TournamentSelector
TruncationSelector
```

```@docs
RouletteWheelSelector
RankBasedSelector
UniformSelector
```

## Survival Selectors

Survival selectors are deterministic operators that choose which individuals survive to form the next generation.
They are commonly used in Evolutionary Strategies and Evolutionary Algorithms with no crossover (mutation only).

Survival selectors are derived from the [`EvoLP.SurvivalSelector`](@ref), and as parent selectors, they also return indices that can be applied directly to your population arrays.

For [`PlusSelector`](@ref), the returned indices refer to a concatenated array of `vcat(parents, offspring)`.

!!! info "Deterministic Behaviour"
    Unlike Parent Selectors, which rely on stochastic sampling to generate a mating pool, Survival Selectors in EvoLP model strict environmental truncation. Their `select` methods do not accept or require a Random Number Generator (`rng`) parameter because they deterministically extract the top `μ` individuals.

```@docs
CommaSelector
PlusSelector
```

## Performing the selection

After "instantiating" a selection method, you can use the `select` function on an array of fitnesses `y` to obtain ``N`` **parent indices** (that you will need to slice from the population in your algorithm later.)

In the case of survival selectors, you would get ``N`` indices (that you will need to slice from the population of offspring, for example) to get the population for the next iteration.

```@docs
select
```
