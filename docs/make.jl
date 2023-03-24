push!(LOAD_PATH, "../src/")

using EvoLP, Documenter

DocMeta.setdocmeta!(EvoLP, :DocTestSetup, :(using EvoLP); recursive=true)

makedocs(
    modules = [EvoLP],
    doctest = false,
    clean = true,
    sitename = "EvoLP",
    format = Documenter.HTML(
        prettyurls = false,
        mathengine = MathJax3()
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
        ],
        "Tutorials" => [
            "The 8 queens problem" => "tuto/8_queen.md"
        ],
        "API" => [
            "Types" => "lib/types.md",
            "Functions" => "lib/functions.md",
        ],
        "References" => "references.md"
    ]
)
