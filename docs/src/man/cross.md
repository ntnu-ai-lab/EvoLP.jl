# Crossover operators

Crossover operators (a.k.a. _recombinators_) in EvoLP work on two parents `a` and `b` to **generate 1 offspring**.
All operators are derived from the [`EvoLP.Recombinator`](@ref) abstract type, and some of them have parameters to control how the recombination is performed.
Crossover methods are independent of the data contained in an individual, and are instead dependent on its representation.

Currently, crossover is only implemented for _vector_ individuals.

## Selecting a crossover operator

!!! warning "Deprecated from EvoLP 1.4"
    All crossover operators have been **renamed** to _recombinators_ since EvoLP 1.4.
    The old names will be **deprecated** in a future major release.
    Be sure to check the new [type ontology](../man/extending.md).

EvoLP provides many built-in recombinators.

### Representation-independent

Single point, two point and uniform crossover operators work on vectors of any numeric type (binary or continuous representations).
Using them on permutation-based vectors could generate unfeasible solutions.

```@docs
SinglePointRecombinator
TwoPointRecombinator
UniformRecombinator
```

### For continuous domains

```@docs
InterpolationRecombinator
```

### For permutation representations

Order One (OX1) allows for feasibility to be preserved after recombination.

```@docs
OX1Recombinator
```

## Performing the crossover

After "instantiating" a recombinator, you can use the `cross` function.
`cross` operates on two parents `a` and `b` to generate a new candidate solution.
All operators return a new individual, and in the process no individual is modified.

```@docs
cross
```

To obtain a second individual during crossover, use the `cross` method swapping the arguments.
