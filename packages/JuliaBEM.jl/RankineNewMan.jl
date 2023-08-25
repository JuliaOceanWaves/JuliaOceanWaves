function QuadSingularIntegral(panel_vertices) #takes in singular integral

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
        𝜉0,𝜂0 = panel_vertices[n][1], panel_vertices[n][2]
        𝜉1,𝜂1 = panel_vertices[NextNode[n]][1], panel_vertices[NextNode[n]][2]
        cres = c(𝜂1,𝜂0,𝜉1,𝜉0)
        Qres0 = Q(x, 𝜉0, z) 
        Pres0 =  P(x, 𝜉0, y, 𝜂0) = (x - 𝜉0) * (y - 𝜂0)
        Qres1 = Q(x, 𝜉1, z) 
        Pres1 =  P(x, 𝜉1, y, 𝜂1) = (x - 𝜉1) * (y - 𝜂1)
        Rres0 =  R(y,𝜂0,Q)
        Rres1 =  R(y,𝜂1,Q)
        H[i,j] = atan((cres*Qres0 - Pres0)/(z*Rres)) - atan((cres*Qres1 - Pres1)/(z*Rres1))





end
