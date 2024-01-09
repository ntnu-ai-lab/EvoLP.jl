# Deprecated functionality will be here until removed in a major release

using Base: @deprecate, @deprecate_binding, depwarn

# BEGIN EvoLP 2.X.Y deprecations

# testfunctions.jl

"""
    circle(x)

!!! warning "Deprecated from EvoLP 1.3"
    This test function will be **deprecated** in a future major release.

The **circle** function is a multiobjective test function, given by

```math
f(x) = \\begin{bmatrix}
        1 - r\\cos(\\theta) \\\\
        1 - r\\sin(\\theta)
        \\end{bmatrix}
```

where ``\\theta=x_1`` and ``r`` is obtained by

```math
r = \\frac{1}{2} + \\frac{1}{2} \\left(\\frac{2x_2}{1+x_2^2}\\right)
```
"""
@inline @fastmath function circle(x)
    Base.deepwarn(
        "The `circle` function will be removed from EvoLP in a future release." *
        "It may be added back when multiobjective support is added."
    )
    θ = first(x)
    r = 0.5 + 0.5 * (2 * x[2] / (1 + x[2]^2))
    y1 = 1 - r * cos(θ)
    y2 = 1 - r * sin(θ)

    return [y1, y2]
end

"""
    flower(x; a=1, b=1, c=4)

!!! warning "Deprecated from EvoLP 1.3"
    This function will be **deprecated** in a future major release.

The **flower** function is a two-dimensional test function with flower-like contour lines
coming out from the origin. Typically, optional parameters are set at ``a=1``, ``b=1`` and
``c=4``. The function is minimised near the origin, although it does not have a global
minimum due to `atan` bein undefined at ``[0, 0]``.

```math
f(x) = a\\lVert\\mathbb{x}\\rVert + b \\sin(c\\arctan(x_2, x_1))
```
"""
@inline function flower(x; a=1, b=1, c=4)
    Base.deepwarn("The `flower` function will be removed from EvoLP in a future release.")
    return @fastmath a * norm(x) + b * sin(c * atan(x[2], x[1]))
end

# selection.jl

# Selection Method is no more
@deprecate_binding SelectionMethod Selector

#|--- Tournament Selection ---|

function TournamentSelectionGenerational(t)
    depwarn(
        "The _Generational_ selectors will be deprecated in a future release. " *
        "Please use `TournamentSelector(t)` instead of `TournamentSelectionGenerational(t)` " *
        "and update your algorithm to use it for each individual in the population.",
        :TournamentSelectionGenerational,
    )
    return TournamentSelector(t)
end

function TournamentSelectionSteady(t)
    depwarn(
        "The `TournamentSelectionSteady` type will be deprecated in a future release. " *
        "Please use `TournamentSelector(k)` instead.",
        :TournamentSelectionSteady,
    )
    return TournamentSelector(t)
end

#|--- Truncation Selection ---|

function TruncationSelectionSteady(k)
    depwarn(
        "The `TruncationSelectionSteady` type will be deprecated in a future release. " *
        "Please use `TruncationSelector(k)` instead.",
        :TournamentSelectionSteady,
    )
    return TruncationSelector(k)
end

function TruncationSelectionGenerational(k)
    depwarn(
        "The _Generational_ selectors will be deprecated in a future release. " *
        "Please use `TruncationSelector(k)` instead of `TruncationSelectionGenerational(k)` " *
        "and update your algorithm to use it for each individual in the population.",
        :TruncationSelectionGenerational,
    )
    return TruncationSelector(k)
end

#|--- Roulette Wheel Selection ---|

function RouletteWheelSelectionSteady()
    depwarn(
        "The `RouletteWheelSelectionSteady` type will be deprecated in a future release. " *
        "Please use `RouletteWheelSelector()` instead.",
        :RouletteWheelSelectionSteady,
    )
    return RouletteWheelSelector()
end

function RouletteWheelSelectionGenerational()
    depwarn(
        "The _Generational_ selectors will be deprecated in a future release. " *
        "Please use `RouletteWheelSelector()` instead of `RouletteWheelSelectionGenerational()` " *
        "and update your algorithm to use it for each individual in the population.",
        :RouletteWheelSelectionGenerational,
    )
    return RouletteWheelSelector()
end

#|--- Rank Based Selection ---|

function RankBasedSelectionSteady()
    depwarn(
        "The `RankBasedSelectionSteady` type will be deprecated in a future release. " *
        "Please use `RankBasedSelector()` instead.",
        :RankBasedSelectionSteady,
    )
    return RankBasedSelector()
end

function RankBasedSelectionGenerational()
    depwarn(
        "The _Generational_ selectors will be deprecated in a future release. " *
        "Please use `RankBasedSelector()` instead of `RankBasedSelectionGenerational()` " *
        "and update your algorithm to use it for each individual in the population.",
        :RankBasedSelectionGenerational,
    )
    return RankBasedSelector()
end

# mutation.jl

# Mutation Method is no more
@deprecate_binding MutationMethod Mutator

# |--- Bitwise Mutation ---|

function BitwiseMutation(λ)
    depwarn(
        "The `BitwiseMutation` type will be deprecated in a future release. " *
        "Please use `BitwiseMutator(λ)` instead.",
        :BitwiseMutation,
    )
    return BitwiseMutator(λ)
end

# |--- Gaussian Mutation ---|

function GaussianMutation(σ)
    depwarn(
        "The `GaussianMutation` type will be deprecated in a future release. " *
        "Please use `GaussianMutator(σ)` instead.",
        :GaussianMutation,
    )
    return GaussianMutator(σ)
end

# |--- Insert Mutation ---|

function InsertMutation()
    depwarn(
        "The `InsertMutation` type will be deprecated in a future release. " *
        "Please use `InsertionMutator()` instead.",
        :InsertMutation,
    )
    return InsertionMutator()
end

# |--- Inversion Mutation ---|

function InversionMutation()
    depwarn(
        "The `InversionMutation` type will be deprecated in a future release. " *
        "Please use `InversionMutator()` instead.",
        :InversionMutation,
    )
    return InversionMutator()
end

# |--- Scramble Mutation ---|

function ScrambleMutation()
    depwarn(
        "The `ScrambleMutation` type will be deprecated in a future release. " *
        "Please use `ScrambleMutator()` instead.",
        :ScrambleMutation,
    )
    return ScrambleMutator()
end

# |--- Swap Mutation ---|

function SwapMutation()
    depwarn(
        "The `SwapMutation` type will be deprecated in a future release. " *
        "Please use `SwapMutator()` instead.",
        :SwapMutation,
    )
    return SwapMutator()
end

# crossover.jl

# Crossover Method is no more
@deprecate_binding CrossoverMethod Recombinator

# |--- Single Point Crossover ---|

function SinglePointCrossover()
    depwarn(
        "The `SinglePointCrossover` type will be deprecated in a future release. " *
        "Please use `SinglePointRecombinator()` instead.",
        :SinglePointCrossover,
    )
    return SinglePointRecombinator()
end

# |--- Two Point Crossover ---|

function TwoPointCrossover()
    depwarn(
        "The `TwoPointCrossover` type will be deprecated in a future release. " *
        "Please use `TwoPointRecombinator()` instead.",
        :TwoPointCrossover,
    )
    return TwoPointRecombinator()
end

# |--- Uniform Crossover ---|

function UniformCrossover()
    depwarn(
        "The `UniformCrossover` type will be deprecated in a future release. " *
        "Please use `UniformRecombinator()` instead.",
        :UniformCrossover,
    )
    return UniformRecombinator()
end

# |--- Interpolation Crossover ---|

function InterpolationCrossover(λ)
    depwarn(
        "The `InterpolationCrossover` type will be deprecated in a future release. " *
        "Please use `InterpolationRecombinator(λ)` instead.",
        :InterpolationCrossover,
    )
    return InterpolationRecombinator(λ)
end

# |--- Order One Crossover ---|

function OrderOneCrossover()
    depwarn(
        "The `OrderOneCrossover` type will be deprecated in a future release. " *
        "Please use `OX1Recombinator()` instead.",
        :OrderOneCrossover,
    )
    return OX1Recombinator()
end

# algorithms

# swarm.jl

@deprecate PSO(logger::Logbook, f::Function, population::Vector{Particle}, k_max::Integer; w=1, c1=1, c2=1) PSO!(logger::Logbook, f::Function, population::Vector{Particle}, k_max::Integer; w=1, c1=1, c2=1)

# ea.jl

@deprecate oneplusone(logger::Logbook, f::Function, ind::AbstractVector, k_max::Integer, M::Mutator) oneplusone!(logger::Logbook, f::Function, ind::AbstractVector, k_max::Integer, M::Mutator)

# ga.jl

@deprecate GA(logbook::Logbook, f::Function, population::AbstractVector, k_max::Integer, S::ParentSelector, C::Recombinator, M::Mutator) GA!(logbook::Logbook, f::Function, population::AbstractVector, k_max::Integer, S::ParentSelector, C::Recombinator, M::Mutator)
@deprecate GA(notebooks::Vector{Logbook}, f::Function, population::AbstractVector, k_max::Integer, S::ParentSelector, C::Recombinator, M::Mutator) GA!(notebooks::Vector{Logbook}, f::Function, population::AbstractVector, k_max::Integer, S::ParentSelector, C::Recombinator, M::Mutator)

    # END EvoLP 2.X.Y deprecations
