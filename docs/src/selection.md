# Selection operators

Selection methods are based on fitness and are used to select individual for **crossover**.
All operators are derived from the `SelectionMethod` abstract type and some of them have parameters you can adjust.

```@docs
SelectionMethod
```

```@docs
TournamentSelection
TruncationSelection
```

```@docs
RouletteWheelSelection
RankBasedSelection
```

After "instantiating" a selection method, you can use `select` on an array of fitnesses `y` to obtain a pair of parents' indices (to be sliced from the population later).

All methods return a list of lists, which are **two parent indices** for every fitness passed.

```@docs
select
```
