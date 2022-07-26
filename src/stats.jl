abstract type EvoStat end

mutable struct meanFit <: EvoStat
    data
    meanFit() = new(Vector{Real}())
end

mutable struct bestFit <: EvoStat
    data
    bestFit() = new(Vector{Real}())
end

function computeStat!(S::meanFit, fits)
    push!(S.data, Statistics.mean(fits))
end

function computeStat!(S::bestFit, fits)
    push!(S.data, minimum(fits))
end
