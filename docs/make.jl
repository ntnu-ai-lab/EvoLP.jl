push!(LOAD_PATH, "../src/")

using EvoLP, Documenter

DocMeta.setdocmeta!(EvoLP, :DocTestSetup, :(using EvoLP); recursive=true)

makedocs(
    modules = [EvoLP],
    doctest = false,
    clean = true,
    sitename = "EvoLP.jl",
    pages =[
        "Home" => "index.md",
        "Getting Started" => "quickstart.md",
        "Algorithms" => "algorithms.md",
        "Selection operators" => "selection.md",
        "Crossover operators" => "cross.md",
        "Mutation operators" => "mutation.md",
        "Population generators" => "generators.md",
        "Benchmark functions" => "benchmarks.md",
        "Reporting results" => "results.md",
        "Logging statistics" => "logbook.md",
        "References" => "references.md"
    ],
    format = Documenter.HTML(prettyurls = false, mathengine = MathJax3())
)
