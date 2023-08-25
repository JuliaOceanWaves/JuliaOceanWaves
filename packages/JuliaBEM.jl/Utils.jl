function process_file(filename::String)::Vector{<:AbstractVector{Float64}}
    data = Vector{Vector{Float64}}()
    
    open(filename) do file
        for line in eachline(file)
            values = split(line)
            if length(values) == 1
                value = parse(Float64, values[1])
                push!(data, [value])
            elseif length(values) >1
                vector_values = [parse(Float64, v) for v in values]
                push!(data, vector_values)
            end
        end
    end
    
    return data
end


