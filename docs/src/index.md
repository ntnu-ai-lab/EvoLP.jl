# EvoLP - An evolutionary computation playground

Welcome to the documentation for EvoLP!

[![GitHub source](https://img.shields.io/badge/GitHub-source-green.svg?logo=github)](https://github.com/ntnu-ai-lab/EvoLP.jl)
[![Julia version](https://img.shields.io/badge/Julia-1.9+-blueviolet.svg?logo=julia)](https://julialang.org)
[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-blue.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

## What is EvoLP?

[EvoLP](https://github.com/ntnu-ai-lab/EvoLP) is a _playground_ for [evolutionary computation](https://en.wikipedia.org/wiki/Evolutionary_computation) in [Julia](https://julialang.org). It provides a set of predefined _building blocks_ that can be coupled together to quickly generate evolutionary computation solvers and compute statistics for a variety of optimisation tasks, including discrete, continuous and combinatorial optimisation.

### Features

- Random [population generators](man/generators.md) (vectors and particles)
- Parent [selection operators](man/selection.md)
- Several [crossover](man/cross.md) and [mutation](man/mutation.md) methods
- [Test functions](man/testfunctions.md) for benchmarking
- Convenient [result reporting](man/results.md) and a [statistics logbook](man/logbook.md)

Combine these blocks to make your own algorithms or use some of the [included](man/algorithms.md) _minimisers_: GA, 1+1EA and PSO.
Additionally, you can extend EvoLP to create [new operators](man/extending.md).

## Getting started

- Read the [quick start](man/quickstart.md) page for information about installation and to get a quick overview.
- Browse some of the [examples](tuto/oneplusone_onemax.md) to see how to use the built-in algorithms.
- For a more comprehensive tutorial, read the [8-queens problem](tuto/8_queens.md) where we make an algorithm from scratch.

Alternatively, you can browse the [type](lib/types.md) and [functions](lib/functions.md) indices to view all available functionality.

## Parallel evaluation and Island Models

EvoLP provides island support via MPI as an extension.
Read more [about island models in EvoLP](man/islands.md) and how to achieve [parallel evaluation](tuto/parallel.md).

## Citing EvoLP.jl

If you find EvoLP.jl useful in your work or research, we kindly request that you cite the following [conference paper](https://ceur-ws.org/Vol-3431/paper7.pdf):

```bibtex
@inproceedings{Sanchez-DiazEvoLP2023a,
  address = {Bergen, NO},
  author = {Sánchez-Díaz, Xavier F. C. and Mengshoel, Ole Jakob},
  booktitle = {Proceedings of the 5th Symposium of the Norwegian AI Society},
  editor = {Galimullin, Rustam and Touileb, Samia},
  month = jun,
  publisher = {CEUR Workshop Proceedings},
  series = {NAIS 2023: Symposium of the Norwegian AI Society 2023},
  title = {{EvoLP.jl: A Playground for Evolutionary Computation in Julia}},
  url = {https://ceur-ws.org/Vol-3431/},
  year = {2023}
}
```

You can also cite EvoLPIslands, our MPI Extension, by citing the following [conference paper](https://www.ntnu.no/ojs/index.php/nikt/article/view/5667):

```bibtex
@article{sanchez-DiazEvolutionaryComputationIslands2023,
  title = {{Evolutionary Computation with Islands: Extending EvoLP.Jl for Parallel Computing}},
  shorttitle = {{Evolutionary Computation with Islands}},
  author = {Sánchez-Díaz, Xavier F. C. and Mengshoel, Ole Jakob},
  year = {2023},
  month = nov,
  journal = {Norsk {IKT}-konferanse for forskning og utdanning},
  number = {1},
  issn = {1892-0721},
  copyright = {Copyright (c) 2023 Norsk IKT-konferanse for forskning og utdanning},
}
```

## Acknowledgements

EvoLP started as a toolbox for internal use by PhD students of [NTNU's Open AI Lab](https://www.ntnu.edu/ailab/ai-lab), and whose funding is provided by [Project no. 311284](https://prosjektbanken.forskningsradet.no/en/project/FORISS/311284) by [The Research Council of Norway](https://www.forskningsradet.no/).

## License

EvoLP is licensed under the [MIT License](https://github.com/ntnu-ai-lab/EvoLP/blob/main/LICENSE) which makes it free and open source.
