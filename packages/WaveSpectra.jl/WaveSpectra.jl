
using Unitful
using Unitful: Hz, °

struct WaveSpectrum{T<:Union{Number,Quantity}} <: AbstractArray{T,2}
    spectrum::Array{T,2}
    frequency::Vector{typeof(1.0Hz)}
    direction::Vector{typeof(1°)}
    function WaveSpectrum(spectrum, frequency, direction)
        if size(spectrum) != (length(frequency), length(direction))
            error("Size of spectrum does not match size of frequency and direction arrays.")
        end
        # TODO: Check that all units in S are the same
        new{typeof(spectrum).parameters[1]}(spectrum, frequency, direction)
    end
end

Base.size(ws::WaveSpectrum) = size(ws.spectrum)
Base.getindex(ws::WaveSpectrum, i...) = ws.spectrum[i...]
Base.setindex!(ws::WaveSpectrum, value, i...) = ws.spectrum[i...] = value

# S = [1.0 2; 3 4] * u"m*m/Hz"
# f = [1.0Hz, 2.0Hz]
# d = [0°, 10.0°]

include("ndbc.jl")
buoy = 41001
year = 2021
sw = NDBC.request_directional_data(buoy, year)
S = transpose(sw[1:1, :, :den])
f = S.axes[1].val
d = [0.0°,]

🌊 = WaveSpectrum(S, f, d)


using Geodesy: LonLat
LonLat(12°, 13.32°)
