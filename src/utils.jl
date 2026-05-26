# Various utilities and metrics

# Bitstrings & binary utils

"""
    force_boolean(x::AbstractVector{Integer})

Convert an integer-based individual into a `BitArray`.
Most binary utilities are more efficient on `BitArray`s.
"""
function force_boolean(x::AbstractVector{<:Integer})
    return BitArray(x)
end

"""
    ind2dec(x::AbstractVector{Bool})

Return the decimal representation of a bitstring `x`.
"""
function ind2dec(x::AbstractVector{Bool})
    val = 0
    for bit in x
        # Shift current value left by 1 (multiply by 2) and add the new bit
        val = (val << 1) | bit
    end
    return val
end

"""
    ind2str(x::AbstractVector{Bool})

Convert a bitstring `x` into its textual representation.
"""
function ind2str(x::AbstractVector{Bool})
    return join(i ? '1' : 0 for i in x)
end

"""
    dec2ind(n::Int; pad::Int = 1)

Return the bitstring representation of an integer `n`, optionally padded
with zeros until reaching a size `pad`.
"""
function dec2ind(n::Int; pad::Int = 1)
    x = BitVector(undef, pad)

    for i in 1:pad
        # Shift the target bit to the end, isolate it, and evaluate as Bool
        x[i] = (n >> (pad - i)) & 1 == 1
    end

    return x
end

"""
    str2ind(x::String)

Convert a textual bitstring `x` to its boolean representation.
"""
function str2ind(x::String)
    return BitVector(i == '1' for i in x)
end

"""
    get_neighbourhood(x::AbstractVector{Bool})
    get_neighbourhood(n::Integer; pad=1)

Return all neighbours of an individual `x`.
If `x` is a bitstring, it returns the neighbourhood as bitstrings.
If `x` is a natural number, it returns integers (e.g., indices to extract from a sorted array)
"""
function get_neighbourhood(x::AbstractVector{Bool})
    n = length(x)
    naboer = Vector{BitVector}(undef, n)
    for i in 1:n
        nei = copy(x)
        nei[i] = !nei[i]
        naboer[i] = nei
    end

    return naboer
end

function get_neighbourhood(n::Integer; pad = 1)
    # XOR (⊻) of bit shifts from left to right
    return [n ⊻ (1 << i) for i in (pad - 1):-1:0]
end

"""
    get_neighbourhood_ixs(x::AbstractVector{Bool})

Return a list of the decimal representations of all neighbours of an individual `x`,
for example, to use as indices to extract from a sorted array or lookup table.
"""
function get_neighbourhood_ixs(x::AbstractVector{Bool})
    n = ind2dec(x)
    return get_neighbourhood(n; pad = length(x))
end


# Metrics

"""
    global_entropy(population::AbstractVector{AbstractVector{Bool}})

Returns the global Shannon entropy of the population, which is a measurement of how similar Boolean individuals are:

```math
\\text{H}(X) = - \\sum_{x \\in \\{0, 1\\}} p(x) \\log_2 p(x).
```
"""
function global_entropy(population::AbstractVector{<:AbstractVector{Bool}})
    m = length(population)
    n = length(first(population))

    n_ones = sum(count, population)

    p_ones = n_ones / (m * n)
    p_zeros = 1.0 - p_ones

    safe_xlogx(p) = p == 0.0 ? 0.0 : p * log2(p)

    return -(safe_xlogx(p_ones) + safe_xlogx(p_zeros))
end