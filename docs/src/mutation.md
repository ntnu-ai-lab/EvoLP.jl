# Mutation operators

Mutation operators (a.k.a. _mutators_) are derived from the `MutationMethod` abstract type, and some of them have parameters to control how the mutation is performed.
Mutation methods are dependent on both the data contained in an individual and its representation.

Currently, mutation is only implemented for _vector_ individuals.

```@docs
MutationMethod
```

## Selecting a mutation operator

EvoLP provides many built-in mutators.

### For binary vectors

```@docs
BitwiseMutation
```

### For continuous vectors

```@docs
GaussianMutation
```

### For permutation-based vectors

```@docs
SwapMutation
InsertMutation
ScrambleMutation
InversionMutation
```

## Performing the mutation

After "instantiating" a mutation method, you can use `mutate` on a single individual `ind`.
All operators return a copy, and in the process no individual is modified.

```@docs
mutate
```
