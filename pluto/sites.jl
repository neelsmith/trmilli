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

# ╔═╡ a6ba406e-7e73-11eb-30ef-5bcccea7fd72
md"Map width (pixels) $(@bind w Slider(100:800, default=500, show_value=true))"

# ╔═╡ e38ef14e-7e73-11eb-06a5-edd0f493edc2
md"Map height (pixels) $(@bind h Slider(100:800, default=300, show_value=true))"

# ╔═╡ 768fd7b6-7e73-11eb-1826-d300c0ac0361
md"> Functions to manipulate and plot data"

# ╔═╡ 4db92e1e-7e73-11eb-1f5b-31c82d374367
md"> Data sets"

# ╔═╡ 6ed4d0f2-7e74-11eb-3ab4-cf6b6f9f9165
repo = dirname(pwd())

# ╔═╡ c3fcc170-7e74-11eb-2b2f-eddca7c8ee14
capitals = dataset("us-state-capitals")

# ╔═╡ c801c23e-7e74-11eb-3b83-6f05f1dd46e8
typeof(capitals)

# ╔═╡ 41241d02-7e74-11eb-083c-1b00e60e3985
lls = CSV.File(repo * "/data/simple-lls.cex", skipto
=2, delim="|") |> DataFrame

# ╔═╡ a5d80b70-7e72-11eb-364b-d54f4473e4e1
world110m = dataset("world-110m")

# ╔═╡ ae8aed3c-7e72-11eb-2004-3f41ad407fdd

function plotall()
    @vlplot(width=w, height=h) +
    @vlplot(
        projection={
		# Note this weirdness! elsewhere "type"!
			typ=:mercator
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
    data=capitals,
    longitude="lon:q",
    latitude="lat:q",
    color={value=:orange}
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
plotall()

# ╔═╡ Cell order:
# ╟─68adcd48-7e72-11eb-3313-4be9accf9305
# ╟─478229d4-7e72-11eb-27ec-47e443620d4c
# ╟─a6ba406e-7e73-11eb-30ef-5bcccea7fd72
# ╟─e38ef14e-7e73-11eb-06a5-edd0f493edc2
# ╟─b154a4ae-7e72-11eb-3239-517878a3a6fb
# ╟─768fd7b6-7e73-11eb-1826-d300c0ac0361
# ╠═ae8aed3c-7e72-11eb-2004-3f41ad407fdd
# ╟─4db92e1e-7e73-11eb-1f5b-31c82d374367
# ╠═6ed4d0f2-7e74-11eb-3ab4-cf6b6f9f9165
# ╠═c3fcc170-7e74-11eb-2b2f-eddca7c8ee14
# ╠═c801c23e-7e74-11eb-3b83-6f05f1dd46e8
# ╟─41241d02-7e74-11eb-083c-1b00e60e3985
# ╟─a5d80b70-7e72-11eb-364b-d54f4473e4e1
