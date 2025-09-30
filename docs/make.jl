push!(LOAD_PATH, "../src/")

using EvoLP, MPI, Documenter

DocMeta.setdocmeta!(EvoLP, :DocTestSetup, :(using EvoLP); recursive=true)
modules = [
        EvoLP,
        Base.get_extension(EvoLP, :EvoLPIslandsExt),
    ]

makedocs(
    modules = modules,
    doctest = true,
    clean = true,
    sitename = "EvoLP",
    highlightsig = true,
    format = Documenter.HTML(
        prettyurls = false,
        mathengine = MathJax3(),
        ansicolor = true,
        sidebar_sitename = false,
        canonical = "https://ntnu-ai-lab.github.io/EvoLP.jl/stable/",
        assets = ["assets/favicon.ico"],
    ),
    pages = [
        "Introduction" => "index.md",
        "User Guide" => [
            "Quick start" => "man/quickstart.md",
            "Algorithms" => "man/algorithms.md",
            "Selection operators" => "man/selection.md",
            "Crossover operators" => "man/cross.md",
            "Mutation operators" => "man/mutation.md",
            "Population generators" => "man/generators.md",
            "Optimisation test functions" => "man/testfunctions.md",
            "Reporting results" => "man/results.md",
            "Logging statistics" => "man/logbook.md",
            "Custom operators"  => "man/extending.md",
            "Island Models" => "man/islands.md",
        ],
        "Tutorials" => [
            "The OneMax problem" => "tuto/oneplusone_onemax.md",
            "The 8 queens problem" => "tuto/8_queens.md",
            "GA for continuous optimisation" => "tuto/ga_rosenbrock.md",
            "PSO for continuous optimisation" => "tuto/pso_michalewicz.md",
            "Parallel Evaluation in EvoLP.jl" => "tuto/parallel.md",
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
