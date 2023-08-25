

function build_matrices_RANKINE( centers_1::Vector{Vector{Float64}},
    normals_1::Vector{Vector{Float64}},
    vertices_2::Vector{Vector{Float64}},
    faces_2::Vector{Vector{Int64}},
    centers_2::Vector{Vector{Float64}},
    normals_2::Vector{Vector{Float64}},
    areas_2::Vector{Float64},
    radiuses_2::Vector{Vector{Float64}},
    coeffs::Vector{Float64},
    same_body::Bool)

    vertices_2 = hcat(vertices_2...)

    nb_faces_1 = size(centers_1, 1)
    nb_faces_2 = size(centers_2, 1)
    
    
    S = zeros(Complex{Float64}, nb_faces_1, nb_faces_2)
    K = zeros(Complex{Float64}, nb_faces_1, nb_faces_2)
 
    #print(faces_2)
    coeffs[2] -= 2 * coeffs[3]
    coeffs ./= 4π

    for J in 1:nb_faces_2
        SP1 = VSP1 = zeros(Complex{Float64}, 3)
        if coeffs[1] != 0
            for I in 1:nb_faces_1
              
                SP1, VSP1 = COMPUTE_INTEGRAL_OF_RANKINE_SOURCE!(centers_1[I], vertices_2[faces_2[J]], centers_2[J], normals_2[J], areas_2[J], radiuses_2[J], SP1, VSP1)
                S[I, J] -= coeffs[1] * SP1
                K[I, J] -= coeffs[1] * dot(normals_1[I, :], VSP1)
            end
        end
        
        # Reflected Rankine part and Wave Part are not implemented
        
        if same_body
            K[J, J] .+= 0.5
        end
    end

    return S, K
end


function build_matrices_WAVE(centers_1::Vector{Vector{Float64}},
    normals_1::Vector{Vector{Float64}},
    vertices_2::Vector{Vector{Float64}},
    faces_2::Vector{Vector{Int64}},
    centers_2::Vector{Vector{Float64}},
    normals_2::Vector{Vector{Float64}},
    areas_2::Vector{Float64},
    radiuses_2::Vector{Vector{Float64}})

    nb_faces_1 = size(centers_1, 1) #this is number of elements in one body
    nb_faces_2 = size(centers_2, 1) #this is number of element in other body or same
    
    
    S = zeros(Complex{Float64}, nb_faces_1, nb_faces_2)
    K = zeros(Complex{Float64}, nb_faces_1, nb_faces_2)


    


end
