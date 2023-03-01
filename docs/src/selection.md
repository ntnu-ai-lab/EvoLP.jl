# Selection operators

Parent selection operators are based on fitness and are used to select individuals for **crossover**.

These methods come in two variants: _steady-state_ and _generational_.
_Steady-state_ operators return two parent indices, while _generational_ operators return a list of two parent indices for each fitness in the population.

Regardless of the variant, all operators are derived from the `SelectionMethod` abstract type and some of them have parameters you can adjust.

```@docs
SelectionMethod
```

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

After "instantiating" a selection method, you can use the `select` function on an array of fitnesses `y` to obtain **parents' indices** (to be sliced from the population in your algorithm).

```@docs
select
```
