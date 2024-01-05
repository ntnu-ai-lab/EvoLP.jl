# Selection operators

Parent selection operators (a.k.a. _selectors_) in EvoLP are based on fitness and are used to select individuals for **crossover**. The selectors always return **indices** so that individuals can be selected from the population later.

All of these methods perform a single operation, as in a  _steady-state_ algorithm.
Each selector returns two parent indices.

<!-- TODO: add a callout here? -->
For _generational_ algorithms, you need to repeat the selection ``n`` times; once per each individual in the population.

All operators are derived from the [`EvoLP.ParentSelector`](@ref) abstract type, which is itself derived from the [`EvoLP.Selector`](@ref) abstract super type.
Some of the selectors have parameters you can adjust.

## Choosing a selection operator

EvoLP provides many built-in selectors.

```@docs
TournamentSelector
TruncationSelector
```

```@docs
RouletteWheelSelector
RankBasedSelector
```

## Performing the selection

After "instantiating" a selection method, you can use the `select` function on an array of fitnesses `y` to obtain 2 **parents' indices** (that you will need to slice from the population in your algorithm later.)

```@docs
select
```
