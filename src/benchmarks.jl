"""
Rosenbrock benchmark function.
With ``a=1`` and ``b=5``, minimum is at ``f([a, a^2]) = 0``
"""
rosenbrock(x; a=1, b=5) = (a - x[1])^2 + b * (x[2] - x[1]^2)^2

"""
One max function.
Returns the sum of the individual.
"""
onemax(x) = sum(x)

"""
LeadingOnes function.
```math
\\text{LO}(\\mathbf{x}) = \\sum_{i=1}^n \\prod_j^i x_j
````
"""
function leadingones(x)::Int
    s = 0
    for i = 1:length(x)
        m = reduce(*, x[1:i])
        s += m
    end
    return s
end