# Utilities

Since version v2.1, EvoLP.jl now includes some utilities and metrics that may come in handy when working with evolutionary algorithms.

## Bitstring and Binary Utilities

Although many algorithms, operators, and functions in EvoLP work well with bitstrings created from 0s and 1s using `Vector{Int}` representation, it is much more efficient to work on Boolean vectors (or `BitVector <: BitArray`).

To convert these individuals to `BitVector`, we provide a convenient function, [`force_boolean`](@ref).

```@docs
force_boolean
```

The following utilities are efficient on individuals of type `BitVector`:

```@docs
ind2dec
ind2str
dec2ind
str2ind
get_neighbourhood
get_neighbourhood_ixs
global_entropy
```