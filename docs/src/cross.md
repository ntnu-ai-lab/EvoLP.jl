# Crossover operators

Crossover operators are derived from the `CrossoverMethod` abstract type, and some of them have parameters to control how the reproduction is performed.
Crossover methods are independent of the data contained in an individual, and are instead dependent on its representation.

```@docs
CrossoverMethod
```

```@docs
InterpolationCrossover
```

```@docs
SinglePointCrossover
TwoPointCrossover
UniformCrossover
```

After "instantiating" a crossover method, you can use the `cross`function.
`cross` operates on two parents `a` and `b` to generate a new candidate solution.
Some of the `CrossoverMethod`s .
All operators return a new individual, and in the process no individual is modified.

Currently, crossover is only implemented for _vector_ individuals.

```@docs
cross
```
