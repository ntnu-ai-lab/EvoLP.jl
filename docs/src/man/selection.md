# Selection operators

Parent selection operators (a.k.a. _selectors_) in EvoLP are based on fitness and are used to select individuals for **crossover**. The selectors always return **indices** so that individuals can be selected from the population later.

These methods come in two variants: _steady-state_ and _generational_.
_Steady-state_ operators return two parent indices, while _generational_ operators return a list of two parent indices for each fitness in the population.

In other words, _steady-state_ variants perform one selection, while _generational_ variants perform $n$ selections.

Regardless of the variant, all operators are derived from the `SelectionMethod` abstract type and some of them have parameters you can adjust.

```@docs
SelectionMethod
```

## Choosing a selection operator

EvoLP provides many built-in selectors.

```@docs
TournamentSelectionSteady
TournamentSelectionGenerational
TruncationSelectionSteady
TruncationSelectionGenerational
```

```@docs
RouletteWheelSelectionSteady
RouletteWheelSelectionGenerational
RankBasedSelectionSteady
RankBasedSelectionGenerational
```

## Performing the selection

After "instantiating" a selection method, you can use the `select` function on an array of fitnesses `y` to obtain **parents' indices** (that you will need to slice from the population in your algorithm later.)

```@docs
select
```
