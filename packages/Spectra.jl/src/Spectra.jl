module Spectra

using Unitful: Quantity, Units, dimension, uconvert, ustrip, unit, 𝐓, 𝐋, Hz, m, s
using DimensionfulAngles: radᵃ as rad, °ᵃ as °, 𝐀
using UnitfulEquivalences: Equivalence
using AxisArrays: AxisArray, Axis, AbstractInterval, axisnames, axisvalues, (..)
using NumericalIntegration: integrate, Trapezoidal

import Base  # size, getindex, setindex!, copy, show
import Unitful: unit
import AxisArrays: axisnames

export Spectrum, OmniSpectrum

include("core.jl")
include("show.jl")
include("functions.jl")

end
