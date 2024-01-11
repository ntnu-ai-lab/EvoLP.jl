using EvoLP
using Test
using StableRNGs

myrng = StableRNG(123)
fits = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

@info "Testing deprecated selectors"
@testset verbose = true "Deprecated selector test" begin
    @testset "Tournament" begin
        T = TournamentSelectionSteady(5)
        s = select(T, fits; rng=myrng) # randperm twice = [1, 1]
        @test s == [1, 1]
        @test length(s) == 2  # check length of return
    end

    @testset "Truncation" begin
        T = TruncationSelectionSteady(5)
        s = select(T, fits; rng=myrng) # rand(1:5, 2) = [2, 2]
        @test s == [2, 2]
        @test length(s) == 2
    end

    @testset "Roulette Wheel" begin
        R = RouletteWheelSelectionSteady()
        s = select(R, fits; rng=myrng) # rand(1:10, 2) = [6, 4]
        @test s == [6, 4]
        @test length(s) == 2
    end

    @testset "Rank based" begin
        R = RankBasedSelectionSteady()
        s = select(R, fits; rng=myrng) # rand(1:10, 2) = [2, 8]
        @test s == [2, 8]
        @test length(s) == 2
    end
end;

myrng = StableRNG(123)

@info "Testing deprecated mutators"
@testset verbose = true "Deprecated mutator test" begin
    @testset "Bitwise" begin
        M = BitwiseMutation(1/8)
        x = binary_vector_pop(1, 8, rng=myrng)[1]  # 1. randpop
        c = mutate(M, x; rng=myrng) # 2. rand(myrng, 8) results in flipping 3rd bit
        @test c == Bool[1, 1, 1, 1, 0, 1, 0, 0]
    end

    @testset "Gaussian" begin
        G = GaussianMutation(0.5)
        x = [0, 0, 0, 0, 0, 0, 0, 0]
        c = mutate(G, x; rng=myrng) # 3. randn(myrng, 8) results in the following vector
        v = [
            -0.9671975288083468,
            -1.3641880343579902,
            -0.9995722599695167,
            -1.4919831226368483,
            -1.3103156411991586,
            0.9562355731126654,
            2.0446617634637434,
            1.6344585127632065,
        ]
        @test c ≈ x + v * 0.5 atol=5e-8
    end

    @testset "Swap" begin
        S = SwapMutation()
        x = [1, 2, 3, 4, 5, 6, 7, 8]
        c = mutate(S, x; rng=myrng)  # sample(myrng, 1:8, 2, replace=false) == 3, 7
        @test c == [1, 2, 7, 4, 5, 6, 3, 8]
    end

    @testset "Insert" begin
        I = InsertMutation()
        x = [1, 2, 3, 4, 5, 6, 7, 8]
        c = mutate(I, x; rng=myrng) # sample(myrng, 1:8, 2, replace=false, ordered=true)
        # results in [4, 6]
        @test c == [1, 2, 3, 4, 6, 5, 7, 8]
    end

    @testset "Scramble" begin
        S = ScrambleMutation()
        x = [1, 2, 3, 4, 5, 6, 7, 8]
        c = mutate(S, x; rng=myrng)  # sample(myrng, 1:8, 2, replace=false, ordered=true)
        # results in [3, 7]
        # shuffle!(myrng, selectedpart) == [6, 5, 4, 7, 3]
        @test c == [1, 2, 6, 5, 4, 7, 3, 8]
    end

    @testset "Inversion" begin
        I = InversionMutation()
        x = [1, 2, 3, 4, 5, 6, 7, 8]
        c = mutate(I, x; rng=myrng)  # sample(myrng, 1:8, 2, replace=false, ordered=true)
        # results in [5, 6]
        @test c == [1, 2, 3, 4, 6, 5, 7, 8]
    end
end;

myrng = StableRNG(123);

@info "Testing deprecated recombinators"
@testset verbose = true "Deprecated crossover test" begin
    @testset "Single point crossover" begin
        S = SinglePointCrossover()
        a = [0, 0, 0, 0, 1, 1, 1, 1]
        b = [1, 1, 1, 1, 0, 0, 0, 0]
        c = cross(S, a, b, rng=myrng) # 1. rand(myrng, 1:n) == 4
        @test c == [0, 0, 0, 0, 0, 0, 0, 0]
        @test length(c) == length(a) # Check length of the offspring
    end

    @testset "Two point crossover" begin
        T = TwoPointCrossover()
        a = [0, 0, 0, 0, 1, 1, 1, 1]
        b = [1, 1, 1, 1, 0, 0, 0, 0]
        c = cross(T, a, b, rng=myrng)  # 2. rand(myrng, 1:n, 2) == [7, 8]
        @test c == [0, 0, 0, 0, 1, 1, 1, 0]
        @test length(c) == length(a) # Check length of the offspring
    end

    @testset "Uniform crossover" begin
        U = UniformCrossover()
        a = [0, 0, 0, 0, 1, 1, 1, 1]
        b = [1, 1, 1, 1, 0, 0, 0, 0]
        c = cross(U, a, b, rng=myrng) # 3. rand(myrng, 8) results in bbbaaaba
        @test c == [1, 1, 1, 0, 1, 1, 0, 1]
        @test length(c) == length(a) # Check length of the offspring
    end

    @testset "Interpolation crossover" begin
        L = InterpolationCrossover(0.3)
        a = [2, 3, 4]
        b = [1, 2, 3]
        c = cross(L, a, b)
        @test c == 0.7 * a + 0.3 * b  # Check that interpolation is correct
        @test length(c) == length(a) # Check length of the offspring
    end

    @testset "OX1 crossover" begin
        O = OrderOneCrossover()
        a = [1, 2, 3, 4, 5, 6, 7, 8]
        b = [8, 7, 6, 5, 4, 3, 2, 1]
        c = cross(O, a, b; rng=myrng)
        # 4. sample(myrng, 2:7, 2 replace=false, ordered=true) == [2, 7]
        @test c == [8, 2, 3, 4, 5, 6, 7, 1]
        @test length(c) == length(a) # Check length of offspring
    end
end;
