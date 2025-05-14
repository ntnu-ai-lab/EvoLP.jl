<p align="center">
  <img width="400px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo.png#gh-light-mode-only"/>
  <img width="400px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo-dark.png#gh-dark-mode-only"/>
</p>

<div align="center">

[![Stable](https://img.shields.io/badge/docs-latest-blue.svg)](https://ntnu-ai-lab.github.io/EvoLP.jl/)
[![Julia version](https://img.shields.io/badge/Julia-1.9+-blueviolet.svg?logo=julia)](https://julialang.org)
[![GitHub](https://img.shields.io/github/license/ntnu-ai-lab/EvoLP)](https://github.com/ntnu-ai-lab/EvoLP/blob/main/LICENSE)
[![All Contributors](https://img.shields.io/badge/all_contributors-2-red)](#contributors)

[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-blue.svg)](https://github.com/invenia/BlueStyle)
[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

</div>

---

**EvoLP.jl** is a _playground_ for [evolutionary computation](https://en.wikipedia.org/wiki/Evolutionary_computation) in [Julia](https://julialang.org). It provides a set of predefined _building blocks_ that can be coupled together to _play around_: quickly generate evolutionary computation solvers and compute statistics for a variety of optimisation tasks, including discrete, continuous and combinatorial optimisation.

## Features

- Random population generators (vectors and particles)
- Parent selection operators
- Several crossover and mutation methods
- Test functions for benchmarking
- Convenient result reporting and a statistics logbook

Combine these blocks to make your own algorithms or use some of the included minimisers: GA, 1+1EA and PSO.
Additionally, you can extend EvoLP to create new operators.

## Installation

You can install EvoLP.jl from the REPL using the built-in package manager:

```julia
julia> import Pkg
julia> Pkg.add("EvoLP")
```

Alternatively, you can enter `Pkg` mode by pressing the `]` key and then add EvoLP like so:

```text
julia> ] # upon typing ], the prompt changes (in place) to: pkg>
pkg> add EvoLP
```

## Getting started

- Read the **[documentation](https://ntnu-ai-lab.github.io/EvoLP.jl/)**.
- Browse some of the **[examples](https://github.com/ntnu-ai-lab/EvoLP/tree/main/examples/)** to see how to use the built-in algorithms.
- For a more comprehensive tutorial, read [the 8-queens problem](/examples/ga_k_queens.ipynb) where we construct an algorithm from scratch.

## Bug Reports

Please report any issues via the GitHub [issues tracker](https://github.com/ntnu-ai-lab/EvoLP/issues).

## Citing EvoLP.jl

If you find EvoLP.jl useful in your work or research, we kindly request that you cite the following [paper](https://ceur-ws.org/Vol-3431/paper7.pdf):

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

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%">
        <a href="https://github.com/saxarona">
                <img src="https://avatars.githubusercontent.com/u/5231167?v=4" width="100px;" alt=""/><br />
                <sub><b>Xavier F. C. Sánchez-Díaz</b></sub>
            </a><br />
            <a href="#question-saxarona" title="Answering Questions">💬</a> 
            <a href="https://github.com/all-contributors/all-contributors/commits?author=saxarona" title="Documentation">📖</a> 
            <a href="https://github.com/all-contributors/all-contributors/pulls?q=is%3Apr+reviewed-by%3Asaxarona" title="Reviewed Pull Requests">👀</a> 
            <a href="#talk-saxarona" title="Talks">📢</a>
      </td>
      <td align="center" valign="top" width="14.28%">
        <a href="https://github.com/Jafagervik">
                    <img src="https://pbs.twimg.com/profile_images/1761848615432073216/gMycbhZv_400x400.jpg" width="100px;" alt="Jørgen A. Fagervik"/><br />
                    <sub><b>Jørgen Aleksander Fagervik</b></sub>
                </a><br />
                <a href="#question-Jafagervik" title="Answering Questions">💬</a> 
                <a href="https://github.com/ntnu-ai-lab/EvoLP/commits?author=Jafagervik" title="Documentation">📖</a> 
                <a href="https://github.com/ntnu-ai-lab/EvoLP/pulls?q=is%3Apr+reviewed-by%3AJafagervik" title="Reviewed Pull Requests">👀</a> 
                <a href="#talk-Jafagervik" title="Talks">📢</a>
      </td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

## Acknowledgements

<p align="center">
  <img width=250px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo_nail.png#gh-light-mode-only"/>
  <img width=250px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo_nail-dark.png#gh-dark-mode-only"/>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img width=250px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo_ntnu.png#gh-light-mode-only"/>
  <img width=250px" src="https://raw.githubusercontent.com/ntnu-ai-lab/EvoLP.jl/main/docs/src/assets/logo_ntnu-dark.png#gh-dark-mode-only"/>
</p>

EvoLP.jl started as a toolbox for internal use by PhD students of [NTNU's Open AI Lab](https://www.ntnu.edu/ailab/ai-lab), and whose funding is provided by [Project no. 311284](https://prosjektbanken.forskningsradet.no/en/project/FORISS/311284) by [The Research Council of Norway](https://www.forskningsradet.no/). EvoLP is licensed under the [MIT License](https://github.com/ntnu-ai-lab/EvoLP/blob/main/LICENSE) which makes it **free and open source**.
