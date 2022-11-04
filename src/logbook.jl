"""
    Logbook(S::LittleDict)

A log for statistics intended for use on every iteration of an algorithm.
The logbook is constructed from a `LittleDict` ordered dictionary which maps stat names
(strings) to callables, such that _statname_ ``i`` can be computed from
_callable_ ``i``.

The resulting `Logbook` contains:

- `S::LittleDict`: The ordered dict of stat names and callables
- `records::AbstractVector`: A vector of NamedTuples where each field is a statistic.
"""
mutable struct Logbook
	S::LittleDict{AbstractString, Function}
	records::AbstractVector

	function Logbook(S::LittleDict)
        thenames = join([":" * expr for expr in [k for k in keys(S)]], ", ")
		d = Vector{NamedTuple{eval(Meta.parse(thenames))}}()
		L = new(S,d)
		return L
	end
end

"""
    compute!(logger::Logbook, data::AbstractVector)

Computes statistics for `logger` using `data`, which is usually a vector of fitnesses.
All calculations are done in place, so `logger` will be updated.
"""
function compute!(logger::Logbook, data::AbstractVector)
    thenames = [s for s in keys(logger.S)]
    thefunctions = [f(data) for f in values(logger.S)]

	record = namedtuple(thenames, thefunctions)
	push!(logger.records, record)

    return nothing
end
