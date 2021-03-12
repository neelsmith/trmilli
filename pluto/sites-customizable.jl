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
	using Query
	using CitableText
	Pkg.status()
end

# ╔═╡ 478229d4-7e72-11eb-27ec-47e443620d4c
md"## Plot Lycian sites interactively"

# ╔═╡ 7d9c436a-8057-11eb-270b-0164b9796a2e
md"> Customize map display"

# ╔═╡ ddef4c98-7e7d-11eb-162e-eb715aaba907
md"*Projection*"

# ╔═╡ 772eba2e-8059-11eb-13d8-55ae56dd0534
scalefactor = 32000

# ╔═╡ 407e6992-7e84-11eb-148e-23f00a55f412
#md"*Zoom* **-**$(@bind scalefactor Slider(2000:9000, default=2000, show_value=true))**+**"

# ╔═╡ 88d858ac-8059-11eb-3266-39be4ddbea99
rot1 = -29.6

# ╔═╡ 8d09587c-8059-11eb-3d8b-1502b8fd0af1
rot2 = -36.6

# ╔═╡ 10156f3c-7e7d-11eb-0e8b-83315a983280
#md"""
#*Pan* 
#**lon +**$(@bind rot1 Slider(-30:-50, default=-40, show_value=true))**-**
#**lat +** $(@bind rot2 Slider(-20:-55, default=-36, show_value=true))**-**
#"""

# ╔═╡ 15eb7c28-7e7d-11eb-331b-c16c9a1cfb34
md"*Display size*"

# ╔═╡ e38ef14e-7e73-11eb-06a5-edd0f493edc2
md"Map height (pixels) $(@bind h Slider(100:800, default=700, show_value=true))"

# ╔═╡ a6ba406e-7e73-11eb-30ef-5bcccea7fd72
md"Map width (pixels) $(@bind w Slider(100:800, default=900, show_value=true))"

# ╔═╡ 768fd7b6-7e73-11eb-1826-d300c0ac0361
md"> Functions to manipulate and plot data"

# ╔═╡ 48185b78-7e76-11eb-3755-e75f9d869a32
projdict = 
	Dict(
	"Natural earth" => :naturalEarth1,
	"Mercator" => :mercator,
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

# ╔═╡ 66a5ad8a-7e7d-11eb-183b-3fd274a92798
md"Roll $(@bind rot3 Slider(-180:180, default=0, show_value=true))"

# ╔═╡ 4db92e1e-7e73-11eb-1f5b-31c82d374367
md"> Data sets"

# ╔═╡ 6ed4d0f2-7e74-11eb-3ab4-cf6b6f9f9165
repo = dirname(pwd())

# ╔═╡ b755dcae-8059-11eb-0492-e11a2cf13d38
   land10mfile = repo * "/data/aegean10m_tj.json"

# ╔═╡ cf4b7292-8059-11eb-041f-b36239267c09
data = begin
	land10m = JSON.parsefile(land10mfile)
	VegaDatasets.VegaJSONDataset(land10m,land10mfile)
end

	

# ╔═╡ 23479290-8055-11eb-3f25-7701cd558e3f
grat  = dataset("graticule")

# ╔═╡ 007ddf44-828a-11eb-3afb-c75f982c1295
textgeo = begin
	onlinetexts = CSV.File(repo * "/data/onlinegeo.cex", skipto
=2, delim="|") |> DataFrame
	onlinetexts |> dropmissing
end


# ╔═╡ 41241d02-7e74-11eb-083c-1b00e60e3985
# Lon-lat coordiantes for sites identified by RAGE ID.
lls = CSV.File(repo * "/data/simple-lls.cex", skipto
=2, delim="|") |> DataFrame

# ╔═╡ d6f542f6-828a-11eb-2c66-578edb80d4ee
ragetext = innerjoin(lls, textgeo, on = :rageid)

# ╔═╡ 015a2444-8286-11eb-09c1-033d3126a2f7
function textlist()
	namedf = @from inscr in ragetext begin
       @select {inscr.text}
       @collect DataFrame
 	end
	pushfirst!(namedf[:,:text], "")
	menu = Pair{AbstractString, AbstractString}[]
	for row in eachrow(namedf) 
		urn = CtsUrn(row.text)
		label = string(workcomponent(urn))#, " (", row.TLname,")")
		pr = row.text => label
		push!(menu, pr)
	end
	menu
end

# ╔═╡ 6a3c3c68-8286-11eb-3e64-ff1d63775a4b
md"*Text* $(@bind textchoice Select(textlist()))"

# ╔═╡ e2d46682-8286-11eb-1afc-cf239fa0a413
# USED JOIED DATA
overlay = begin
	 @from t in ragetext begin
        @where t.text == textchoice
        @select {t.TLname, t.lon, t.lat}
        @collect DataFrame
    end
end

# ╔═╡ ae8aed3c-7e72-11eb-2004-3f41ad407fdd
# Use interacitve values for:
# rot1, rot2, rot3
function plotall(proj) 		
    @vlplot(width=w, height=h) +
	@vlplot(
		 projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
			scale=scalefactor
		},
		mark={
            :geoshape,
            fill=:transparent,
            stroke=:steelblue
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
        projection={
			type=proj,
			rotate=[rot1,rot2,rot3],
			scale=scalefactor
		},
        mark={
            :geoshape,
            fill=:lightgray,
            stroke=:white
        },
        data={
            values=data,
            format={
                type=:topojson,
                feature=:aegean10m
            }
        }
    ) 	+ 
	@vlplot(
    :circle,
	 projection={
		type=proj,
		rotate=[rot1,rot2,rot3],
		scale=scalefactor
	},
    data=lls,
    longitude="lon:q",
    latitude="lat:q",
	size={value=50},
    color={value=:orange} 
) +
    @vlplot(
    :circle,
	 projection={
		type=proj,
		rotate=[rot1,rot2,rot3],
		scale=scalefactor
	},
    data=overlay,
    longitude="lon:q",
    latitude="lat:q",
    size={value=20},
    color={value=:steelblue} 
    )   +
    @vlplot(
        mark={
            type=:text,
            dy=-10,
            color=:steelblue
        },
        projection={
            type=proj,
            rotate=[rot1,rot2,rot3],
            scale=scalefactor
        },
        data=overlay,
        longitude="lon:q",
        latitude="lat:q",
				size={value=18},
        text={
            field=:TLname,
            type=:nominal
        }
    )
end


# ╔═╡ b154a4ae-7e72-11eb-3239-517878a3a6fb
if isempty(proj)
	
	plotall(:naturalEarth1)
else
	plotall(projdict[proj])
end

# ╔═╡ d1c0a5fc-828d-11eb-2105-37471fe4b3d1
textlist() 

# ╔═╡ Cell order:
# ╟─68adcd48-7e72-11eb-3313-4be9accf9305
# ╟─478229d4-7e72-11eb-27ec-47e443620d4c
# ╟─6a3c3c68-8286-11eb-3e64-ff1d63775a4b
# ╠═b154a4ae-7e72-11eb-3239-517878a3a6fb
# ╟─7d9c436a-8057-11eb-270b-0164b9796a2e
# ╟─ddef4c98-7e7d-11eb-162e-eb715aaba907
# ╟─a78c54ca-7e76-11eb-3fbd-6d09ca6d108f
# ╠═772eba2e-8059-11eb-13d8-55ae56dd0534
# ╟─407e6992-7e84-11eb-148e-23f00a55f412
# ╠═88d858ac-8059-11eb-3266-39be4ddbea99
# ╠═8d09587c-8059-11eb-3d8b-1502b8fd0af1
# ╟─10156f3c-7e7d-11eb-0e8b-83315a983280
# ╟─15eb7c28-7e7d-11eb-331b-c16c9a1cfb34
# ╟─e38ef14e-7e73-11eb-06a5-edd0f493edc2
# ╟─a6ba406e-7e73-11eb-30ef-5bcccea7fd72
# ╟─768fd7b6-7e73-11eb-1826-d300c0ac0361
# ╠═ae8aed3c-7e72-11eb-2004-3f41ad407fdd
# ╠═e2d46682-8286-11eb-1afc-cf239fa0a413
# ╟─08287ce0-7e7a-11eb-159d-cb96c850b4f9
# ╟─48185b78-7e76-11eb-3755-e75f9d869a32
# ╟─66a5ad8a-7e7d-11eb-183b-3fd274a92798
# ╟─4db92e1e-7e73-11eb-1f5b-31c82d374367
# ╟─b755dcae-8059-11eb-0492-e11a2cf13d38
# ╟─cf4b7292-8059-11eb-041f-b36239267c09
# ╟─6ed4d0f2-7e74-11eb-3ab4-cf6b6f9f9165
# ╟─23479290-8055-11eb-3f25-7701cd558e3f
# ╟─d6f542f6-828a-11eb-2c66-578edb80d4ee
# ╠═007ddf44-828a-11eb-3afb-c75f982c1295
# ╟─41241d02-7e74-11eb-083c-1b00e60e3985
# ╟─d1c0a5fc-828d-11eb-2105-37471fe4b3d1
# ╠═015a2444-8286-11eb-09c1-033d3126a2f7
