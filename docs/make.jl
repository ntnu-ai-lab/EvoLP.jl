push!(LOAD_PATH, "../src/")

using EvoLP, Documenter

DocMeta.setdocmeta!(EvoLP, :DocTestSetup, :(using EvoLP); recursive=true)

makedocs(
    modules = [EvoLP],
    doctest = false,
    clean = true,
    sitename = "EvoLP.jl",
    format = Documenter.HTML(
        prettyurls = false,
        mathengine = MathJax3()
    ),
    pages = [
        "Home" => "index.md",
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
        ],
        "API" => [
            "Types" => "lib/types.md",
            "Functions" => "lib/functions.md",
        ],
        "References" => "references.md"
    ]
)
