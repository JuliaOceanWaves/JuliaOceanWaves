
using LinearAlgebra, Statistics



function local_coordinate_system(panel_vertices)
    # Centroid of the panel
    field_point = [mean([v[1] for v in panel_vertices]),
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
     𝜉 = field_point - panel_vertices[1]
     𝜉 /= norm(𝜉)  # Normalize the 𝜉 axis
     
     # Calculate the 𝜂 axis as the cross product of 𝜁 and 𝜉
     𝜂 = cross(𝜁, 𝜉)
     
     return 𝜉, 𝜂, 𝜁
end


# Define the vertices of the panel in counter-clockwise order..4 vertex with 3 points each
panel_vertices = [[0.0, 1.0, 2.0], [1.0,4.0, 5.0], [2.0, 7.0, 8.0],[2.0,9.0,10.0]]



# Calculate the local coordinate system for the panel
𝜉_local, 𝜂_local, 𝜁_local = local_coordinate_system(panel_vertices)

# # The 𝜉_local, 𝜂_local, and 𝜁_local vectors represent the local coordinate system
# # for the panel with respect to the field point.
# println(local_coordinate_system(panel_vertices))