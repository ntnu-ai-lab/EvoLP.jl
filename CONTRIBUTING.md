# How to contribute to EvoLP

This document describes some ways in which you can contribute to EvoLP.

## Why is it important to contribute?

- In this way, you contribute to open and reproducible science
- You exercise your coding skills
- You help the community by providing useful contributions

## What can I do to contribute?

There are many ways in which you can contribute to EvoLP!

### Improve the documentation

Having a clearer documentation benefits everyone. In this sense, you can help either fixing it or expanding it in multiple ways: with wording or clarification, reporting typos, adding corrections or even creating new pages on topics that could need further explanations.

The manuals are written in Markdown, and are built using [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl). All the source files of the documentation can be found at the docs [GitHub Page](https://github.com/ntnu-ai-lab/EvoLP.jl/tree/main/docs).

If your submission is small (typos or one or two sentences) then probably using GitHub's online editor is the best idea.

If your submission is big enough (spanning multiple files and adding or modifying several lines of code) then you will need to fork the repository, modify locally, and submit a pull request.

### File a bug report

Finding bugs is greatly appreciated, because that means that we can fix them (or you can also [help with that](#contribute-code-to-evolp)).

For now, you can submit a new issue describing the problem in the [issue tracker](https://github.com/ntnu-ai-lab/EvoLP.jl/issues).

### Contribute code to EvoLP

Contributing code is also possible via fork & pull request:

1. Fork EvoLP
2. Make changes (be sure to follow the [style guide](https://github.com/invenia/BlueStyle)).
3. Make a unit test of your added functionality
4. Test your code changes
5. Document your code changes
6. Push to your fork and make a pull request

## Contributing guidelines

[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

EvoLP follows the ColPrac: Contributor's Guide on Collaborative Practices for Community Packages guide from SciML.
This guide is a collection of best practices when contributing to packages.

You can read the full guide at SciML's [ColPrac repository](https://github.com/SciML/ColPrac).

## Code style guidelines

[![Code Style: Blue](https://img.shields.io/badge/code%20style-blue-4495d1.svg)](https://github.com/invenia/BlueStyle)

EvoLP follows Invenia's Blue code style guide.
This is a set of style conventions for Julia code that are based on a series of grounding documents (like Julia's own style guide and PEP8).

You can read the full guide at Invenia's [Blue Style repository](https://github.com/invenia/BlueStyle).

## Source code organisation

The following table shows how the EvoLP code is organised:

| **Directory** |  **Contents** |
|:-------------:|:-------------:|
| docs          | Documentation |
| examples      | Examples      |
| ext           | Extensions    |
| src           | Source code   |
| test          | Test suites   |

### The `docs` folder

Documentation lives here. `src` contains the necessary files for compiling the manual, and `make.jl` builds it via a GitHub action.

### The `examples` folder

Examples in `.ipynb` form are placed here. This makes it easier for examples to be shown directly in GitHub.

### The `src` folder

This folder contains all the functionality of EvoLP, spread over several files for clarity.
All these files are included in `EvoLP.jl` which is the file  which defines the module itself.

An additional subfolder for `algorithms` is present, to keep solvers and _blocks_ separated.

### The `test` folder

This is where all tests reside.
The main test suite `runtests.jl` includes functionality to run all other test suites.
Each of these test suites cover all the different categories in EvoLP.

New generators should be tested in the `generators.jl` test suite.
New recombinators should be tested in the `crossover.jl` test suite.
And so on.

To test algorithms, we solve one of the test functions (in `src/testfunctions.jl`) and which solutions are known.
Create a new implementation in a notebook, beautify and put in the `src/examples/` directory.

### Get in touch

Regardless of what you contribute or how big or small your contribution is, the help is always appreciated.

Get in touch; we will probably be able to help you through the contributing process.
