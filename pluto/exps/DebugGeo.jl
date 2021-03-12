# Do something like
# push!(LOAD_PATH, "exps")
#
module DebugGeo

using VegaLite, VegaDatasets
using CSV, DataFrames, JSON, Query

#include("incode.jl")
#include("tweaker.jl")
#include("loader.jl")
#include("nb.jl")
include("overlays.jl")

repo = dirname(pwd())
world110m = dataset("world-110m")
grat  = dataset("graticule")
lls = CSV.File(repo * "/data/simple-lls.cex", skipto
=2, delim="|") |> DataFrame

export lls


textgeo = CSV.File(repo * "/data/onlinegeo.cex", skipto
=2, delim="|") |> DataFrame



#export viewglobal
#export world110m, necountries, countries50m, land110m
#export grat, lls


end