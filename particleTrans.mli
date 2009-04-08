type transformation = Idle | Project of float * float * float | Random
val idle : 'a -> 'a
val project :
  transformation ->
  VertexType.depth_vertex list -> VertexType.depth_vertex list
val random : VertexType.depth_vertex list -> VertexType.depth_vertex list
val get_trans :
  transformation ->
  VertexType.depth_vertex list -> VertexType.depth_vertex list
