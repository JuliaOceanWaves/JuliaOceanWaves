
"""
https://github.com/PainterQubits/Unitful.jl/issues/443

With the various revised unit conversion factors that NIST is adopting in 2022 (as they're
retiring the survey foot starting 2023), many of these less-commonly seen units will be a
bit more standardized (in this case, especially fathoms and leagues, as they'll be based off
of the (non-survey) foot). Unitful currently doesn't include most of these (when was the
last time you tried to use furlongs, after all?), but I could see either including these
in Unitful or making some sort of "UnitfulMisc.jl" or "UnitfulExtras.jl" package for all of
the less-commonly-seen but still fairly standardized units.

https://en.wikipedia.org/wiki/List_of_nautical_units_of_measurement

others gross tonnage (volume)
all the different tonnes ...

many already in unitfulUS.

https://www.nist.gov/pml/us-surveyfoot/revised-unit-conversion-factors

"""

