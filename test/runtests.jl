using EvoLP
using Documenter
using Test

const testfiles = (
    "generators.jl",
    "crossover.jl",
    "mutation.jl",
    "benchmarks.jl"
)

@testset "EvoLP.jl" begin
    @testset "$file" for file in testfiles
        include(file)
    end

    @testset "Examples in docs" begin
        doctest(EvoLP)
    end
end;
