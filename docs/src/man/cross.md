# Crossover operators

Crossover operators (a.k.a. _recombinators_) in EvoLP **generate 1 offspring** from two parents.

All operators are derived from the [`EvoLP.CrossoverMethod`](@ref) abstract type, and some of them have parameters to control how the recombination is performed.
Crossover methods are independent of the data contained in an individual, and are instead dependent on its representation.

Currently, crossover is only implemented for _vector_ individuals.

## Selecting a crossover operator

EvoLP provides many built-in recombinators.

### Representation-independent

Single point, two point and uniform crossover operators work on vectors of any numeric type.
Using them on permutation-based vectors could generate unfeasible solutions.

```@docs
SinglePointCrossover
TwoPointCrossover
UniformCrossover
```

### For continuous domains

```@docs
InterpolationCrossover
```

### For permutation representations

Order One (OX1) allows for feasibility to be preserved after recombination.

```@docs
OrderOneCrossover
```

## Performing the crossover

After "instantiating" a crossover method, you can use the `cross` function.
`cross` operates on two parents `a` and `b` to generate a new candidate solution.
All operators return a new individual, and in the process no individual is modified.

```@docs
cross
```
