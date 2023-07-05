
module Spectra

using AxisArrays

struct Spectrum{T,D,Ax} <: AxisArrays.AbstractAxisArray{T,2,D,Ax}
    data::D
    axes::Ax

    # Spectrum{T,D,Ax}(data::AbstractMatrix{T}, axs::Tuple{Axis, Axis}) where {T,D,Ax} = new{T,D,Ax}(data, axs)

    # function Spectrum(S::AbstractMatrix{T}, ω::AbstractVector, θ::AbstractVector) where T
    #     tmp = AxisArray(S, angularfrequengy=ω, direction=θ)
    #     return new{T,D,Ax}(tmp.data, tmp.axes)
    # end
end

struct AAxisArray{T,N,D,Ax} <: AxisArrays.AbstractAxisArray{T,N,D,Ax}
    data::D  # D <:AbstractArray, enforced in constructor to avoid dispatch bugs (https://github.com/JuliaLang/julia/issues/6383)
    axes::Ax # Ax<:NTuple{N, Axis}, but with specialized Axis{...} types
    AAxisArray{T,N,D,Ax}(data::AbstractArray{T,N}, axs::Tuple{Vararg{Axis,N}}) where {T,N,D,Ax} = new{T,N,D,Ax}(data, axs)
end


# function _check_spectrum(spectrum::AxisArray)
# 	function _check_dimensions(vector::AbstractVector, dimensions_list::AbstractVector, name::String, dimensions_names::String)
# 		if !(dimension(vector[1])  in dimensions_list)
# 			error("The `$(name)` must have dimensions of $(dimensions_names).")
# 		end
# 		return nothing
# 	end

# 	function _check_typeconsistency(array::AbstractArray, name::String)
# 		if !(all(y->typeof(y)==eltype(array), array))
# 			error("All elements of `$(name)` must be of same type.")
# 		end
# 	end

# 	# frequency
# 	frequency = axisvalues(spectrum)[1]
# 	name = "frequency vector"
# 	_check_typeconsistency(frequency, name)
# 	_check_dimensions(frequency, [𝐓^-1, 𝐓, 𝐀/𝐓], name, "frequency, angular frequency, or period")

# 	# direction
# 	direction = axisvalues(spectrum)[2]
# 	name = "direction vector"
# 	_check_typeconsistency(direction, name)
# 	_check_dimensions(direction, [𝐀,], name, "angle")

# 	# spectrum
# 	data = spectrum.data
# 	name = "spectrum matrix"
# 	_check_typeconsistency(data, name)

# 	return nothing
# end

# function spectrum(data::AbstractMatrix, frequency::AbstractVector, direction::AbstractVector)
# 	spectrum = AxisArray(data, frequency=frequency, direction=direction)
# 	_check_spectrum(spectrum)
# 	return spectrum
# end

# # TODO: Account for frequency to period...
# function changeaxis(spectrum::AxisArray, axis::Symbol, units::Units, periodic::Bool=false)
# 	data = spectrum.data
# 	axisval = spectrum.axes[axis].val
# 	# 	frequency, direction = spectrum.axes[1].val, spectrum.axes[2].val

# 	uspectrum = unit(data[1, 1])
# 	uaxis = unit(axisval[1])
# # 	ufrequency, udirection = unit(frequency[1]), unit(direction[1])

# 	(axis==:frequency) && (axisval = uconvert.(units, axisval, Periodic()))
# 	axis==:direction && (axisval = uconvert.(units, axisval))
# # 	axis==:frequency && (frequency = uconvert.(units, direction, Periodic()))

# # 	ufrequencynew, udirectionnew = unit(frequency[1]), unit(direction[1])

# # 	data *= ufrequency * udirection / (ufrequencynew * udirectionnew)
# # 	spectrum = AxisArray(data, frequency=frequency, direction=direction)
# # 	_check_spectrum(spectrum)
# # 	return spectrum
# # end


# function integralunit(spectrum::AxisArray)
# 	uspectrum = unit(spectrum[1, 1])
# 	uaxis1 = unit(spectrum.axes[1][1])
# 	uaxis2 = unit(spectrum.axes[2][1])
# 	return uspectrum*uaxis1*uaxis2
# end


# function integral(spectrum::AxisArray)
# end












## OLD OLD
# using Unitful
# using Unitful: Hz, °

# struct WaveSpectrum{T<:Union{Number,Quantity}} <: AbstractArray{T,2}
#     spectrum::Array{T,2}
#     frequency::Vector{typeof(1.0Hz)}
#     direction::Vector{typeof(1°)}
#     function WaveSpectrum(spectrum, frequency, direction)
#         if size(spectrum) != (length(frequency), length(direction))
#             error("Size of spectrum does not match size of frequency and direction arrays.")
#         end
#         # TODO: Check that all units in S are the same
#         new{typeof(spectrum).parameters[1]}(spectrum, frequency, direction)
#     end
# end

# Base.size(ws::WaveSpectrum) = size(ws.spectrum)
# Base.getindex(ws::WaveSpectrum, i...) = ws.spectrum[i...]
# Base.setindex!(ws::WaveSpectrum, value, i...) = ws.spectrum[i...] = value

# # S = [1.0 2; 3 4] * u"m*m/Hz"
# # f = [1.0Hz, 2.0Hz]
# # d = [0°, 10.0°]

# include("ndbc.jl")
# buoy = 41001
# year = 2021
# sw = NDBC.request_directional_data(buoy, year)
# S = transpose(sw[1:1, :, :den])
# f = S.axes[1].val
# d = [0.0°,]

# 🌊 = WaveSpectrum(S, f, d)


# using Geodesy: LonLat
# LonLat(12°, 13.32°)


end
