"""
    Logbook()
    Logbook(S::LittleDict)

A log for statistics intended for use on every iteration of an algorithm.
The logbook is constructed from a `LittleDict` ordered dictionary which maps stat names
(strings) to callables, such that _statname_ ``i`` can be computed from
_callable_ ``i``.

The resulting `Logbook` contains:

- `S::LittleDict`: The ordered dict of stat names and callables
- `records::AbstractVector`: A vector of NamedTuples where each field is a statistic.

If no argument is passed, the logbook is constructed with a set of commonly statistics such
as minimum, mean, median, maximum and standard deviation; in that order.
"""
mutable struct Logbook
    S::LittleDict{AbstractString,Function}
    records::AbstractVector

    function Logbook(S::LittleDict)
        fnames = [k for k in keys(S)]
        d = Vector{namedtuple(fnames)}()
        return new(S, d)
    end

    function Logbook()
        fnames = [
            "min_f",
            "mean_f",
            "median_f",
            "max_f",
            "std",
        ]
        callables = [
            minimum,
            mean,
            median,
            maximum,
            std,
        ]
        S = LittleDict(fnames, callables)
        d = Vector{namedtuple(fnames)}()
        return new(S, d)
    end
end

"""
    compute!(logger::Logbook, data::AbstractVector)
    compute!(notebooks::Vector{Logbook}, data::Vector{AbstractVector})

Computes statistics for `logger` (or a vector of `logger`s) using `data`,
which is usually a vector of fitnesses.
All calculations are done in place, so the `logger` records will be updated.
"""
function compute!(logger::Logbook, data::AbstractVector)
    fnames = [s for s in keys(logger.S)]
    callables = [f(data) for f in values(logger.S)]

    record = namedtuple(fnames, callables)
    push!(logger.records, record)

    return nothing
end

function compute!(notebooks::Vector{Logbook}, data::AbstractVector)
    for (logger, y) in zip(notebooks, data)
        fnames = [s for s in keys(logger.S)]
        callables = [f(y) for f in values(logger.S)]

        record = namedtuple(fnames, callables)
        push!(logger.records, record)
    end

    return nothing
end


"""
    summarise(logger::Logbook)
    summarise(notebooks::Logbook)

Print and plot descriptive statistics for a given `logger` (or a vector of `logger`s).
"""
function summarise(logger::Logbook)
    n = length(logger.records)
    for (i, eachstat) in enumerate(keys(logger.S))
        data = [logger.records[j][i] for j in 1:n]
        printstyled("\n $(eachstat) \n"; bold=true)
        print("max: $(maximum(data)) \n" *
              "avg: $(mean(data))\n" *
              "median: $(median(data)) \n" *
              "min: $(minimum(data))\n" *
              "std: $(std(data))\n")
        plt = lineplot(data;
            xlabel="it", ylabel=eachstat)
        print(plt)
    end

    return nothing
end

function summarise(notebooks::Vector{Logbook})
    for eachnb in notebooks
        n = length(eachnb.records)
        for (i, eachstat) in enumerate(keys(eachnb.S))
            data = [eachnb.records[j][i] for j in 1:n]
            printstyled("\n $(eachstat) \n"; bold=true)
            print("max: $(maximum(data)) \n" *
                  "avg: $(mean(data))\n" *
                  "median: $(median(data)) \n" *
                  "min: $(minimum(data))\n" *
                  "std: $(std(data))\n")
            plt = lineplot(data;
                xlabel="it", ylabel=eachstat)
            print(plt)
        end
    end

    return nothing
end
