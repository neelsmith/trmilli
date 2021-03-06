### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

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
	Pkg.status()
end

# ╔═╡ 478229d4-7e72-11eb-27ec-47e443620d4c
md"Replicate what works in a terminal"

# ╔═╡ a5d80b70-7e72-11eb-364b-d54f4473e4e1
world110m = dataset("world-110m")

# ╔═╡ ae8aed3c-7e72-11eb-2004-3f41ad407fdd

function viewglobal()
    @vlplot(width=300, height=150) +
    @vlplot(
        projection={typ=:mercator},
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
    )
end

# ╔═╡ b154a4ae-7e72-11eb-3239-517878a3a6fb
viewglobal()

# ╔═╡ Cell order:
# ╟─68adcd48-7e72-11eb-3313-4be9accf9305
# ╟─478229d4-7e72-11eb-27ec-47e443620d4c
# ╟─a5d80b70-7e72-11eb-364b-d54f4473e4e1
# ╠═b154a4ae-7e72-11eb-3239-517878a3a6fb
# ╠═ae8aed3c-7e72-11eb-2004-3f41ad407fdd
