# Quick start

EvoLP was designed as a _playground_, where each _block_ is a reusable computation pattern that you can use to quickly set up your own algorithms and workflows.

You can find some useful tutorials in the navigation bar. These examples are also available in [the repository](https://github.com/ntnu-ai-lab/EvoLP/tree/master/examples) as Jupyter Notebooks.
The tutorial on [the 8 queens problem](../tuto/8_queen.md) details how to incorporate a custom algorithm into the workflow.

## The general  workflow

A common workflow in EvoLP is somewhat similar to this:

1. Use a [generator](generators.md) for initialising your population.
2. Code your objective or use a [test benchmark function](benchmarks.md).
3. Depending on your objective function and individual representation, choose appropriate [selectors](selection.md), [recombinators](cross.md) and [mutators](mutation.md).
4. Use a [built-in algorithm](algorithms.md) or code your own. Roughly:
    - Evaluate your population.
    - Use [`select`](@ref) and [`cross`](@ref) to generate new solutions.
    - Stochastically alter new solutions using [`mutate`](@ref).
    - Evaluate the new population members and select the survivors.
    - Optionally compute statistic and log them in the [Logbook](logbook.md).
    - Return the [results](results.md).
