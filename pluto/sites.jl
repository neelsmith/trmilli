### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 68adcd48-7e72-11eb-3313-4be9accf9305
begin
	using Pkg
	Pkg.activate(".")	
	Pkg.instantiate()
	using VegaLite
	using VegaDatasets
	using CSV
	using DataFrames
	using JSON
	using PlutoUI
	Pkg.status()
end

# ╔═╡ 478229d4-7e72-11eb-27ec-47e443620d4c
md"## Plot Lycian sites interactively"

# ╔═╡ e38ef14e-7e73-11eb-06a5-edd0f493edc2
md"Map height (pixels) $(@bind h Slider(100:800, default=300, show_value=true))"

# ╔═╡ a6ba406e-7e73-11eb-30ef-5bcccea7fd72
md"Map width (pixels) $(@bind w Slider(100:800, default=500, show_value=true))"

# ╔═╡ 768fd7b6-7e73-11eb-1826-d300c0ac0361
md"> Functions to manipulate and plot data"

# ╔═╡ 48185b78-7e76-11eb-3755-e75f9d869a32
projdict = 
	Dict(
	"Mercator" => :mercator,
	"Conic equal area" => :conicEqualArea,
	"Gnomonic" => :gnomonic,
	"Orthographic" => :orthographic
		)

	

# ╔═╡ 08287ce0-7e7a-11eb-159d-cb96c850b4f9
function projmenu() 
	projnames = collect(k for k in keys(projdict))
	pushfirst!(projnames, "")
end

# ╔═╡ a78c54ca-7e76-11eb-3fbd-6d09ca6d108f
md"Projection $(@bind proj Select(projmenu()))"

# ╔═╡ fef171c6-7e7a-11eb-2c30-2b3414bd3434
if ! isempty(proj)
		projdict[proj]
else
	"Default"
end

# ╔═╡ 4db92e1e-7e73-11eb-1f5b-31c82d374367
md"> Data sets"

# ╔═╡ 6ed4d0f2-7e74-11eb-3ab4-cf6b6f9f9165
repo = dirname(pwd())

# ╔═╡ 41241d02-7e74-11eb-083c-1b00e60e3985
# Lon-lat coordiantes for sites identified by RAGE ID.
lls = CSV.File(repo * "/data/simple-lls.cex", skipto
=2, delim="|") |> DataFrame

# ╔═╡ a5d80b70-7e72-11eb-364b-d54f4473e4e1
world110m = dataset("world-110m")

# ╔═╡ ae8aed3c-7e72-11eb-2004-3f41ad407fdd

function plotall(proj)
	# Default projection:
	
		
    @vlplot(width=w, height=h) +
    @vlplot(
        projection={
			type=proj
		},
        mark={
            :geoshape,
            fill=:lightgray,
            stroke=:white
        },
        data={
            values=world110m,
            format={
                type=:topojson,
                feature=:land
            }
        }
    ) + 
	@vlplot(
    :circle,
    data=lls,
    longitude="lon:q",
    latitude="lat:q",
    color={value=:orange}
)
end

# ╔═╡ b154a4ae-7e72-11eb-3239-517878a3a6fb
if isempty(proj)
	
	plotall(:mercator)
else
	plotall(projdict[proj])
end

# ╔═╡ Cell order:
# ╟─68adcd48-7e72-11eb-3313-4be9accf9305
# ╟─478229d4-7e72-11eb-27ec-47e443620d4c
# ╟─b154a4ae-7e72-11eb-3239-517878a3a6fb
# ╟─a78c54ca-7e76-11eb-3fbd-6d09ca6d108f
# ╟─e38ef14e-7e73-11eb-06a5-edd0f493edc2
# ╟─a6ba406e-7e73-11eb-30ef-5bcccea7fd72
# ╟─768fd7b6-7e73-11eb-1826-d300c0ac0361
# ╟─fef171c6-7e7a-11eb-2c30-2b3414bd3434
# ╟─ae8aed3c-7e72-11eb-2004-3f41ad407fdd
# ╟─08287ce0-7e7a-11eb-159d-cb96c850b4f9
# ╟─48185b78-7e76-11eb-3755-e75f9d869a32
# ╟─4db92e1e-7e73-11eb-1f5b-31c82d374367
# ╟─6ed4d0f2-7e74-11eb-3ab4-cf6b6f9f9165
# ╟─41241d02-7e74-11eb-083c-1b00e60e3985
# ╟─a5d80b70-7e72-11eb-364b-d54f4473e4e1
