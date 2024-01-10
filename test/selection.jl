using EvoLP
using Test
using StableRNGs

myrng = StableRNG(123)
fits = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

@info "Testing Selectors"
@testset verbose = true "Selector test" begin
    @testset "Tournament Selector" begin
        T = TournamentSelector(5)
        s = select(T, fits; rng=myrng) # randperm twice = [1, 1]
        @test s == [1, 1]
        @test length(s) == 2  # check length of return
    end

    @testset "Truncation Selector" begin
        T = TruncationSelector(5)
        s = select(T, fits; rng=myrng) # rand(1:5, 2) = [2, 2]
        @test s == [2, 2]
        @test length(s) == 2
    end
end
