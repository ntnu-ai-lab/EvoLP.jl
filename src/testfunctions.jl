"""
Optimisation test functions
"""

# Pseudo boolean functions

"""
    jumpk(x; k=6)

The **JumpK** function is a modification of the [`onemax`](@ref) function, with a valley of
size ``k`` right before the maximum. The only way for a hill climber to reach the maximum
is with a _perfect flip_ of ``k`` bits, which is considered extremely difficult.

```math
\\text{JUMP}_k(x) = \\begin{cases}
\\lVert{x}\\rVert_1 & \\quad \\text{if } \\lVert x \\rVert_1 \\in [0..n-k] \\cup \\{n\\},\\\\
-\\lVert x \\rVert_1 & \\quad \\text{otherwise}
\\end{cases}
```

where ``\\lVert x \\rVert_1 = \\sum_{i=1}^n x_i`` is the number of 1-bits in
``x \\in \\{0, 1\\}^n``.
"""
function jumpk(x; k=6)::Int
    s = sum(x)
    n = length(x)
    return s ∈ (1:n-k) ∪ n ? s : -s
end


"""
The **LeadingOnes** function returns the number of _uninterrupted_ ones from the start of
the chromosome. The maximum is achieved with ``n`` ones, but the landscape is a bit more
difficult to traverse.

```math
\\text{LO}(\\mathbf{x}) = \\sum_{i=1}^n \\prod_j^i x_j
```
"""
@inline function leadingones(x)::Int
    s = 0
    m = 1
    @inbounds for val in x
        m *= val
        s += m
    end
    return s
end


"""
The **OneMax** function returns the sum of the individual.
For an individual of length ``n``, maximum is achieved with ``n`` ones.

```math
\\text{OneMax}(\\mathbf{x}) = \\sum_{i=1}^n x_i
```
"""
onemax(x) = sum(x)

# Real-valued functions


"""
    ackley(x; a=20, b=0.2, c=2π)

**Ackley's** benchmark function. Global minimum is at the origin, with value of 0.
Parameters are typically ``a=20``, ``b=0.2``, and ``c=2\\pi``.

```math
f(x) = -a \\exp\\left(-b\\sqrt{\\frac{1}{d} \\sum_{i=1}^d x_i^2}\\right)
- \\exp\\left(\\frac{1}{d} \\sum_{i=1}{d} \\cos (cx_i) \\right) + a + \\exp(1)
```
"""
@inline function ackley(x; a=20, b=0.2, c=2π)
    d = length(x)
    return -a * exp(-b * sqrt(sum(x .^ 2) / d)) -
           exp(sum(cos.(c * xi) for xi in x) / d) + a + exp(1)
end

"""
The **Booth** function is a 2-dimensional quadratic function with global minimum
``x^* = [1, 3]`` and optimal value ``f(x^*) = 0``.

```math
f(x) = (x_1 + 2x_2 - 7)^2 + (2 x_1 + x_2 - 5)^2
```
"""
@inline booth(x) = (x[1] + 2 * x[2] - 7)^2 + (2 * x[1] + x[2] - 5)^2


"""

    branin(x; a=1, b=5.1/(4π^2), c=5/π, r=6, s=10, t=1/(8π))

The **Branin** (a.k.a. Branin-Hoo) function has six optional parameters, and features
multiple global minima. Some of them are at ``x^* = [-\\pi, 12.275]``,
``x^* = [\\pi, 2.275]``, ``x^* = [3\\pi, 2.475]`` and ``x^* = [5\\pi, 12.875]``,
with ``f(x^*) \\approx 0.397887``.

```math
f(x) = a(x_2 - bx_1^2 + cx_1 - r)^2 + s(1 - t)\\cos(x_1) + s
```
"""
@inline function branin(x; a=1, b=5.1 / (4π^2), c=5 / π, r=6, s=10, t=1 / (8π))
    return a * (x[2] - b * x[1]^2 + c * x[1] - r)^2 + s * (1 - t) * cos(x[1]) + s
end


"""
    eggholder(x::Vector{T} where {T<:Real})

A ``d``-dimensional function which draws its name due to its highly rugged landscape.
For the 2-dimensional version, the optimum ``f(\\mathbf{x}^*)\\approx-959.64066``
with optimiser ``\\mathbf{x}^* = (512, 404.231805)``.
"""
function eggholder(x::Vector{T} where {T<:Real})
    n = length(x)
    return -sum([(x[i+1]+47) * sin(sqrt(abs(x[i+1] + 47 + x[i]/2))) +
        x[i] * sin(sqrt(abs(x[i] - (x[i+1] + 47)))) for i in 1:n-1])
end


"""
    michalewicz(x; m=10)

The **Michalewicz** function is a ``d``-dimensional function with several steep valleys,
where `m` controls the steepness. `m` is usually set at 10. For 2 dimensions,
``x^* = [2.20, 1.57]``, with ``f(x^*) = -1.8011``.

```math
f(x) = -\\sum_{i=1}^{d}\\sin(x_i) \\sin^{2m}\\left(\\frac{ix_i^2}{\\pi}\\right)
```
"""
@inline function michalewicz(x; m=10)
    return -sum(sin(v) * sin(i * v^2 / π)^(2m) for (i, v) in enumerate(x))
end


"""
    rana(x::Vector{T} where {T<:Real})

A ``d``-dimensional function which is highly rugged and symmetrical.
For ``d=2``, the global minimum ``f(\\mathbf{x}^*)\\approx -511.73288 with
optimiser ``\\mathbf{x}^* = `(-488.632577, 512)`.
"""
@inline function rana(x::Vector{T} where {T<:Real})
    n = length(x)
    return sum([x[i] * cos(sqrt(abs(x[i+1] + x[i] + 1))) * sin(sqrt(abs(x[i+1] - x[i] + 1))) +
        (1 + x[i+1]) * sin(sqrt(abs(x[i+1] + x[i] + 1))) * cos(sqrt(abs(x[i+1] - x[i] + 1)))
        for i in 1:n-1])
end


"""
    rosenbrock(x; b=100)

!!! compat "Changed since EvoLP 1.3"
    This is the ``d``-dimensional Rosenbrock function. In previous releases, it was 2d only
    and had an additional keyword argument `a`.

    Update your workflow accordingly.

The ``d``-dimensional **Rosenbrock** _banana_ benchmark function. With ``b=100``,
minimum is at ``f([1, \\dots, 1]) = 0``

```math
f(x) = \\sum_{i=1}^{d-1} \\left[b(x_{i+1} - x_i^2)^2 + (x_i - 1)^2 \\right]
```
"""
@inline function rosenbrock(x; b=100)
    n = length(x)
    return sum([b * (x[i+1] - x[i]^2)^2 + (x[i] - 1)^2 for i in 1:n-1])
end


"""
    wheeler(x, a=1.5)

The **Wheeler's ridge** is a 2-d function with a single global minimum in a curved peak.
With ``a`` (by default at 1.5) ``x^* = [1, 1.5]``, with ``f(x^*) = -1``.

```math
f(x) = - \\exp(- (x_1 x_2 - a)^2 - (x_2 - a)^2 )
```
"""
@inline wheeler(x, a=1.5) = -exp(-(x[1] * x[2] - a)^2 - (x[2] - a)^2)
