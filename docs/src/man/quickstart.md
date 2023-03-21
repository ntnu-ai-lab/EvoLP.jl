# Quick start

EvoLP was designed as a _playground_, where each _block_ is a reusable computation pattern which you can use to quickly set up your own algorithms and workflows.

The [examples](https://github.com/ntnu-ai-lab/EvoLP/tree/master/examples) folder contains some useful Jupyter Notebooks you can follow to see how to ensemble the blocks.
The [8-queen problem](https://github.com/ntnu-ai-lab/EvoLP/blob/master/examples/ga_k_queens.ipynb) may be of special interest since it details how to generate an algorithm from scratch.

A common workflow in EvoLP looks like this:

1. Use a [generator](generators.md) for initialising your population.
2. Code your objective function.
3. Depending on your objective function and individual representation, choose appropriate [selectors](selection.md), [recombinators](cross.md) and [mutators](mutation.md).
4. Use a [built-in algorithm](algorithms.md) or code your own. Roughly:
    - Evaluate your population.
    - Use [`select`](@ref) and [`cross`](@ref) to generate new solutions.
    - Mutate the new solutions using [`mutate`](@ref).
    - Evaluate again and choose the survivors.
    - Optionally compute statistic and log them in the [Logbook](logbook.md).
    - Return the [results](results.md).
