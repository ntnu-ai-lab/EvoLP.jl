using EvoLP
using Test


const testfiles =(
    "generators.jl",
    "crossover.jl",
    "mutation.jl",
)

@testset "EvoLP.jl" begin
    @testset "$file" for file in testfiles
        include(file)
    end
end;
