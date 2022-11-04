push!(LOAD_PATH, "../src/")

using Documenter, EvoLP

makedocs(
    modules = [EvoLP],
    doctest = false,
    clean = true,
    sitename = "EvoLP.jl",
    pages =[
        "Home" => "index.md",
        "Algorithms" => "algorithms.md",
        "Selection operators" => "selection.md",
        "Crossover operators" => "cross.md",
        "Mutation operators" => "mutation.md",
        "Population generators" => "generators.md",
        "Benchmark functions" => "benchmarks.md",
        "Stats logbook" => "logbook.md",
    ],
    format = Documenter.HTML(prettyurls = false, mathengine = MathJax3())
)
