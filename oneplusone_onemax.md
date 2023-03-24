# 1+1 Evolutionary Algorithm

This notebook showcases how to use the built-in 1+1 Evolutionary Algorithm (EA)


```julia
using EvoLP
using OrderedCollections
using Statistics
```

For this example, we will use the **OneMax** function:


```julia
@doc onemax
```


The **OneMax** function returns the sum of the individual. For an individual of length $n$, maximum is achieved with $n$ ones.

$$
\text{OneMax}(\mathbf{x}) = \sum_{i=1}^n x_i
$$



In an EA we use vectors as _individuals_. The <span style="color:magenta">1</span>+<span style="color:blue">1</span> EA features <span style="color:magenta">1 _parent_</span> and <span style="color:blue">1 _offspring_</span> each iteration.

Let's start creating the first individual. We can use the _binary generator_ included in EvoLP:


```julia
@doc binary_vector_pop
```


```
binary_vector_pop(n, l; rng=Random.GLOBAL_RNG)
```

Generate a population of `n` vector binary individuals, each of length `l`.

# Examples

```julia
julia> using EvoLP

julia> binary_vector_pop(2, 5)
2-element Vector{BitVector}:
 [1, 0, 1, 1, 0]
 [0, 1, 0, 0, 0]
```



It is important to note that the return value of a _population_ is a list, so we want the first (and only) element inside:


```julia
ind_size = 15
firstborn = binary_vector_pop(1, ind_size)[1]
```


    15-element BitVector:
     0
     0
     1
     1
     0
     0
     1
     0
     0
     1
     1
     0
     1
     0
     1


Since the 1+1 EA works on a single individual, we only have the _mutation step_. We can set up the appropriate mtuation operator: `BitwiseMutation`.


```julia
@doc BitwiseMutation
```


Bitwise mutation with probability `λ` of flipping each bit.




```julia
Mut = BitwiseMutation(1/ind_size)
```


    BitwiseMutation(0.06666666666666667)


Now on to the fitness function. EvoLP is built for _minimisation_, so we need to optimise for the _negative_ of **OneMax**:


```julia
f(x) = -onemax(x)
```


    f (generic function with 1 method)


Let's use the `Logbook` to record the fitness value on each iteration:


```julia
statnames = ["fit"]
callables = [identity]
thedict = LittleDict(statnames, callables)
logbook = Logbook(thedict)
```


    Logbook(LittleDict{AbstractString, Function, Vector{AbstractString}, Vector{Function}}("fit" => identity), NamedTuple{(:fit,)}[])


We are now ready to use the `oneplusone` built-in algorithm:


```julia
@doc oneplusone
```


```
oneplusone(f::Function, ind, k_max, M)
oneplusone(logger::Logbook, f::Function, ind, k_max, M)
```

1+1 EA algorithm.

# Arguments

  * `f`: Objective function to minimise
  * `ind`: Individual to start the evolution
  * `k_max`: Maximum number of iterations
  * `M::MutationMethod`: A mutation method. See mutation.

Returns a `Result` type of the form:

$$
\big( f(x^*), x^*, pop, k_{max}, f_{calls} \big)
$$




```julia
result = oneplusone(logbook, f, firstborn, 50, Mut);
```

The output was suppressed so that we can analyse each part of the result separately:


```julia
@show optimum(result)

@show optimizer(result)

@show iterations(result)

@show f_calls(result);
```

    optimum(result) = -15
    optimizer(result) = Bool[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    iterations(result) = 50
    f_calls(result) = 102


We can also take a look at the logbook records and see how the statistics changed throughout the run (although in this case we just logged the fitness):


```julia
@show first(logbook.records, 20)
```

    first(logbook.records, 20) = NamedTuple{(:fit,)}[(fit = [-7],), (fit = [-7],), (fit = [-8],), (fit = [-9],), (fit = [-9],), (fit = [-9],), (fit = [-9],), (fit = [-9],), (fit = [-9],), (fit = [-9],), (fit = [-9],), (fit = [-9],), (fit = [-9],), (fit = [-10],), (fit = [-10],), (fit = [-10],), (fit = [-10],), (fit = [-11],), (fit = [-11],), (fit = [-11],)]



    20-element Vector{NamedTuple{(:fit,)}}:
     (fit = [-7],)
     (fit = [-7],)
     (fit = [-8],)
     (fit = [-9],)
     (fit = [-9],)
     (fit = [-9],)
     (fit = [-9],)
     (fit = [-9],)
     (fit = [-9],)
     (fit = [-9],)
     (fit = [-9],)
     (fit = [-9],)
     (fit = [-9],)
     (fit = [-10],)
     (fit = [-10],)
     (fit = [-10],)
     (fit = [-10],)
     (fit = [-11],)
     (fit = [-11],)
     (fit = [-11],)

