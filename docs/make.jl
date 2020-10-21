using GeckoScreen
using Documenter

makedocs(;
    modules=[GeckoScreen],
    authors="Meghan Ferrall-Fairbanks <meghan.ferrall.fairbanks@gmail.com> and contributors",
    repo="https://github.com/mcfefa/GeckoScreen.jl/blob/{commit}{path}#L{line}",
    sitename="GeckoScreen.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mcfefa.github.io/GeckoScreen.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mcfefa/GeckoScreen.jl",
)
