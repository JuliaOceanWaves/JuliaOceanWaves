
# axisnames
axisnames(S::Spectrum) = (_typeaxis(S.axis1)[1], _typeaxis(S.axis2)[1])
axisnames(S::OmniSpectrum) = (_typeaxis(S.axis)[1],)
axesname(S::OmniSpectrum) = axisnames(S)[1]

# units
function unit(s::Spectrum, quantity::Symbol) :: Units
    return (
        quantity==:axis1 ? unit(eltype(s.axis1)) :
        quantity==:axis2 ? unit(eltype(s.axis2)) :
        quantity==_typeaxis(s.axis1)[1] ? unit(eltype(s.axis1)) :
        quantity==_typeaxis(s.axis2)[1] ? unit(eltype(s.axis2)) :
        quantity==:integral ? unit(eltype(s))*unit(eltype(s.axis1))*unit(eltype(s.axis2)) :
        quantity==:spectrum ? unit(eltype(s)) :
        error("Unknown `quantity`."))
end

unit(s::Spectrum) = unit(s, :spectrum)

function unit(s::OmniSpectrum, quantity::Symbol) :: Units
    return (
        quantity==:axis ? unit(eltype(s.axis)) :
        quantity==_typeaxis(s.axis)[1] ? unit(eltype(s.axis)) :
        quantity==:integral ? unit(eltype(s))*unit(eltype(s.axis)) :
        quantity==:spectrum ? unit(eltype(s)) :
        error("Unknown `quantity`."))
end

unit(s::OmniSpectrum) = unit(s, :spectrum)

# integrals


# change of variable and or units


# S(ω, θ) <=> S(ω), D(ω, θ) # ω, f, T, k, λ, ...


# Quality check: integral D(ω, θ) ≈ 1, θ∈[0°, ..., 360°)


# functions omnispectra: moments, Hs, Tp, etc etc from MHKiT


# time-series <=> Spectrum
