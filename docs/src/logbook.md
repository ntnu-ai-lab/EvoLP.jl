# Statistics Logbook

EvoLP includes a [`Logbook`](@ref) type which can be used to log statistics during runs.

```@docs
Logbook
```

The `Logbook` receives an [OrderedCollections.jl](https://github.com/JuliaCollections/OrderedCollections.jl) `LittleDict` (ordered dictionary for a _small number_ of items) with the following format:

```julia
LittleDict("statname"::String => callable::Function)
```

For example, using some of the `Statistics` built-in functions:

```jldoctest
julia> statnames = ["mean_eval", "max_f", "min_f", "median_f"];

julia> fns = [mean, maximum, minimum, median];

julia> thedict = LittleDict(statnames, fns)

# output

LittleDict{String, Function, Vector{String}, Vector{Function}} with 4 entries:
  "mean_eval" => mean
  "max_f"     => maximum
  "min_f"     => minimum
  "median_f"  => median
```

Then the logbook can be constructed:

```julia
thelogger = Logbook(thedict)
```

## Computing statistics

After instantiation, the [`compute!`](@ref) function can be used on each iteration of an algorithm.
The statistics are stored in the `records` field inside the `Logbook`, which is a vector of records (`NamedTuples`).
This makes it easier to export as a [DataFrame](https://github.com/JuliaData/DataFrames.jl).

```@docs
compute!
```
