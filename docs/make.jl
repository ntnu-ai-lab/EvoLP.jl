push!(LOAD_PATH, "../src/")

using EvoLP, Documenter

DocMeta.setdocmeta!(EvoLP, :DocTestSetup, :(using EvoLP); recursive=true)

makedocs(
    modules = [EvoLP],
    doctest = true,
    clean = true,
    sitename = "EvoLP",
    highlightsig = true,
    format = Documenter.HTML(
        prettyurls = false,
        mathengine = MathJax3(),
    ),
    pages = [
        "Introduction" => "index.md",
        "User Guide" => [
            "Workflow" => "man/quickstart.md",
            "Algorithms" => "man/algorithms.md",
            "Selection operators" => "man/selection.md",
            "Crossover operators" => "man/cross.md",
            "Mutation operators" => "man/mutation.md",
            "Population generators" => "man/generators.md",
            "Benchmark functions" => "man/benchmarks.md",
            "Reporting results" => "man/results.md",
            "Logging statistics" => "man/logbook.md",
            "Custom operators"  => "man/extending.md",
        ],
        "Tutorials" => [
            "The OneMax problem" => "tuto/oneplusone_onemax.md",
            "The 8 queens problem" => "tuto/8_queen.md",
            "GA for continuous optimisation" => "tuto/ga_rosenbrock.md",
            "PSO for continuous optimisation" => "tuto/pso_michalewicz.md",
        ],
        "API" => [
            "Types" => "lib/types.md",
            "Functions" => "lib/functions.md",
        ],
        "References & related links" => "references.md",
    ]
)

deploydocs(
    repo = "github.com/ntnu-ai-lab/EvoLP.jl.git",
)
