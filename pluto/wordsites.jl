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

# ╔═╡ 2d3cebbc-8303-11eb-099f-677367053aa6
begin
	using Pkg
	Pkg.activate(".")
	Pkg.instantiate()
	using PlutoUI
	using CSV, DataFrames, Query
	using VegaLite, VegaDatasets, JSON
	using CitableText
	using Lycian
end

# ╔═╡ cfcf046c-8302-11eb-00ef-919718cd7e73
md"""
### Sites where words appear


> - Enter text in the `trmilli` project's ASCII-based transcription.
> - When you have entered *a complete token*, check `Plot map now`
>
> To prevent the notebook from trying to construct a complex map every time
> you type a letter, uncheck `Plot map now` while you're entering text.


"""

# ╔═╡ 0775cac6-8304-11eb-22b9-d7dd833c1c6e
md"**Text in transcription**: $(@bind src TextField())"

# ╔═╡ 8be7db68-8308-11eb-06df-bd24be3d137a
md"**Shortest autocompletion**:"

# ╔═╡ 058ef6ca-833f-11eb-1c38-a3fbe167d35d
md"**Plot map now** $(@bind plotnow CheckBox())"

# ╔═╡ d7a5b7ce-8340-11eb-1d4c-b3badea67027
if plotnow
	md""
else
	md"Check `Plot map now` to display a map with geography of your selected token."
end

# ╔═╡ 07e701ce-833f-11eb-1b5a-d912e1b0e36c
if plotnow && (length(tokenrecords) > 0))
	plotall()
else
	md""
end

# ╔═╡ 6506b238-833e-11eb-2810-55e052197f62


# ╔═╡ dcb6078a-8306-11eb-2198-4944a386e780
css  = html"""
<style>
.gray {
 color: silver;
}
</style>
"""

# ╔═╡ ca6799c0-8308-11eb-10f3-73c346876720
md"""

---

> Data reformatted for notebook manipulation.
"""

# ╔═╡ 66cfd638-8336-11eb-1040-adf56f5c91f1
md">Raw data sets"

# ╔═╡ cc9eced0-8339-11eb-0ec1-f5d5fb6226a7
md"Where we're working in the local file system:"

# ╔═╡ 25f9294a-8334-11eb-10f0-578b53e5adf7
repo = dirname(pwd())

# ╔═╡ eb038580-8342-11eb-2ac2-e199eb9cd846
md"Map background loaded from TopoJson data"

# ╔═╡ dd050a20-833c-11eb-1cde-9333e9ad1124
# Clip to Aegean region of Mike Bostock's global 10-m resolution land data set
land10mfile = repo * "/data/aegean10m_tj.json"

# ╔═╡ 7264e112-833d-11eb-0014-7beaf57bbade
# For plotting with VegaLite, we need to convert TopoJson to a VegaDataset
vldata = begin
	land10m = JSON.parsefile(land10mfile)
	VegaDatasets.VegaJSONDataset(land10m,land10mfile)
end

# ╔═╡ 997137aa-8339-11eb-1274-f1bff8b96b7c
md"""We work from:

- a concordance of tokens to text passage
- an association of texts with geographic identifiers
- a collection of geographic entities including geographic coordinates
"""

# ╔═╡ 0592bdde-832e-11eb-23f7-29496e63fbe7
concordance = CSV.File(repo * "/data/concordance.cex", skipto
=2, delim="|") |> DataFrame

# ╔═╡ 127be16a-8338-11eb-1a32-67adc32a8a59
# Simplify text URNs by dropping version and passage
concclean = begin
	rows = []
	for r in eachrow(concordance)
		cleanu = CtsUrn(r.urn) |> CitableText.dropversion |> CitableText.droppassage
		push!(rows, (r.token, addversion(cleanu, "v1").urn))
	end
	tokencol = map(r -> r[1],rows)
	urncol = map(r -> r[2],rows)
	DataFrame(urn = urncol, token = tokencol)

end


# ╔═╡ fac6fcdc-8335-11eb-350f-a58a7dcf19c6
textgeo = begin
	onlinetexts = CSV.File(repo * "/data/onlinegeo.cex", skipto
=2, delim="|") |> DataFrame
	onlinetexts |> dropmissing
end

# ╔═╡ 494cd872-8336-11eb-0316-b5e86ebbbe6f
# Lon-lat coordiantes for sites identified by RAGE ID.
lls = CSV.File(repo * "/data/simple-lls.cex", skipto
=2, delim="|") |> DataFrame

# ╔═╡ 022c7586-8336-11eb-3182-91dfdc25d7c8
ragetext = innerjoin(lls, textgeo, on = :rageid)

# ╔═╡ 57d90af2-8339-11eb-24ab-4382be68a01e
tokengeo = innerjoin(ragetext, concclean, on = :text => :urn)

# ╔═╡ afb44b3c-8335-11eb-2124-4d00d6ae9793
wordlist = tokengeo[:, :token]

# ╔═╡ 4f547796-8306-11eb-137b-d7ae4e391a83
begin
	if isempty(src)
		md""

		
	else
		matches = filter(s -> startswith(s, src), wordlist)
		if isempty(matches)
			HTML("<span class='gray'>(no matches)</span>")
		else 
			ascii = matches[1]
			completion = replace(ascii, src => "")
			asciihtml = "<i>ascii</i>: <b>$(src)</b><span class='gray'>$(completion)</span>"
			
			lyccomplete = replace(completion, "-" => "") |> Lycian.ucode
			lycstart = Lycian.ucode(ascii)
			lyc = "<i>unicode</i>: <b>$(lycstart)</b><span class='gray'>$(lyccomplete)</span>"
			HTML("<p>$(asciihtml)</p><p>$lyc</p>")
			
		end
		
	end
end


# ╔═╡ a45446fc-8335-11eb-00b7-476e6c6f8e85
tokenrecords = begin
	if plotnow
	if src in wordlist
	tokensites =  @from t in tokengeo begin
			   @where t.token == src
			   @select {t.lon, t.lat, t.TLname, t.token, t.text}
			@collect
		  end;
	tokensites

	else
		md""
	end
	else
		md""
	end
end

# ╔═╡ 5f416700-8341-11eb-0b3b-5ba0357ca6a6
if plotnow
	md"""
	*$(src)* found in **$(length(tokenrecords)) texts**.
	"""

else
	md""
end

# ╔═╡ 11359256-833d-11eb-2eef-41841b8f4dcd
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
            values=vldata,
            format={
                type=:topojson,
                feature=:aegean10m
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
		data=tokenrecords,
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
        data=tokenrecords,
        longitude="lon:q",
        latitude="lat:q",
				size={value=18},
        text={
            field=:TLname,
            type=:nominal
        }
    )
end
	

# ╔═╡ Cell order:
# ╟─2d3cebbc-8303-11eb-099f-677367053aa6
# ╟─cfcf046c-8302-11eb-00ef-919718cd7e73
# ╟─0775cac6-8304-11eb-22b9-d7dd833c1c6e
# ╟─8be7db68-8308-11eb-06df-bd24be3d137a
# ╟─4f547796-8306-11eb-137b-d7ae4e391a83
# ╟─d7a5b7ce-8340-11eb-1d4c-b3badea67027
# ╟─058ef6ca-833f-11eb-1c38-a3fbe167d35d
# ╟─5f416700-8341-11eb-0b3b-5ba0357ca6a6
# ╠═07e701ce-833f-11eb-1b5a-d912e1b0e36c
# ╟─6506b238-833e-11eb-2810-55e052197f62
# ╟─dcb6078a-8306-11eb-2198-4944a386e780
# ╟─ca6799c0-8308-11eb-10f3-73c346876720
# ╟─a45446fc-8335-11eb-00b7-476e6c6f8e85
# ╟─11359256-833d-11eb-2eef-41841b8f4dcd
# ╟─57d90af2-8339-11eb-24ab-4382be68a01e
# ╟─afb44b3c-8335-11eb-2124-4d00d6ae9793
# ╟─022c7586-8336-11eb-3182-91dfdc25d7c8
# ╟─127be16a-8338-11eb-1a32-67adc32a8a59
# ╟─66cfd638-8336-11eb-1040-adf56f5c91f1
# ╟─cc9eced0-8339-11eb-0ec1-f5d5fb6226a7
# ╟─25f9294a-8334-11eb-10f0-578b53e5adf7
# ╟─eb038580-8342-11eb-2ac2-e199eb9cd846
# ╟─7264e112-833d-11eb-0014-7beaf57bbade
# ╟─dd050a20-833c-11eb-1cde-9333e9ad1124
# ╟─997137aa-8339-11eb-1274-f1bff8b96b7c
# ╟─0592bdde-832e-11eb-23f7-29496e63fbe7
# ╟─fac6fcdc-8335-11eb-350f-a58a7dcf19c6
# ╟─494cd872-8336-11eb-0316-b5e86ebbbe6f
