


# # abstract type Spectrum2D{T} <: AbstractMatrix{T}

# struct Spectrum{T, USPECTRUM} <: AbstractMatrix{T}
#     spectrum :: Matrix(Quantity{T, dimension(USPECTRUM), typeof(USPECTRUM)})
#     angularfrequency :: Vector{Quantity{T, dimension(rad/s), typeof(rad/s)}}
#     direction :: Vector{Quantity{T, dimension(rad), typeof(rad)}}
#     dispersion :: Union{Equivalence, Nothing}

#     function Spectrum(spectrum::Matrix{Quantity},
#                       frequency::Vector{Quantity},
#                       direction::Vector{Quantity},
#                       dispersion :: Union{Equivalence, Nothing})

#         # spectrum checks
#         size(spectrum) == (length(frequency), length(direction))
#         _check_typeconsistency(spectrum)

#         # promotion element type
#         Ts = eltype(spectrum).parameters[1]
#         Tf = eltype(frequency).parameters[1]
#         Td = eltype(direction).parameters[1]
#         T = promote_type(Ts, Tf, Td)

#         # convert units: direction
#         _check_typeconsistency(direction)
#         dimension(direction[1]) == 𝐀 || error("`direction` must have dimensions of angles.")
#         direction_factor = (1*unit(direction[1])) / (1*unit(direction[1]) |> rad)
#         spectrum = spectrum * direction_factor
#         direction = direction .|> rad

#         # change variables and/or units: frequency
#         _check_typeconsistency(frequency)
#         typefrequency = _typefrequency(frequency)
#         angularfrequency = uconvert(rad/s, frequency, Periodic())
#         if typefrequency ∈ [:frequency, :angular_frequency]
#             frequency_factor = (1*unit(frequency[1])) / (
#                                 uconvert.(rad/s, (1*unit(frequency[1])), Periodic()))
#             spectrum = spectrum * frequency_factor
#         elseif typefrequency ∈ [:period, :angular_period]
#             frequency_factor = (1*unit(frequency[1])) / (
#                                 uconvert.(s/rad, (1*unit(frequency[1])), Periodic()))
#             spectrum = reverse(spectrum * frequency_factor ./ (angularfrequency.^2))
#             angularfrequency = reverse(angularfrequency)
#         elseif typefrequency ∈ [:wavenumber, :angular_wavenumber]
#             error("Not implemented")
#         elseif typefrequency ∈ [:wavelength, :angular_wavelength]
#             error("Not implemented")
#         else
#             error("Something went seriously wrong. '_typefrequency' should've caught this.")
#         end


#         # convert eltype & array type
#         spectrum = Matrix(spectrum .|> T)
#         angularfrequency = Vector(angularfrequency .|> T)
#         direction = Vector(direction .|> T)
#         # integral quantity Units
#         UQUANTITY = unit(spectrum[1,1] * frequency[1] * direction[1])

#         return new{T, UQUANTITY}(spectrum, angularfrequency, direction, dispersion)
#     end

# end
