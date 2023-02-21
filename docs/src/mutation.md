# Mutation operators

Mutation operators are derived from the `MutationMethod` abstract type, and some of them have parameters to control how the mutation is performed.
Mutation methods are dependent on both the data contained in an individual and its representation.

```@docs
MutationMethod
```

```@docs
BitwiseMutation
GaussianMutation
SwapMutation
InsertMutation
ScrambleMutation
InversionMutation
```

After "instantiating" a mutation method, you can use `mutate` on a single individual `ind`.
All operators return a copy, and in the process no individual is modified.

Currently, mutation is only implemented for _vector_ individuals.

```@docs
mutate
```
