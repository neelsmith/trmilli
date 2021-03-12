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
	using Lycian
end

# ╔═╡ cfcf046c-8302-11eb-00ef-919718cd7e73
md"""
### Lycian type-ahead



Enter text in the `trmilli` project's ASCII-based transcription.

The box below will display the shortest matching token in the `trmilli` corpus.

"""

# ╔═╡ 0775cac6-8304-11eb-22b9-d7dd833c1c6e
md"**Text in transcription**: $(@bind src TextField())"

# ╔═╡ 8be7db68-8308-11eb-06df-bd24be3d137a
md"**Shortest autocompletion**:"

# ╔═╡ ca6799c0-8308-11eb-10f3-73c346876720
md"""
> Data and CSS.
"""

# ╔═╡ b03c5070-8305-11eb-3af3-2d5388c69040
strs = begin
	f = dirname(pwd()) * "/data/lycindex.txt"
	open(f, "r") do io
       readlines(f)
     end
end

# ╔═╡ 4f547796-8306-11eb-137b-d7ae4e391a83
begin
	if isempty(src)
		md""

		
	else
		matches = filter(s -> startswith(s, src), strs)
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


# ╔═╡ dcb6078a-8306-11eb-2198-4944a386e780
css  = html"""
<style>
.gray {
 color: silver;
}
</style>
"""

# ╔═╡ Cell order:
# ╟─2d3cebbc-8303-11eb-099f-677367053aa6
# ╟─cfcf046c-8302-11eb-00ef-919718cd7e73
# ╟─0775cac6-8304-11eb-22b9-d7dd833c1c6e
# ╟─8be7db68-8308-11eb-06df-bd24be3d137a
# ╟─4f547796-8306-11eb-137b-d7ae4e391a83
# ╟─ca6799c0-8308-11eb-10f3-73c346876720
# ╟─b03c5070-8305-11eb-3af3-2d5388c69040
# ╟─dcb6078a-8306-11eb-2198-4944a386e780
