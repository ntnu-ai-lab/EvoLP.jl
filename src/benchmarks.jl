"""
Benchmark functions
"""

# Pseudo boolean functions
"""
The **OneMax** function returns the sum of the individual.
For an individual of length ``n``, maximum is achieved with ``n`` ones.
```math
\\text{OneMax}(\\mathbf{x}) = \\sum_{i=1}^n x_i
```
"""
onemax(x) = sum(x)

"""
The **LeadingOnes** function returns the number of _uninterrupted_
ones from the start of the chromosome. The maximum is achieved with ``n`` ones,
but the landscape is a bit more difficult to traverse.
```math
\\text{LO}(\\mathbf{x}) = \\sum_{i=1}^n \\prod_j^i x_j
```
"""
function leadingones(x)::Int
    s = 0
    for i in 1:length(x)
        m = reduce(*, x[1:i])
        s += m
    end
    return s
end

"""
    jumpk(x; k=6)

The **JumpK** function is a modification of the [`onemax`](@ref) function,
with a valley of size ``k`` right before the maximum. The only way for a
hill climber to reach the maximum is with a _perfect flip_ of ``k`` bits,
which is considered extremely difficult.

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
    if s ∈ (1:n-k) ∪ n
        r = s
    else
        r = -s
    end
    return r
end

# Real-valued functions


"""
    ackley(x; a=20, b=0.2, c=2π)

Ackley's benchmark function.
Global minimum is at the origin, with optimal value of 0.
Parameters are typically ``a=20``, ``b=0.2``, and ``c=2\\pi``.

```math
f(x) = -a \\exp\\left(-b\\sqrt{\\frac{1}{d} \\sum_{i=1}^d x_i^2}\\right)
- \\exp\\left(\\frac{1}{d} \\sum_{i=1}{d} \\cos (cx_i) \\right) + a + \\exp(1)
```
"""
function ackley(x; a=20, b=0.2, c=2π)
    d = length(x)
    return -a * exp(-b * sqrt(sum(x.^2) / d)) -
            exp(sum(cos.(c * xi) for xi in x) / d) + a + exp(1)
end

"""
2-dimensional quadratic function with global minimum ``x^* = [1, 3]``
and optimal value ``f(x^*) = 0``.

```math
f(x) = (x_1 + 2x_2 - 7)^2 + (2 x_1 + x_2 - 5)^2
```
"""
booth(x) = (x[1] + 2*x[2] - 7)^2 + (2*x[1] + x[2] - 5)^2

"""
    michalewicz(x; m=10)

The Michalewicz function is a ``d``-dimensional function with several
steep valleys, where `m` controls the steepness. `m` is usually
set at 10. For 2 dimensions, ``x^* = [2.20, 1.57]``, with ``f(x^*) = -1.8011``.

```math
f(x) = -\\sum_{i=1}^{d}\\sin(x_i) \\sin^{2m}\\left(\\frac{ix_i^2}{\\pi}\\right)
```
"""
function michalewicz(x; m=10)
    return -sum(sin(v) * sin(i*v^2/π)^(2m) for (i, v) in enumerate(x))
end

"""
    rosenbrock(x; a=1, b=5)

Rosenbrock benchmark function.
With ``a=1`` and ``b=5``, minimum is at ``f([a, a^2]) = 0``

```math
f(x) = (a - x_1)^2 + b(x_2 - x_1^2)^2
```
"""
rosenbrock(x; a=1, b=5) = (a - x[1])^2 + b * (x[2] - x[1]^2)^2
