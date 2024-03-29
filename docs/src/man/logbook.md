# Statistics Logbook

EvoLP includes a [`Logbook`](@ref) type which can be used to log statistics during runs.

```@docs
Logbook
```

```@meta
DocTestSetup = quote
  using OrderedCollections
  using Statistics
end
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
LittleDict{String, Function, Vector{String}, Vector{Function}} with 4 entries:
  "mean_eval" => mean
  "max_f"     => maximum
  "min_f"     => minimum
  "median_f"  => median
```

Then the logbook can be constructed:

```julia
julia> thelogger = Logbook(thedict)
Logbook(LittleDict{AbstractString, Function, Vector{AbstractString}, Vector{Function}}("mean_eval" => Statistics.mean, "max_f" => maximum, "min_f" => minimum, "median_f" => Statistics.median), NamedTuple{(:mean_eval, :max_f, :min_f, :median_f)}[])
```

If no `LittleDict` is provided, then the logbook includes a default set of descriptive statistics: minimum, mean, median, maximum and standard deviation&mdash;in that order.

## Computing statistics

After instantiating the Logbook, you can use the [`compute!`](@ref) function on each iteration of an algorithm.
The statistics are stored in the `records` field inside the `Logbook`, which is a vector of records (`NamedTuples`).
This makes it easier to export as a [DataFrame](https://github.com/JuliaData/DataFrames.jl).

```@docs
compute!
```

The `compute!` function can be called either by providing a logbook to update, or a vector of `Logbook`s.
This is useful if that which you want to calculate depends on different data sources (e.g. some statistics are computed from fitness while some others use the population, etc.)

## Statistics at a glance

If you prefer to have a quick overview of your Logbook, you can do so using the `summarise` function:

```@docs
summarise
```

`summarise` will go through each of the statistics and present a summary and a Unicode plot:

```console
 mean_f 
max: -0.5333333333333333 
avg: -5.6193333333333335
median: -5.716666666666667 
min: -7.366666666666666
std: 1.0150625419575374
             ┌────────────────────────────────────────┐ 
           0 │▖                                       │ 
             │▐                                       │ 
             │▗                                       │ 
             │▐                                       │ 
             │ ▌                                      │ 
             │ ▌                                      │ 
             │ ▐▖                                     │ 
   mean_f    │  ▌                              ▐      │ 
             │  ▌         ▐  ▖                ▖▞▖     │ 
             │  ▐▄▖   ▗  ▖▐▌▖▙▐    █▌    ▗▖   █▌▌ ▖▗▚ │ 
             │  ▐▜█▗▖▙▛▟▐▜▘▙▜▐▐▖ █▌▌▚ ▖▗▗▌█ ▖▗█▌▌▐▙▐▐ │ 
             │   ▐▌███ █▌  █▝ ▘▙▟▝█▘▐▐▜▌▛▌██▀█▌▌▐▐▘▀ ▙│ 
             │   ▝▌▝▛█ ▝▘  ▜    ▘ ▐ ▝▌ ▘  ▘▜ ▀▘  ▀   █│ 
             │       ▐     ▐      ▝                   │ 
          -8 │                                        │ 
             └────────────────────────────────────────┘ 
              0                                    100  
                                 it                     
```
