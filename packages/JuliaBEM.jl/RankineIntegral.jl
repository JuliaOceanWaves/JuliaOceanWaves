function COMPUTE_INTEGRAL_OF_RANKINE_SOURCE!(
    M::Vector{Float64},
    Face_nodes::Vector{Float64},
    Face_center::Vector{Float64},
    Face_normal::Vector{Float64},
    Face_area::Float64,
    Face_radius::Vector{Float64},
    S0::Vector{Complex{Float64}},
    VS0::Vector{Complex{Float64}}
)
   
    NEXT_NODE = [2, 3, 4, 1]
    print(M)
    RO = norm(M .- Face_center) # Distance from center of mass of the face to M.

    print(RO)
    #special casting to match with the indexing below.
    
   
    if RO > 7 * Face_radius[1]
        
        # Asymptotic value if face far away from M
        S0 = Face_area / RO
        VS0 .= (Face_center[1:3] .- M) .* S0 / RO^2
       
    else
       
        GZ = dot(M .- Face_center, Face_normal) 
      
        RR = [norm(M .- Face_nodes[L]) for L in 1:4] # Distance from vertices of Face to M.
       
        DRX = [(M .- Face_nodes[L]) ./ RR[L] for L in 1:4] # Normed vector from vertices of Face to M.
       
        S0 .= 0.0
        VS0 .= 0.0

        for L in 1:4
            DK = norm(Face_nodes[NEXT_NODE[L]] .- Face_nodes[L]) # Distance between two consecutive points, called d_k in [Del]
           
            if DK >= 1e-3 * Face_radius[1]
               
              
                PJ = (Face_nodes[NEXT_NODE[L]] .- Face_nodes[L]) / DK # Normed vector from one corner to the next
              
                GYX = [Face_normal[2] * PJ[3] - Face_normal[3] * PJ[2],
                       Face_normal[3] * PJ[1] - Face_normal[1] * PJ[3],
                       Face_normal[1] * PJ[2] - Face_normal[2] * PJ[1]] # The following GYX(1:3) are called (a,b,c) in [Del]
                print("GYX")
                print(GYX)
                GY = dot(M .- Face_nodes[L], GYX) # Called Y_k in [Del]
                ANT = 2 * GY * DK # Called N^t_k in [Del]
                DNT = (RR[NEXT_NODE[L]] + RR[L])^2 - DK^2 + 2 * abs(GZ) * (RR[NEXT_NODE[L]] + RR[L]) # Called D^t_k in [Del]
                ANL = RR[NEXT_NODE[L]] + RR[L] + DK # Called N^l_k in [Del]
                DNL = RR[NEXT_NODE[L]] + RR[L] - DK # Called D^l_k in [Del]
                ALDEN = log(ANL / DNL)

                if abs(GZ) >= 1e-4 * Face_radius[1]
                    AT = atan(ANT / DNT)
                else
                    AT = 0.0
                end

                ANLX = DRX[NEXT_NODE[L]] + DRX[L] # Called N^l_k_{x,y,z} in [Del]
                ANTX = 2 * DK * GYX # Called N^t_k_{x,y,z} in [Del]
                DNTX = 2 * (RR[NEXT_NODE[L]] + RR[L] + abs(GZ)) .* ANLX + 2 * sign(1, GZ) * (RR[NEXT_NODE[L]] + RR[L]) .* Face_normal[:] # Called D^t_k_{x,y,z} in [Del]

                if abs(GY) < 1e-5
                    # Edge case where the singularity is on the boundary of the face (GY = 0, ALDEN = inf).
                    # This case seems to only occur when computing the free surface elevation,
                    # so no fix has been implemented for VS0, which is not needed then.
                    S0 = S0 - 2 * AT * abs(GZ)
                else
                    # General case
                    S0 = S0 + GY * ALDEN - 2 * AT * abs(GZ)
                end

                VS0[:] = VS0[:] + ALDEN * GYX[:] -
                    2 * sign(1, GZ) * AT * Face_normal[:] +
                    GY * (DNL - ANL) / (ANL * DNL) * ANLX[:] -
                    2 * abs(GZ) * (ANTX[:] .* DNT - DNTX[:] .* ANT) / (ANT^2 + DNT^2)
            end
        end
    end
end
