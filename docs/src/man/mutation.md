# Mutation operators

Mutation operators (a.k.a. _mutators_) work on a single individual and return a copy.
Some of them have parameters to control how the mutation is performed, and are dependent on both the data contained in an individual and its representation.

Currently, mutation is only implemented for _vector_ individuals.

## Selecting a mutation operator

!!! warning "Deprecated from EvoLP 1.4"
    All mutation operators have been **renamed** to _mutators_ since EvoLP 1.4.
    The old names will be **deprecated** in a future major release.
    Be sure to check the new [type ontology](../man/extending.md).

EvoLP provides many built-in mutators.

### For binary vectors

```@docs
BitwiseMutator
```

### For continuous vectors

```@docs
GaussianMutator
```

### For permutation-based vectors

```@docs
SwapMutator
InsertionMutator
ScrambleMutator
InversionMutator
```

## Performing the mutation

After "instantiating" a mutation method, you can use `mutate` on a single individual `ind`.
All operators return a copy, and in the process no individual is modified.

```@docs
mutate
```
