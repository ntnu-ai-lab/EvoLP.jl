# EvoLP - An evolutionary computation playground

Welcome to the documentation for EvoLP!

[![GitHub source](https://img.shields.io/badge/GitHub-source-green.svg?logo=github)](https://github.com/ntnu-ai-lab/EvoLP.jl)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-blue.svg)](https://github.com/invenia/BlueStyle)
[![Julia version](https://img.shields.io/badge/Julia-1.8-blueviolet.svg?logo=julia)](https://julialang.org)

## What is EvoLP?

[EvoLP](https://github.com/ntnu-ai-lab/EvoLP) is a _playground_ for [evolutionary computation](https://en.wikipedia.org/wiki/Evolutionary_computation) in [Julia](https://julialang.org). It provides a set of predefined _building blocks_ that can be coupled together to quickly generate evolutionary computation solvers and compute statistics for a variety of optimisation tasks, including discrete, continuous and combinatorial optimisation.

### Features

- Random [population generators](man/generators.md) (vectors and particles)
- Parent [selection operators](man/selection.md)
- Several [crossover](man/cross.md) and [mutation](man/mutation.md) methods
- [Test functions](man/benchmarks.md) for benchmarking
- Convenient [result reporting](man/results.md) and a [statistics logbook](man/logbook.md)

Combine these blocks to make your own algorithms or use some of the [included](man/algorithms.md) _minimisers_: GA, 1+1EA and PSO.
Additionally, you can extend EvoLP to create [new operators](man/extending.md).

## Getting started

- Read the [quick start](man/quickstart.md) page for information about installation and to get a quick overview.
- Browse some of the [examples](tuto/oneplusone_onemax.md) to see how to use the built-in algorithms.
- For a more comprehensive tutorial, read the [8-queen problem](tuto/8_queen.md) where we make an algorithm from scratch.

Alternatively, you can browse the [type](lib/types.md) and [functions](lib/functions.md) indices to view all available functionality.

## Acknowledgements

EvoLP was initially created as a toolbox for internal use by PhD students of [NTNU's Open AI Lab](https://www.ntnu.edu/ailab/ai-lab), and whose funding is provided by [Project no. 311284](https://prosjektbanken.forskningsradet.no/en/project/FORISS/311284) by [The Research Council of Norway](https://www.forskningsradet.no/).

## License

EvoLP is licensed under the [MIT License](https://github.com/ntnu-ai-lab/EvoLP/blob/main/LICENSE) which makes it free and open source.
