class Face{
  
  Vertex a;
  Vertex b;
  Vertex c;
  
  Face(Vertex v1, Vertex v2, Vertex v3){
    a = v1;
    b = v2;
    c = v3;
  }
  
  public Vertex getVertex1(){
    return a;
  }
  
  public Vertex getVertex2(){
    return b;
  }
  
  public Vertex getVertex3(){
    return c;
  }
  
}
