### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 0b630718-c1fe-11ec-0fdc-99e430584e3e
let
	using HTTP
	using TranscodingStreams, CodecZlib
	using DelimitedFiles
	using DataFrames
	using Dates
	using Unitful
	using Unitful: Hz, m
	using DimensionfulAngles: °ᵃ as °
	using AxisArrays
	using WGLMakie, GeoMakie
end;

# ╔═╡ e2646a89-0080-4f2f-a74c-76019514b6d0
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
		Expr(:toplevel,
			 :(eval(x) = $(Expr(:core, :eval))($name, x)),
			 :(include(x) = $(Expr(:top, :include))($name, x)),
			 :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
			 :(include($path))))
	m
end;

# ╔═╡ dd1f542a-908e-4d03-8a0d-6760bdcf338e
NDBC = ingredients("../src/NDBC.jl").NDBC

# ╔═╡ 05df6345-42d7-488d-a247-2e955b0b5dae
buoy = 46050;  # PACWAVE

# ╔═╡ 649f64b7-e242-423b-9ff0-1f568c7bc85d
year = 2021;

# ╔═╡ 46c3250a-a7ca-4ce0-85c7-182be1123271
bfile = false;

# ╔═╡ 1111572a-b296-4cd2-bb9c-6d972d5a968a
md"## Omnidirectional 
### available data"

# ╔═╡ 26a94f52-cd1c-46ab-85a8-b5442f7bbc16
swden = NDBC.available_omnidirectional()

# ╔═╡ 9bb11dd3-23b9-4008-8c33-e86cf4f08de9
pw_swden = NDBC.available_omnidirectional(buoy)

# ╔═╡ e0eba397-f8e0-4994-811e-1ecab58d5fcf
md"### request data"

# ╔═╡ 450c784c-fb18-412a-96c8-12199e856c50
data_swden = NDBC.request_omnidirectional(buoy, year, bfile)

# ╔═╡ 1b04055b-0826-43f7-921e-0d53e2f362fc
md"""
## Wave Spectrum
### available data
"""

# ╔═╡ b300df80-d71a-4110-9fa6-d78614f62f1b
avail = NDBC.available()

# ╔═╡ 10dc6bea-6bbe-494c-b0b7-f1f47cdb149f
avail_pw = NDBC.available(buoy)

# ╔═╡ 9ca4cc7f-a026-40a9-92f6-25ea47a98863
data = NDBC.request(buoy, year, bfile)

# ╔═╡ d5feb58c-70ad-49ee-9f20-91a46f729d51
md"## Read File"

# ╔═╡ 5e3cfc22-2b15-4e71-9414-556faf8a2961
d1 = NDBC.read("data/41001i2015.txt.gz")

# ╔═╡ 789de66b-8445-4835-bc7c-5cee9403be2a
d2 = NDBC.read("data/41001i2015.txt")

# ╔═╡ 499d0fdb-c755-4392-bb39-17961e65ca20
d3 = NDBC.read("data/41001i2015.txt.gz", "swdir2")

# ╔═╡ 15b415c2-6c77-4f7e-910d-6c97a6e52fd1
md"## Metadata"

# ╔═╡ 233f9e80-aee2-4f89-a0f2-4773c5903591
NDBC.metadata(buoy)

# ╔═╡ 58a0d5d7-55c7-4a45-9923-bcc2d30284ee
buoys = unique(NDBC.available()[!, :buoy])

# ╔═╡ 1dc65c09-11c1-4ca4-bbe4-cdfb55782d62
ulats, ulons = let
	lats, lons = zeros(length(buoys))*1°, zeros(length(buoys))*1°;
	for i ∈ 1:length(buoys)
		data = NDBC.metadata(buoys[i])
		lats[i] = data["Latitude"]
		lons[i] = data["Longitude"]
	end
	ulats, ulons = ustrip.(lats), ustrip.(lons)
	flag = @. !(isnan.(ulats))
	ulats[flag], ulons[flag]
end;

# ╔═╡ ebe63645-ec4d-4392-8d86-aacd59c2b9b4
let
	fig = Figure(resolution = (650, 650))
	ga = GeoAxis(
	    fig[1, 1];
		dest = "+proj=moll",
	)
	image!(ga, -180..180, -90..90, rotr90(GeoMakie.earth()); interpolate = false, inspectable=false) 
	scatter!(ga, ustrip.(ulons), ustrip.(ulats), color="tomato2", inspectable=true, inspector_label = (f,i,p) -> buoys[i])
	DataInspector(fig)
	fig
end

# ╔═╡ bd6b363e-a3de-46e6-8b97-3ffca511f067
md"""
## All data for a Buoy
### Wave spectra
"""

# ╔═╡ 0dafe61f-5adf-4262-a6d4-8cd527ee1df1
begin
	years = avail_pw.year
	deleteat!(years, findall(x->(x==2014 || x==2015), years)) # something wrong with the data in 2014 and 2015
end

# ╔═╡ 0db51b09-b88e-43fc-aab7-637e7d4f2033
begin
	alldata = NDBC.request(buoy, years[1], bfile)
	for i ∈ 2:length(years)
		alldata = cat(alldata, NDBC.request(buoy, years[i], bfile); dims=1)
	end
end

# ╔═╡ 950dc473-bc0c-4613-99de-92b521066c33
alldata

# ╔═╡ 6574a0ad-a16a-4ec0-b8b9-78c8cfa72f35
size(alldata)

# ╔═╡ cb9264f4-4d6a-4914-b6c1-660585ba527c
typeof(alldata)

# ╔═╡ 0082a8aa-88d8-422f-9890-7be383f82d87
alldata.axes

# ╔═╡ Cell order:
# ╠═0b630718-c1fe-11ec-0fdc-99e430584e3e
# ╠═e2646a89-0080-4f2f-a74c-76019514b6d0
# ╠═dd1f542a-908e-4d03-8a0d-6760bdcf338e
# ╠═05df6345-42d7-488d-a247-2e955b0b5dae
# ╠═649f64b7-e242-423b-9ff0-1f568c7bc85d
# ╠═46c3250a-a7ca-4ce0-85c7-182be1123271
# ╟─1111572a-b296-4cd2-bb9c-6d972d5a968a
# ╠═26a94f52-cd1c-46ab-85a8-b5442f7bbc16
# ╠═9bb11dd3-23b9-4008-8c33-e86cf4f08de9
# ╟─e0eba397-f8e0-4994-811e-1ecab58d5fcf
# ╠═450c784c-fb18-412a-96c8-12199e856c50
# ╟─1b04055b-0826-43f7-921e-0d53e2f362fc
# ╠═b300df80-d71a-4110-9fa6-d78614f62f1b
# ╠═10dc6bea-6bbe-494c-b0b7-f1f47cdb149f
# ╠═9ca4cc7f-a026-40a9-92f6-25ea47a98863
# ╟─d5feb58c-70ad-49ee-9f20-91a46f729d51
# ╠═5e3cfc22-2b15-4e71-9414-556faf8a2961
# ╠═789de66b-8445-4835-bc7c-5cee9403be2a
# ╠═499d0fdb-c755-4392-bb39-17961e65ca20
# ╟─15b415c2-6c77-4f7e-910d-6c97a6e52fd1
# ╠═233f9e80-aee2-4f89-a0f2-4773c5903591
# ╠═58a0d5d7-55c7-4a45-9923-bcc2d30284ee
# ╠═1dc65c09-11c1-4ca4-bbe4-cdfb55782d62
# ╠═ebe63645-ec4d-4392-8d86-aacd59c2b9b4
# ╟─bd6b363e-a3de-46e6-8b97-3ffca511f067
# ╠═0dafe61f-5adf-4262-a6d4-8cd527ee1df1
# ╠═0db51b09-b88e-43fc-aab7-637e7d4f2033
# ╠═950dc473-bc0c-4613-99de-92b521066c33
# ╠═6574a0ad-a16a-4ec0-b8b9-78c8cfa72f35
# ╠═cb9264f4-4d6a-4914-b6c1-660585ba527c
# ╠═0082a8aa-88d8-422f-9890-7be383f82d87
