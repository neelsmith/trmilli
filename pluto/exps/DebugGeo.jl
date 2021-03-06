# Do something like
# push!(LOAD_PATH, "exps")
#
module DebugGeo

using VegaLite, VegaDatasets
using CSV, DataFrames

include("incode.jl")
include("tweaker.jl")


repo = dirname(pwd())
world110m = dataset("world-110m")
grat  = dataset("graticule")
lls = CSV.File(repo * "/data/simple-lls.cex", skipto
=2, delim="|") |> DataFrame


export viewglobal
export world110m

end