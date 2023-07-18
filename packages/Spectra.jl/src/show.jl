
# 2D Spectrum
function Base.summary(io::IO, z::Spectrum)
    println(io, "Spectrum of quantity in [", unit(z, :integral), "] with axes:")
    println(io, "    ", String(_typeaxis(z.axis1)[1]), " [", unit(eltype(z.axis1)), "], ", ustrip.(z.axis1))
    println(io, "    ", String(_typeaxis(z.axis2)[1]),  " [", unit(eltype(z.axis2)), "], ", ustrip.(z.axis2))
    print(io, "And data, a ", join(string.(size(z)), "x"), " Matrix{Quantity{", eltype(z).parameters[1],"}}")
    return nothing
end

# arrays of 2D Spectra
function Base.summary(io::IO, z::Array{<:Spectrum})
    print(io, join(string.(size(z)),"x"), " Array{Spectrum, ", string(ndims(z)), "}")
end

function Base.summary(io::IO, z::Matrix{<:Spectrum})
    print(io, join(string.(size(z)),"x"), " Matrix{Spectrum}")
end

function Base.summary(io::IO, z::Vector{<:Spectrum})
    print(io, string.(length(z)), "-element Vector{Spectrum}")
end

# AxisArray: array of 2D Spectra
function Base.summary(io::IO, A::AxisArray{<:Spectrum,N}) where N
    println(io, "$N-dimensional AxisArray{Spectrum,$N,...} with axes:")
    for (name, val) in zip(axisnames(A), axisvalues(A))
        print(io, "    :$name, ")
        show(IOContext(io, :limit=>true), val)
        println(io)
    end
    print(io, "And data, a ", summary(A.data))
end

# AxisArray: 2D Spectrum
function Base.summary(io::IO, A::AxisArray{T, N, <:Spectrum}) where {T,N}
    println(io, "$N-dimensional AxisArray{Quantity{…}, $N, Spectrum{…}, …} with axes:")
    for (name, val) in zip(axisnames(A), axisvalues(A))
        println(io, "    :$(name)[$(unit(eltype(val)))],  $(ustrip.(val))")
    end
    print(io, "And data, a Spectrum")
end


# 1D
function Base.summary(io::IO, z::OmniSpectrum)
    _summary = """
        OmniSpectrum of quantity in [$(unit(z, :integral))] with axis:
            $(String(_typeaxis(z.axis)[1])) [$(unit(eltype(z.axis)))], $(ustrip.(z.axis))
        And data, a $(length(z.axis))-element Vector{Quantity{$(eltype(z).parameters[1])}}"""
    print(io, _summary)
end

# arrays of 1D spectra
function Base.summary(io::IO, z::Array{<:OmniSpectrum})
    print(io, join(string.(size(z)),"x"), " Array{OmniSpectrum, ", string(ndims(z)), "}")
end

function Base.summary(io::IO, z::Matrix{<:OmniSpectrum})
    print(io, join(string.(size(z)),"x"), " Matrix{OmniSpectrum}")
end

function Base.summary(io::IO, z::Vector{<:OmniSpectrum})
    print(io, string.(length(z)), "-element Vector{OmniSpectrum}")
end

# AxisArray: array of 1D Spectra
function Base.summary(io::IO, A::AxisArray{<:OmniSpectrum,N}) where N
    println(io, "$N-dimensional AxisArray{OmniSpectrum,$N,...} with axis:")
    name, val = axisnames(A)[1], axisvalues(A)[1]
    print(io, "    :$name, ")
    show(IOContext(io, :limit=>true), val)
    println(io)
    print(io, "And data, a ", summary(A.data))
end

# AxisArray: 1D Spectrum
function Base.summary(io::IO, A::AxisArray{T, N, <:OmniSpectrum}) where {T,N}
    println(io, "$N-dimensional AxisArray{Quantity{…}, $N, OmniSpectrum{…}, …} with axis:")
    name, val = axisnames(A)[1], axisvalues(A)[1]
    println(io, "    :$(name)[$(unit(eltype(val)))],  $(ustrip.(val))")
    print(io, "And data, an OmniSpectrum")
end
