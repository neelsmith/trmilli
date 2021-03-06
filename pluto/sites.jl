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

# ╔═╡ ddef4c98-7e7d-11eb-162e-eb715aaba907
md"*Customize projection*"

# ╔═╡ 10156f3c-7e7d-11eb-0e8b-83315a983280
md"Yaw $(@bind rot1 Slider(-180:180, default=-35, show_value=true))"

# ╔═╡ 5f895966-7e7d-11eb-1393-c9ae1d1db0a7
md"Pitch $(@bind rot2 Slider(-180:180, default=0, show_value=true))"

# ╔═╡ 66a5ad8a-7e7d-11eb-183b-3fd274a92798
md"Roll $(@bind rot3 Slider(-180:180, default=0, show_value=true))"

# ╔═╡ 15eb7c28-7e7d-11eb-331b-c16c9a1cfb34
md"*Display size*"

# ╔═╡ e38ef14e-7e73-11eb-06a5-edd0f493edc2
md"Map height (pixels) $(@bind h Slider(100:800, default=300, show_value=true))"

# ╔═╡ a6ba406e-7e73-11eb-30ef-5bcccea7fd72
md"Map width (pixels) $(@bind w Slider(100:800, default=500, show_value=true))"

# ╔═╡ 768fd7b6-7e73-11eb-1826-d300c0ac0361
md"> Functions to manipulate and plot data"

# ╔═╡ 32daaa44-7e7f-11eb-33c8-a349fb3e9012


# ╔═╡ 48185b78-7e76-11eb-3755-e75f9d869a32
projdict = 
	Dict(
	"Natural earth" => :naturalEarth1,
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

# ╔═╡ 4db92e1e-7e73-11eb-1f5b-31c82d374367
md"> Data sets"

# ╔═╡ 6ed4d0f2-7e74-11eb-3ab4-cf6b6f9f9165
repo = dirname(pwd())

# ╔═╡ 41241d02-7e74-11eb-083c-1b00e60e3985
# Lon-lat coordiantes for sites identified by RAGE ID.
lls = CSV.File(repo * "/data/simple-lls.cex", skipto
=2, delim="|") |> DataFrame

# ╔═╡ 3864465a-7e7f-11eb-11fb-a386ee27641e
grat  = dataset("graticule")

# ╔═╡ a5d80b70-7e72-11eb-364b-d54f4473e4e1
world110m = dataset("world-110m")

# ╔═╡ ae8aed3c-7e72-11eb-2004-3f41ad407fdd
# Use interacitve values for:
# rot1, rot2, rot3
function plotall(proj)

		
    @vlplot(width=w, height=h) +
    @vlplot(
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3]
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

# ╔═╡ c1ac17da-7e7f-11eb-2c34-f9df92a4caef
grat.path


# ╔═╡ 4ccac240-7e7f-11eb-3105-47f639d23364
function plotgrat(proj)
	
		
    @vlplot(width=w, height=h) +
    @vlplot(
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3]
		},
        mark={
            :geoshape,
            fill=:white,
            stroke=:black
        },
        data={
            values=grat,
            format={
                type=:topojson,
                feature=:graticule
            }
        }
    ) + 
	@vlplot(
    :circle,
    data=lls,
    longitude="lon:q",
    latitude="lat:q",
    color={value=:orange}
) + 
	@vlplot(
		:geoshape,
		data={
            values=world110m,
            format={
                type=:topojson,
                feature=:land
            }
		}
		)
	
end

# ╔═╡ 5ddd9878-7e7f-11eb-21c4-a3d3fab2cfc8
plotgrat("Mercator")

# ╔═╡ Cell order:
# ╟─68adcd48-7e72-11eb-3313-4be9accf9305
# ╟─478229d4-7e72-11eb-27ec-47e443620d4c
# ╟─b154a4ae-7e72-11eb-3239-517878a3a6fb
# ╟─ddef4c98-7e7d-11eb-162e-eb715aaba907
# ╟─a78c54ca-7e76-11eb-3fbd-6d09ca6d108f
# ╟─10156f3c-7e7d-11eb-0e8b-83315a983280
# ╟─5f895966-7e7d-11eb-1393-c9ae1d1db0a7
# ╟─66a5ad8a-7e7d-11eb-183b-3fd274a92798
# ╟─15eb7c28-7e7d-11eb-331b-c16c9a1cfb34
# ╟─e38ef14e-7e73-11eb-06a5-edd0f493edc2
# ╟─a6ba406e-7e73-11eb-30ef-5bcccea7fd72
# ╟─768fd7b6-7e73-11eb-1826-d300c0ac0361
# ╠═ae8aed3c-7e72-11eb-2004-3f41ad407fdd
# ╠═32daaa44-7e7f-11eb-33c8-a349fb3e9012
# ╟─08287ce0-7e7a-11eb-159d-cb96c850b4f9
# ╟─48185b78-7e76-11eb-3755-e75f9d869a32
# ╟─4db92e1e-7e73-11eb-1f5b-31c82d374367
# ╟─6ed4d0f2-7e74-11eb-3ab4-cf6b6f9f9165
# ╟─41241d02-7e74-11eb-083c-1b00e60e3985
# ╟─3864465a-7e7f-11eb-11fb-a386ee27641e
# ╟─a5d80b70-7e72-11eb-364b-d54f4473e4e1
# ╟─5ddd9878-7e7f-11eb-21c4-a3d3fab2cfc8
# ╟─c1ac17da-7e7f-11eb-2c34-f9df92a4caef
# ╠═4ccac240-7e7f-11eb-3105-47f639d23364
