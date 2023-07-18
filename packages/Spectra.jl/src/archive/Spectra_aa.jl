
# module Spectra

# import Unitful.unit

# using AxisArrays: AxisArray, Axis
# using Unitful: Quantity, Units, 𝐓, 𝐋, dimension
# using DimensionfulAngles: 𝐀

# export spectrum, isspectrum, typefrequency

# _IFREQUENCY = 1
# _IDIRECTION = 2

# Spectrum = AxisArray{
#     T,
#     2,
#     <:AbstractMatrix{T},
#     <:Tuple{
#         Axis{:frequency, <:AbstractVector{<:Union{
#             Quantity{S, 𝐓^-1},
#             Quantity{S, 𝐓},
#             Quantity{S, 𝐀*𝐓^-1},
#             Quantity{S, 𝐓*𝐀^-1},
#             Quantity{S, 𝐋^-1},
#             Quantity{S, 𝐋},
#             Quantity{S, 𝐀*𝐋^-1},
#             Quantity{S, 𝐋*𝐀^-1}
#         }}},
#         Axis{:direction, <:AbstractVector{<:Quantity{S, 𝐀}}}
#     }
# } where {T<:Quantity{S}} where S

# function spectrum(
#                   data::AbstractMatrix{<:Quantity},
#                   frequency::AbstractVector,
#                   direction::AbstractVector{<:Quantity{T, 𝐀} where T}
#                   )::Spectrum
#     # promotion
#     tdata = typeof(data).parameters[1].parameters[1]
#     tfrequency = typeof(frequency).parameters[1].parameters[1]
#     tdirection = typeof(direction).parameters[1].parameters[1]
#     commontype = Base.promote_type(tdata, tfrequency, tdirection)
#     data = data .|> commontype
#     frequency = frequency .|> commontype
#     direction = direction .|> commontype
#     # type consistency
#     function _check_typeconsistency(array::AbstractArray, name::String)
#         if !(all(y->typeof(y)==eltype(array), array))
#             error("All elements of `$(name)` must be of same type.")
#         end
#         return nothing
#     end
#     _check_typeconsistency(frequency, "`frequency` vector")
#     _check_typeconsistency(direction, "`direction` vector")
#     _check_typeconsistency(direction, "`data` matrix")
#     AxisArray
#     return AxisArray(data, frequency=frequency, direction=direction)
# end

# function unit(spectrum::Spectrum, quantity::Symbol=:spectrum) :: Units
#     uspectrum = unit(spectrum[1, 1])
# 	ufrequency = unit(spectrum.axes[_IFREQUENCY][1])
# 	udirection = unit(spectrum.axes[_IDIRECTION][1])
#     ureturn = begin
#         quantity == :spectrum ? uspectrum :
#         quantity == :frequency ? ufrequency :
#         quantity == :direction ? udirection :
#         quantity == :integral ? uspectrum*ufrequency*udirection :
#         error("Unsuported quantity $(quantity).")
#     end
#     return ureturn
# end

# function isspectrum(spectrum) :: Bool
#     return typeof(spectrum) <: Spectrum
# end

# function convert_spectrum(spectrum::Spectrum)::Spectrum
# end

# function integral(spectrum::Spectrum, axis::Symbol=:both)::Quantity
# end

# function typefrequency(spectrum::Spectrum)::Symbol
#     dfrequency = dimension(spectrum.axes[_IFREQUENCY][1])
#     typefreq = begin
#         dfrequency == 𝐓^-1 ? :frequency :
#         dfrequency == 𝐀*𝐓^-1 ? :angular_frequency :
#         dfrequency == 𝐓 ? :period :
#         dfrequency == 𝐓*𝐀^-1 ? :angular_period :
#         dfrequency == 𝐋^-1 ? :wavenumber :
#         dfrequency == 𝐀*𝐋^-1 ? :angular_wavenumber :
#         dfrequency == 𝐋 ? :wavelength :
#         dfrequency == 𝐋*𝐀^-1 ? :angular_wavelength :
#         error("Something went seriously wrong...")
#     end
#     return typefreq
# end

# end
