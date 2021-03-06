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

# ╔═╡ ef180354-7e62-11eb-3350-93df9a2eca8c
begin
	using Pkg
	Pkg.activate(".")	
	Pkg.instantiate()
	using PlutoUI
	using VegaLite
	using VegaDatasets
	using CSV
	using DataFrames
	using JSON
	Pkg.status()
end

# ╔═╡ ae80871c-7e62-11eb-2777-3d69c6f3ec6d
md"Trmilli: sites"

# ╔═╡ 36bc0198-7e67-11eb-38e5-9fab1266a06c
md"> ## VegaLite data sets"

# ╔═╡ 2e2cc638-7e68-11eb-07d3-b5c4631fe8bc
md"Rotate $(@bind rot Slider(-180:180, show_value=true, default=0))"

# ╔═╡ 860938f6-7e67-11eb-09c1-01f694cb41b9
function grat() 
@vlplot(width=500, height=300) +
@vlplot(
    mark={
        :geoshape,
        fill=:aliceblue,
        stroke=:gray
    },
    data={
       graticule=true
    },
    projection={
		type=:orthographic,
			rotate=[0, rot, 0
				]
			},
				)
end

# ╔═╡ a468b98e-7e67-11eb-3317-8b301b2764ba
grat()

# ╔═╡ 9fcc4584-7e63-11eb-1806-33298a38e758
bg =  dataset("world-110m")

# ╔═╡ ddf33cb4-7e63-11eb-21c2-83afd1119f66
bg

# ╔═╡ 25db64b8-7e67-11eb-0480-5720037d5c24
md">## My own data, nothing works"

# ╔═╡ cea5b656-7e63-11eb-043a-4ddd05e0d2b4
geosrc = "https://raw.githubusercontent.com/neelsmith/trmilli/master/data/ne-countries-110m-topojson.json"

# ╔═╡ ba48edb6-7e63-11eb-2b84-8b12ae622289

@vlplot(width=500, height=300) +
@vlplot(
    mark={
        :geoshape,
        fill=:lightgray,
        stroke=:white
    },
    data={
        url=geosrc,
        format={
            type=:topojson,
		
        }
    },
    projection={type=:albersUsa},
)

# ╔═╡ 507cc3c0-7e66-11eb-0b0b-533f62b1e8f7
jsonfile = dirname(pwd()) * "/data/ne-countries-110m-topojson.json"

# ╔═╡ 64e72698-7e66-11eb-0231-57ec4e0a237b
boundaries = JSON.parsefile(jsonfile)

# ╔═╡ bf2c5396-7e66-11eb-282b-95ea8b8d0349
#plotlocal()

# ╔═╡ 8941ce76-7e66-11eb-1b72-d35760fec250

function plotlocal()
@vlplot(width=500, height=300) +
@vlplot(
    mark={
        :geoshape,
        fill=:lightgray,
        stroke=:white
    },
    data={
        url=boundaries,
        format={
            type=:topojson
        }
    },
    projection={type=:albersUsa},
)
end

# ╔═╡ Cell order:
# ╠═ef180354-7e62-11eb-3350-93df9a2eca8c
# ╟─ae80871c-7e62-11eb-2777-3d69c6f3ec6d
# ╟─36bc0198-7e67-11eb-38e5-9fab1266a06c
# ╠═a468b98e-7e67-11eb-3317-8b301b2764ba
# ╟─2e2cc638-7e68-11eb-07d3-b5c4631fe8bc
# ╟─860938f6-7e67-11eb-09c1-01f694cb41b9
# ╠═9fcc4584-7e63-11eb-1806-33298a38e758
# ╠═ddf33cb4-7e63-11eb-21c2-83afd1119f66
# ╠═ba48edb6-7e63-11eb-2b84-8b12ae622289
# ╟─25db64b8-7e67-11eb-0480-5720037d5c24
# ╟─cea5b656-7e63-11eb-043a-4ddd05e0d2b4
# ╟─507cc3c0-7e66-11eb-0b0b-533f62b1e8f7
# ╟─64e72698-7e66-11eb-0231-57ec4e0a237b
# ╠═bf2c5396-7e66-11eb-282b-95ea8b8d0349
# ╠═8941ce76-7e66-11eb-1b72-d35760fec250
