module EvoLPIslandsExt

using MPI
using EvoLP
using Random

import StatsBase: sample

# Island Model extensions

# Deme selectors
"""
    select(S_M::RandomDemeSelector, y)

Return a list of size `S_M.k` of random indices from a vector of fitnesses `y`.
Used inside [`drift`](@ref) to select individuals to be sent to another island.
"""
function EvoLP.select(S_M::EvoLP.RandomDemeSelector, y)
    n = length(y)
    return sample(1:n, S_M.k, replace=false, ordered=true)
end

"""
    select(S_M::WorstDemeSelector, y)

Return the indices of the `S_M.k`-worst fitnesses in `y`.
Used inside [`drift`](@ref) to select individuals to be sent to another island.
"""
function EvoLP.select(S_M::EvoLP.WorstDemeSelector, y)
    worst = partialsortperm(y, 1:S_M.k; rev=true)
    return sort(worst)
end

# Migration operators

"""
    drift(S_M::DemeSelector, population, y, dest; comm=MPI.COMM_WORLD)

Select and send individuals from `population` to the `dest` island,
according to the deme selector `S_M` and considering their fitnesses `y`.

Returns a 2-tuple containing the sent deme, and its `MPI_Request`.
"""
function EvoLP.drift(S_M::EvoLP.DemeSelector, population, y, dest; comm=MPI.COMM_WORLD)
    M = Vector{Vector{Float64}}(undef, S_M.k)
    #select here
    chosen = EvoLP.select(S_M, y)
    for i in eachindex(chosen)
        M[i] = population[chosen[i]]
    end
    encoded_M = reduce(vcat, M)
    #MPI SEND TO DESTINATION
    s_req = MPI.Send(encoded_M, comm; dest=dest)
    return M, s_req
end

"""
    strand(S_M::DemeSelector, d, src; comm=MPI.COMM_WORLD)

Receive `d`-dimensional individuals from `src`.
The deme selector `S_M` is used to decode the received information.

Returns a 2-tuple containing the received deme, and its `MPI_Request`.
"""
function EvoLP.strand(S_M::EvoLP.DemeSelector, d, src; comm=MPI.COMM_WORLD)
    #MPI RECEIVE FROM SOURCE
    encoded_M = Array{Float64}(undef, S_M.k * d)
    r_req = MPI.Recv!(encoded_M, comm; source=src)
    M = []
    for i in 1:d:length(encoded_M)
        push!(M, encoded_M[i:i+d-1])
    end
    return M, r_req
end

"""
    reinsert!(population, y, R_M::DemeSelector, M)

(Re)insert a deme `M` into the `population`, according to reinsertion criterion
provided by the `R_M` deme selector, and the population's fitnesses `y`.

The new individuals will be appended into `population`.

Returns the indices of the deme that must be deleted.
"""
function EvoLP.reinsert!(population, y, R_M::EvoLP.DemeSelector, M)
    replaced = select(R_M, y)  # get indices
    append!(population, M)
    return replaced
end

# Island GA

"""
function islandGA(
    logbook::Logbook,
    f::Function,
    population::AbstractVector,
    max_it::Integer,
    S_P::EvoLP.Selector,
    X::EvoLP.Recombinator,
    Mut::EvoLP.Mutator,
    μ::Integer,
    S_M::DemeSelector,
    R_M::DemeSelector,
    dest::Integer,
    src::Integer,
    comm::MPI.COMM_WORLD)

Generational genetic algorithm with islands.

## Arguments
- `logbook::Logbook`: to save Statistics
- `f::Function`: objective function to **minimise**
- `population::AbstractVector`: a list of vector individuals
- `max_it::Integer`: number of iterations
- `S_P::ParentSelector`: one of the available [`ParentSelector`](@ref)
- `X::Recombinator`: one of the available [`Recombinator`](@ref)
- `Mut::Mutator`: one of the available [`Mutator`](@ref)
- `μ::Integer`: migration rate (in number of iterations)
- `S_M::DemeSelector`: selection policy. One of the available [`DemeSelector`](@ref)
- `R_M::DemeSelector`: replacement policy. One of the available [`DemeSelector`](@ref)
- `dest::Integer`: ID of destination island
- `src::Integer`: ID of source island
- `comm::MPI.Comm`: an MPI communicator. Usually MPI.COMM_WORLD.
"""
function EvoLP.islandGA(
    logbook::Logbook,
    f::Function,
    population::AbstractVector,
    max_it::Integer,
    S_P::EvoLP.Selector,
    X::EvoLP.Recombinator,
    Mut::EvoLP.Mutator,
    μ::Integer,
    S_M::EvoLP.DemeSelector,
    R_M::EvoLP.DemeSelector,
    src::Integer,
    dest::Integer,
    comm::MPI.Comm
)
    n = length(population)
    d = length(population[1])
    fitnesses = Vector{Float64}(undef, n)

	runtime = @elapsed for i in 1:max_it  # main loop
		parents = [select(S_P, f.(population)) for _ in eachindex(population)] # O(max_it * n)
		offspring = [cross(X, population[p[1]], population[p[2]]) for p in parents]
		population .= mutate.(Ref(Mut), offspring) # whole population is replaced

        fitnesses = f.(population) # O(max_it * n)

        if i % μ == 0  # migration time
            # Migration
            # 1. Select, encode and send deme
            _, s_req = EvoLP.drift(S_M, population, fitnesses, dest; comm=MPI.COMM_WORLD)
            # 2. Receive and decode deme
            M, r_req = EvoLP.strand(S_M, d, src; comm=MPI.COMM_WORLD)
            # 3. Append new deme into population
            fated = EvoLP.reinsert!(population, fitnesses, R_M, M)
            # 4. Delete old deme
            deleteat!(population, fated)
            deleteat!(fitnesses, fated)
            # 6. Evaluate new deme
            append!(fitnesses, f.(M))  # O(max_it / μ * S_M.k)
            # 7. Wait until every island has finished
            MPI.Barrier(comm)
        end
        compute!(logbook, fitnesses)  # Save stats
	end

    # xi, f(xi)
    best_i = argmin(fitnesses)
    best = population[best_i]
	n_evals = 2 * max_it * n

    # result of this island!
	return Result(fitnesses[best_i], best, population, max_it, n_evals, runtime)
end

end # module
