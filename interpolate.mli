type coordinates = Cartesian | Spherical | Cylindrical
val normalize : VertexType.depth_vertex -> VertexType.depth_vertex
val cartesian_float : float -> float -> float -> float
val cartesian :
  VertexType.depth_vertex ->
  VertexType.depth_vertex -> float -> VertexType.depth_vertex
