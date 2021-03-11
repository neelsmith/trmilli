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
	using Markdown
	Pkg.status()
end

# ╔═╡ 478229d4-7e72-11eb-27ec-47e443620d4c
md"## Plot Lycian sites"

# ╔═╡ 7d8cbce0-82a7-11eb-0a34-e30af2350db2
md"""Select a text to see its location on the map.
Follow links to full edition on Dane Scott's Trmilli site.
"""

# ╔═╡ 768fd7b6-7e73-11eb-1826-d300c0ac0361
md"""


---

> Functions to manipulate and plot data

"""

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
# USED JOINED DATA
overlay = begin
	 @from t in ragetext begin
        @where t.text == textchoice
        @select {t.TLname, t.lon, t.lat, t.text}
        @collect DataFrame
    end
end

# ╔═╡ ae8aed3c-7e72-11eb-2004-3f41ad407fdd

function plotall()
	proj = :naturalEarth1
	scalefactor = 32000
	h=700
	w=900
	rot1 = -29.6
	rot2 = -36.6
	rot3 = 0
    @vlplot(width=w, height=h) +
	
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
plotall()


# ╔═╡ 1fe37518-82a5-11eb-300d-dd191b08828c
function labelsite()
	baseurl = "https://descot21.github.io/Lycian/Texts/" #tl_4/"
	sname = overlay[1, :TLname]
	urn = CtsUrn(overlay[1, :text])
	workparts = workcomponent(urn) |> CitableText.parts
	pageid = join([workparts[1], workparts[2]], "_")
	url = baseurl * pageid
	label = ""
	if (workparts[1] == "tl")
		label = string("*Tituli Lycii* ", workparts[2])
	else
		label = string("Neumann, *Neufunder lykischer Inschriften* ", workparts[2])
	end
	Markdown.parse("""### $(label), from $(sname)

`$(urn.urn)` See [online edition]($(url))

	""")
end


# ╔═╡ 59123500-82a7-11eb-2b80-bff7420440ba
labelsite()

# ╔═╡ d1c0a5fc-828d-11eb-2105-37471fe4b3d1
textlist() 

# ╔═╡ Cell order:
# ╟─68adcd48-7e72-11eb-3313-4be9accf9305
# ╟─478229d4-7e72-11eb-27ec-47e443620d4c
# ╟─7d8cbce0-82a7-11eb-0a34-e30af2350db2
# ╟─6a3c3c68-8286-11eb-3e64-ff1d63775a4b
# ╟─59123500-82a7-11eb-2b80-bff7420440ba
# ╟─b154a4ae-7e72-11eb-3239-517878a3a6fb
# ╟─768fd7b6-7e73-11eb-1826-d300c0ac0361
# ╟─ae8aed3c-7e72-11eb-2004-3f41ad407fdd
# ╟─1fe37518-82a5-11eb-300d-dd191b08828c
# ╟─e2d46682-8286-11eb-1afc-cf239fa0a413
# ╟─4db92e1e-7e73-11eb-1f5b-31c82d374367
# ╟─b755dcae-8059-11eb-0492-e11a2cf13d38
# ╟─cf4b7292-8059-11eb-041f-b36239267c09
# ╟─6ed4d0f2-7e74-11eb-3ab4-cf6b6f9f9165
# ╟─23479290-8055-11eb-3f25-7701cd558e3f
# ╟─d6f542f6-828a-11eb-2c66-578edb80d4ee
# ╟─007ddf44-828a-11eb-3afb-c75f982c1295
# ╟─41241d02-7e74-11eb-083c-1b00e60e3985
# ╟─d1c0a5fc-828d-11eb-2105-37471fe4b3d1
# ╟─015a2444-8286-11eb-09c1-033d3126a2f7
