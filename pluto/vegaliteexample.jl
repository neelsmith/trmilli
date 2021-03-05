### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ b9707df6-7dc9-11eb-1b28-ad8869a2f6b5
begin
	using Pkg
	Pkg.activate(".")
	using VegaLite
	using VegaDatasets
	using CSV
	using DataFrames
end

# ╔═╡ 87c1454c-7dc9-11eb-33e8-b9387688992d
md"Try plotting maps with VegaLite"

# ╔═╡ ffde068c-7dc9-11eb-3c2d-35116fac7fd7
us10m = dataset("us-10m")

# ╔═╡ 3d27fbba-7dca-11eb-39fc-2f88b747c238
unemployment = dataset("unemployment")



# ╔═╡ 5a4d8efc-7dda-11eb-22cb-bf0945bad3c7
function plot1()
	@vlplot(
    :geoshape,
    width=500, height=300,
    data={
        values=us10m,
        format={
            type=:topojson,
            feature=:counties
        }
    },
    transform=[{
        lookup=:id,
        from={
            data=unemployment,
            key=:id,
            fields=["rate"]
        }
    }],
    projection={
        type=:albersUsa
    },
    color="rate:q"
)
end


# ╔═╡ 45d1d7e0-7dca-11eb-012d-69d1569730f1
plot1()


# ╔═╡ 0e0ea86e-7dcb-11eb-11e9-8ddcbad4b5b8
airports = dataset("airports")


# ╔═╡ 11c23868-7dcb-11eb-1c66-bd4cbe14b496
typeof(airports)

# ╔═╡ 556e86e8-7dcb-11eb-1ce0-2b3331908e5a
airportsdf = airports |> DataFrame

# ╔═╡ b87f7cc4-7dcb-11eb-1fe5-a12acb5a2dce
airportsdf |> @vlplot(:circle,longitude=:longitude, latitude=:latitude, projection={type=:albersUsa}, size={value=10},
    color={value=:steelblue}
)

# ╔═╡ fc31ca32-7dcb-11eb-34e9-7f5fa6a50346
function plotll(df)
	@vlplot(:circle,
		data = df,
		longitude=:longitude, 
		latitude=:latitude, 
		projection={type=:conicEqualArea}, 
		size={value=10},
	    color={value=:steelblue}
		)
end

# ╔═╡ 24f8b0fa-7dcc-11eb-2cc8-01a23b4a15cc
airportsdf |> plotll

# ╔═╡ Cell order:
# ╟─87c1454c-7dc9-11eb-33e8-b9387688992d
# ╠═b9707df6-7dc9-11eb-1b28-ad8869a2f6b5
# ╠═ffde068c-7dc9-11eb-3c2d-35116fac7fd7
# ╠═3d27fbba-7dca-11eb-39fc-2f88b747c238
# ╟─5a4d8efc-7dda-11eb-22cb-bf0945bad3c7
# ╠═45d1d7e0-7dca-11eb-012d-69d1569730f1
# ╟─0e0ea86e-7dcb-11eb-11e9-8ddcbad4b5b8
# ╟─11c23868-7dcb-11eb-1c66-bd4cbe14b496
# ╟─556e86e8-7dcb-11eb-1ce0-2b3331908e5a
# ╠═b87f7cc4-7dcb-11eb-1fe5-a12acb5a2dce
# ╠═fc31ca32-7dcb-11eb-34e9-7f5fa6a50346
# ╠═24f8b0fa-7dcc-11eb-2cc8-01a23b4a15cc
