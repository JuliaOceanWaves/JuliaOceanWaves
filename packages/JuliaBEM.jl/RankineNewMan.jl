
using LinearAlgebra, Statistics



function local_coordinate_system(panel_vertices)
    # Centroid of the panel
    centroid = [mean([v[1] for v in panel_vertices]),
                        mean([v[2] for v in panel_vertices]),
                        mean([v[3] for v in panel_vertices])]

     # Calculate the panel's normal direction
     edge1 = panel_vertices[2] - panel_vertices[1]
     edge2 = panel_vertices[4] - panel_vertices[1]
     normal_vector = cross(edge1, edge2)
     normal_vector /= norm(normal_vector)  # Normalize the normal vector
     
     # Define the 𝜁 axis as the panel's normal direction
     𝜁 = normal_vector
     
     # Calculate the 𝜉 axis as the vector from the first vertex to the centroid
     𝜉 = centroid - panel_vertices[1]
     𝜉 /= norm(𝜉)  # Normalize the 𝜉 axis
     
     # Calculate the 𝜂 axis as the cross product of 𝜁 and 𝜉
     𝜂 = cross(𝜁, 𝜉)
     
     return 𝜉, 𝜂, 𝜁
end
function QuadSingularIntegral(source,field) #computes

    P(x, 𝜉, y, 𝜂) = (x - 𝜉) * (y - 𝜂)
    Q(x, 𝜉, z) = sqrt((x - 𝜉)^2 + z^2)
    R(y,𝜂,Q) = sqrt((y-𝜂)^2 + Q^2)
    c(𝜂1,𝜂0,𝜉1,𝜉0) = (𝜂1-𝜂0)/(𝜉1-𝜉0) #1 is n+1..0 is n counter clockwise
    L(𝜂1,𝜂0,𝜉1,𝜉0) = sqrt((𝜉1-𝜉0)^2 + (𝜂1-𝜂0)^2)

    Nv = 4 #for a quad panel..3 for triangles
    NextNode = [2,3,4,1] #counter clockwise
    centroid = [] #field point
    x,y = 0,0 # take from centroid
    for n in Nv
        𝜉0,𝜂0 = source[n][1], source[n][2]
        𝜉1,𝜂1 = source[NextNode[n]][1], source[NextNode[n]][2]
        x,y = field[1],field[2]
        cres = c(𝜂1,𝜂0,𝜉1,𝜉0)
        Qres0 = Q(x, 𝜉0, z) 
        Pres0 =  P(x, 𝜉0, y, 𝜂0) = (x - 𝜉0) * (y - 𝜂0)
        Qres1 = Q(x, 𝜉1, z) 
        Pres1 =  P(x, 𝜉1, y, 𝜂1) = (x - 𝜉1) * (y - 𝜂1)
        Rres0 =  R(y,𝜂0,Q)
        Rres1 =  R(y,𝜂1,Q)
        res = atan((cres*Qres0 - Pres0)/(z*Rres0)) - atan((cres*Qres1 - Pres1)/(z*Rres1))
        # another Matrix
       end
return res
end 


# Define the vertices of the panel in counter-clockwise order..4 vertex with 3 points each
mesh = [[0.0, 1.0, 2.0], [1.0,4.0, 5.0], [2.0, 7.0, 8.0],[2.0,9.0,10.0],
[1.0, 1.0, 2.0], [2.0,4.0, 5.0], [3.0, 7.0, 8.0],[4.0,9.0,10.0]]

fields = [[0.2, 0.6, 0.3],[1, 1.0, 0.2]]

# change all of the panels in the mesh to local system..and compute centroids (fields)
mesh = local_coordinate_system(mesh) #apply to each

H = zeros(Complex{Float64}, size(panel_vertices), size(panel_vertices))
for source_panel in panel_vertices
    for field in fields
        H[i,j] = QuadSingularIntegral(source_panel,field)
    end
end 

print(H)