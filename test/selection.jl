using EvoLP
using Test
using StableRNGs

myrng = StableRNG(123)
fits = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

@info "Testing selectors"
@testset verbose = true "Parent selector test" begin
    @testset "Tournament Selector" begin
        T = TournamentSelector(5)
        s = select(T, fits; rng = myrng) # randperm twice = [1, 1]
        @test s == [1, 1]
        @test length(s) == 2  # check length of return
    end

    @testset "Truncation Selector" begin
        T = TruncationSelector(5)
        s = select(T, fits; rng = myrng) # rand(1:5, 2) = [2, 2]
        @test s == [2, 2]
        @test length(s) == 2
    end

    @testset "Roulette Wheel Selector" begin
        R = RouletteWheelSelector()
        s = select(R, fits; rng = myrng) # rand(1:10, 2) = [6, 2]
        @test s == [6, 2]
        @test length(s) == 2
    end

    @testset "Rank based Selector" begin
        R = RankBasedSelector()
        s = select(R, fits; rng = myrng) # rand(1:10, 2) = [5, 4]
        @test s == [5, 4]
        @test length(s) == 2
    end

    @testset "Uniform Selector" begin
        myrng = StableRNG(42) # rand(1:10, 2) = [2, 9]
        S = UniformSelector()
        s = select(S, fits; rng = myrng)
        @test s == [2, 9]
        @test length(s) == 2
    end
end;

@testset verbose = true "Survival selector test" begin
    y_μ = [0.1, 0.2, 0.5, 0.8, 0.9]  # Parents fx
    y_λ = [0.05, 0.15, 0.3, 0.4, 0.7, 0.85, 0.95, 0.99]  # offspring fx
    
    @testset "Comma Selector (μ, λ)" begin
        S = CommaSelector(3)
        s = select(S, y_λ)

        @test length(s) == 3
        @test s == [1, 2, 3]  # first three are the smallest
    end

    @testset "Plus Selector (μ+λ)" begin
        S = PlusSelector(3)
        s = select(S, y_μ, y_λ)

        # y_μ and y_λ are concatenated as [y_μ] : [yλ]
        # best are 0.05 (ix 6), 0.1 (ix 1), 0..15 (ix 7)

        @test length(s) == 3
        @test s == [6, 1, 7]
    end
end
