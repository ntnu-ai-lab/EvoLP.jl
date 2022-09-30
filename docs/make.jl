push!(LOAD_PATH, "../src/")

using Documenter, EvoLP

makedocs(
    modules = [EvoLP],
    doctest = false,
    clean = true,
    sitename = "EvoLP.jl",
    pages =[
        "Home" => "index.md"
    ]
)
