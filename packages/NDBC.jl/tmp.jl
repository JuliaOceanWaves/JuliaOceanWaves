
# parameter = "swden"

# S = NDBC.OmniSpec(S)


# select!(filter!(:b_file => b -> !b, r2), Not(:b_file))




# function plot_omni_spectrum(sw)
#     # TODO: better way of plotting? Meesed up units?
#     # Create a type for wave spectra? dispatch plot with this type?
#     # Strings with mixed text & math
#     # Colors: Tab10
#     time = sw.axes[1].val
#     frequency = sw.axes[2].val
#     den = sw[time[1], :, :den].data

#     f = Float64.(ustrip(frequency))
#     S = Float64.(ustrip(Float64.(den)))  # obviously I fucked up somewhere

#     color = "#56B4E9"
#     fig = Figure(resolution=(600, 400), font="CMU Serif")
#     ax = CairoMakie.Axis(fig[1, 1], xlabel="frequency [Hz]", ylabel="variance spectrum [m²/Hz]")#,
#     # xlabelsize=22, ylabelsize=22)
#     xlims!(0, nothing)
#     lines!(f, S; color=color)
#     band!(f, fill(0, length(S)), S; color=(color, 0.1))
#     fig
# end





# @recipe function plot_omni_spectrum(sw)
#     time = sw.axes[1].val
#     frequency = sw.axes[2].val
#     den = sw[time[1], :, :den].data

#     f = Float64.(ustrip(frequency))
#     S = Float64.(ustrip(Float64.(den)))  # obviously I fucked up somewhere

#     return f, S
# end
