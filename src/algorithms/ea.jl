# (1+1)-EA ------

"""
    oneplusone(f, ind, k_max, M)
    oneplusone(logger::Logbook, f, ind, k_max, M)

1+1 Evolutionary Algorithm.

# Arguments

- `f::Function`: objective function to **minimise**.
- `ind::AbstractVector`: individual to start the evolution.
- `k_max::Integer`: number of iterations.
- `M::Mutator`: one of the available [`Mutator`](@ref).

Returns a [`Result`](@ref).
"""
function oneplusone(f::Function, ind::AbstractVector, k_max::Integer, M::Mutator)
    fx = Inf  # works only on minimisation problems
    runtime = @elapsed for _ in 1:k_max
        c = mutate(M, ind)
        fx, fc = f(ind), f(c)
        if fc <= fx
            ind = c
            fx = fc
        end
    end

    n_evals = 2k_max

    return Result(fx, ind, [ind], k_max, n_evals, runtime)
end

# Logbook version
function oneplusone!(
        logger::Logbook, f::Function, ind::AbstractVector, k_max::Integer, M::Mutator
    )
    fx = Inf  # works only on minimisation problems
    runtime = @elapsed for _ in 1:k_max
        c = mutate(M, ind)
        fx, fc = f(ind), f(c)
        if fc <= fx  # O(2 * k_max)  # minimisation problem
            ind = c
            fx = fc
        end

        compute!(logger, [fx])
    end

    n_evals = 2k_max

    return Result(fx, ind, [ind], k_max, n_evals, runtime)
end


# (μ, λ)-EA ------

"""
    mucommalambda!(L, popset, f, μ, λ, M; kmax=1000, rng=Random.GLOBAL_RNG)
    mucommalambda!(popset, f, μ, λ, M; kmax=1000, rng=Random.GLOBAL_RNG)


Execute an in-place (μ, λ)-Evolutionary Strategy.

In this comma-selection algorithm, a parent population of size `μ` generates an offspring pool of size `λ` through uniform selection and mutation. The survival phase selects the `μ` fittest individuals strictly from the newly generated offspring to form the next generation.

This function modifies `popset` and the logbook `L` in place.

# Arguments:

- `L::Logbook`: an EvoLP [`Logbook`](@ref) to record statistics per generation.
- `popset::AbstractVector`: The initial population of `μ` individuals. Modified in place
- `f::Function`: The objective function to minimise.
- `μ::Int`: Parent population size.
- `λ::Int`: Offspring population size. Must be `λ ≥ μ`.
- `M::EvoLP.Mutator`: The mutation operator applied to generate offspring.

# Keyword Arguments

- `kmax::Int`: The maximum number of generations (iterations). Defaults to `1000`.
- `rng::AbstractRNG`: The random number generator for reproducibility.

# Returns
- A [`Result`](@ref) object containing the optimum, optimiser, and other execution statistics.
"""
function mucommalambda!(
        L,
        popset::AbstractVector,
        f::Function,
        μ::Int,
        λ::Int,
        M::EvoLP.Mutator;
        kmax::Int = 1000,
        rng::AbstractRNG = Random.GLOBAL_RNG
    )
    n_fcalls = 0
    k = 0
    fitnesses = zeros(Float64, μ)

    # Parent and Survivor selectors - (μ, λ)
    C = UniformSelector()
    S = CommaSelector(μ)

    newpopset = similar(popset, λ)
    newfitnesses = similar(fitnesses, λ)

    runtime = @elapsed for i in 1:kmax
        # sample λ individuals uniformly at random from the top μ individuals
        parent_ixs = select(C, fitnesses, λ; rng = rng)
        # newpopset = popset[parent_ixs]

        # create offspring by mutating the parent
        for (i, p_i) in enumerate(parent_ixs)
            newpopset[i] = mutate(M, popset[p_i]; rng = rng)
        end

        # evaluate offspring in place

        newfitnesses .= f.(newpopset)
        n_fcalls += λ

        # survivor selection: top μ individuals survive
        survivors = select(S, newfitnesses)

        # update population and fitness buffers in place
        popset .= newpopset[survivors]
        fitnesses .= newfitnesses[survivors]

        # log statistics
        compute!(L, fitnesses)
        k += 1
    end

    best_i = argmin(fitnesses)
    return Result(fitnesses[best_i], popset[best_i], popset, k, n_fcalls, runtime)
end

function mucommalambda!(
        popset::AbstractVector,
        f::Function,
        μ::Int,
        λ::Int,
        M::EvoLP.Mutator;
        kwargs...
    )
    return mucommalambda!(nothing, popset, f, μ, λ, M; kwargs...)
end

# (μ+λ)-EA ------

"""
    mupluslambda!(L, popset, f, μ, λ, M; kmax=1000, rng=Random.GLOBAL_RNG)
    mupluslambda!(popset, f, μ, λ, M; kmax=1000, rng=Random.GLOBAL_RNG)

Execute an in-place (μ + λ) Evolutionary Strategy.

In this plus-selection algorithm, a parent population of size `μ` generates an offspring pool of size `λ`. The survival phase selects the `μ` fittest individuals from the combined pool of both parents and offspring (size `μ + λ`), guaranteeing elitism.

This function modifies `popset` and the logbook `L` in place.

# Arguments
- `L::Logbook`: The logbook used to record fitness statistics per generation.
- `f::Function`: The objective function to minimize.
- `popset::AbstractVector`: The initial population of `μ` individuals. Modified in place.
- `μ::Int`: The parent population size.
- `λ::Int`: The offspring population size.
- `M::Mutator`: The mutation operator applied to generate offspring.

# Keyword Arguments
- `kmax::Int`: The maximum number of generations (iterations). Defaults to `1000`.
- `rng::AbstractRNG`: The random number generator for reproducibility.

# Returns
- A `Result` object containing the optimum, optimiser, and execution statistics.
"""
function mupluslambda!(
        L,
        popset::AbstractVector,
        f::Function,
        μ::Int,
        λ::Int,
        M::EvoLP.Mutator;
        kmax::Int = 1000,
        rng::AbstractRNG = Random.GLOBAL_RNG
    )
    n_fcalls = 0
    k = 0
    fitnesses = zeros(Float64, μ)

    pre_eval_runtime = @elapsed begin
        fitnesses .= f.(popset)
        n_fcalls += μ
    end

    # Parent and Survivor selectors - (μ, λ)
    C = UniformSelector()
    S = PlusSelector(μ)

    # pre-allocation of offspring buffers
    newpopset = similar(popset, λ)
    newfitnesses = similar(fitnesses, λ)

    # Pre-allocation of the combined survival phase
    next_pop = similar(popset, μ)
    next_fit = similar(fitnesses, μ)

    main_runtime = @elapsed for i in 1:kmax
        # sample λ individuals uniformly at random from the top μ individuals
        parent_ixs = select(C, fitnesses, λ; rng = rng)

        # create offspring by mutating the parent
        for (i, p_i) in enumerate(parent_ixs)
            newpopset[i] = mutate(M, popset[p_i]; rng = rng)
        end

        # evaluate offspring in place
        newfitnesses .= f.(newpopset)
        n_fcalls += λ

        # survivor selection: top μ individuals survive from BOTH pools
        survivors = select(S, fitnesses, newfitnesses)

        for (j, s_i) in enumerate(survivors)
            if s_i ≤ μ
                # the survivor was a parent
                next_pop[j] = popset[s_i]
                next_fit[j] = fitnesses[s_i]
            else
                # the survivor was an offspring
                next_pop[j] = newpopset[s_i - μ]
                next_fit[j] = newfitnesses[s_i - μ]
            end
        end

        # update population and fitness buffers in place
        popset .= next_pop
        fitnesses .= next_fit

        # log statistics
        compute!(L, fitnesses)
        k += 1
    end

    best_i = argmin(fitnesses)
    return Result(fitnesses[best_i], popset[best_i], popset, k, n_fcalls, pre_eval_runtime + main_runtime)
end

function mupluslambda!(
        popset::AbstractVector,
        f::Function,
        μ::Int,
        λ::Int,
        M::EvoLP.Mutator;
        kwargs...
    )
    return mupluslambda!(nothing, popset, f, μ, λ, M; kwargs...)
end
