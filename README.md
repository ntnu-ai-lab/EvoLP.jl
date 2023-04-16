<p align="center">
  <img width="400px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo.png#gh-light-mode-only"/>
  <img width="400px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo-dark.png#gh-dark-mode-only"/>
</p>

<div align="center">

[![Stable](https://img.shields.io/badge/docs-latest-blue.svg)](https://ntnu-ai-lab.github.io/EvoLP.jl/)
[![Julia version](https://img.shields.io/badge/Julia-1.8-blueviolet.svg?logo=julia)](https://julialang.org)
[![GitHub](https://img.shields.io/github/license/ntnu-ai-lab/EvoLP)](https://github.com/ntnu-ai-lab/EvoLP/blob/main/LICENSE)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-blue.svg)](https://github.com/invenia/BlueStyle)

</div>

---

**EvoLP** is a _playground_ for [evolutionary computation](https://en.wikipedia.org/wiki/Evolutionary_computation) in [Julia](https://julialang.org). It provides a set of predefined _building blocks_ that can be coupled together to _play around_: quickly generate evolutionary computation solvers and compute statistics for a variety of optimisation tasks, including discrete, continuous and combinatorial optimisation.

## Features

- Random population generators (vectors and particles)
- Parent selection operators
- Several crossover and mutation methods
- Test functions for benchmarking
- Convenient result reporting and a statistics logbook

Combine these blocks to make your own algorithms or use some of the included minimisers: GA, 1+1EA and PSO.
Additionally, you can extend EvoLP to create new operators.

## Installation

You can install EvoLP from the REPL using the built-in package manager:

```julia
julia> import Pkg
julia> Pkg.add("EvoLP")
```

Alternatively, you can enter `Pkg` mode by pressing the `]` key and then add EvoLP like so:

```julia
julia> ] # upon typing ], the prompt changes (in place) to: pkg>
pkg> add EvoLP
```

## Getting started

- Read the [documentation](https://ntnu-ai-lab.github.io/EvoLP.jl/).
- Browse some of the [examples](https://github.com/ntnu-ai-lab/EvoLP/tree/main/examples/) to see how to use the built-in algorithms.
- For a more comprehensive tutorial, read [the 8-queen problem](/examples/ga_k_queens.ipynb) where we construct an algorithm from scratch.

## Bug Reports

Please report any issues via the GitHub [issues tracker](https://github.com/ntnu-ai-lab/EvoLP/issues).

## Acknowledgements

<p align="center">
  <img width=250px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo_nail.png#gh-light-mode-only"/>
  <img width=250px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo_nail-dark.png#gh-dark-mode-only"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img width=250px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo_ntnu.png#gh-light-mode-only"/>
  <img width=250px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo_ntnu-dark.png#gh-dark-mode-only"/>
</p>

EvoLP was initially created as a toolbox for internal use by PhD students of [NTNU's Open AI Lab](https://www.ntnu.edu/ailab/ai-lab), and whose funding is provided by [Project no. 311284](https://prosjektbanken.forskningsradet.no/en/project/FORISS/311284) by [The Research Council of Norway](https://www.forskningsradet.no/). Therefore, EvoLP is licensed under the [MIT License](https://github.com/ntnu-ai-lab/EvoLP/blob/main/LICENSE) which makes it **free and open source**.
