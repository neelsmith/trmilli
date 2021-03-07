# Do something like
# push!(LOAD_PATH, "exps")
#
module DebugGeo

using VegaLite, VegaDatasets
using CSV, DataFrames, JSON

include("incode.jl")
include("tweaker.jl")
include("loader.jl")
include("nb.jl")

repo = dirname(pwd())
world110m = dataset("world-110m")
grat  = dataset("graticule")
lls = CSV.File(repo * "/data/simple-lls.cex", skipto
=2, delim="|") |> DataFrame
grat  = dataset("graticule")


necountries = repo * "/data/ne-countries-110m-topojson.json"
necountriesgeo = JSON.parsefile(necountries)
#necountriessymbol = Symbol("ne_110m_admin_0_countries")
countries50m = repo * "/data/countries-50m.json"
converted50m = JSON.parsefile(repo * "/data/converted.json")


lls = CSV.File(repo * "/data/simple-lls.cex", skipto
=2, delim="|") |> DataFrame

land110m = JSON.parsefile(repo * "/data/land-110m.json")
export viewglobal
export world110m, necountries, countries50m, land110m
export grat, lls


end