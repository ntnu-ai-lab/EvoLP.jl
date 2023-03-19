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

**Ackley's** benchmark function.
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
The **Booth** function is a 2-dimensional quadratic function with global minimum
``x^* = [1, 3]`` and optimal value ``f(x^*) = 0``.

```math
f(x) = (x_1 + 2x_2 - 7)^2 + (2 x_1 + x_2 - 5)^2
```
"""
booth(x) = (x[1] + 2*x[2] - 7)^2 + (2*x[1] + x[2] - 5)^2


"""

    branin(x; a=1, b=5.1/(4π^2), c=5/π, r=6, s=10, t=1/(8π))

The **Branin** (a.k.a. Branin-Hoo) function has six optional parameters, and features
multiple global minima. Some of them are at ``x^* = [-\\pi, 12.275]``, ``x^* = [\\pi, 2.275]``,
``x^* = [3\\pi, 2.475]`` and ``x^* = [5\\pi, 12.875]``, with ``f(x^*) \\approx 0.397887``.

```math
f(x) = a(x_2 - bx_1^2 + cx_1 - r)^2 + s(1 - t)\\cos(x_1) + s
```
"""
function branin(x; a=1, b=5.1/(4π^2), c=5/π, r=6, s=10, t=1/(8π))
    return a * (x[2] - b * x[1]^2 + c * x[1] - r)^2 + s * (1 - t) * cos(x[1]) + s
end

"""
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
function circle(x)
    θ = x[1]
    r = 0.5 + 0.5 * (2 * x[2] / (1 + x[2]^2))
    y1 = 1 - r * cos(θ)
    y2 = 1 - r * sin(θ)

    return [y1, y2]
end

"""
    flower(x; a=1, b=1, c=4)

The **flower** function is a two-dimensional test function with flower-like contour lines
coming out from the origin. Typically, optional parameters are set at ``a=1``, ``b=1`` and
``c=4``. The function is minimised near the origin, although it does not have a global
minimum due to `atan` bein undefined at ``[0, 0]``.

```math
f(x) = a\\lVert\\mathbb{x}\\rVert + b \\sin(c\\arctan(x_2, x_1))
```
"""
function flower(x; a=1, b=1, c=4)
    return a * norm(x) + b * sin(c * atan(x[2], x[1]))
end

"""
    michalewicz(x; m=10)

The **Michalewicz** function is a ``d``-dimensional function with several
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

**Rosenbrock** benchmark function.
With ``a=1`` and ``b=5``, minimum is at ``f([a, a^2]) = 0``

```math
f(x) = (a - x_1)^2 + b(x_2 - x_1^2)^2
```
"""
rosenbrock(x; a=1, b=5) = (a - x[1])^2 + b * (x[2] - x[1]^2)^2

"""
    wheeler(x, a=1.5)

The **Wheeler's ridge** is a 2-d function with a single global minimum in a curved peak.
With ``a`` (by default at 1.5) ``x^* = [1, 1.5]``, with ``f(x^*) = -1``.

```math
f(x) = - \\exp(- (x_1 x_2 - a)^2 - (x_2 - a)^2 )
```
"""
wheeler(x, a=1.5) = -exp(-(x[1]*x[2] - a)^2 - (x[2] - a)^2)
