class Cell{
  private String type; // types: in, out, frontier
  private HashMap<String, Integer> walls;
  private ArrayList<Coor> coorNeighbors;
  private Coor coor;
  
  public Cell(int row, int col){
    type = "out";
    this.walls = walls;
    coor = new Coor(row, col);
    
    walls = new HashMap();
    walls.put("top", 1);
    walls.put("right", 1);
    walls.put("bottom", 1);
    walls.put("left", 1);
  }
  
  public String getType(){
    return type;
  }
  public HashMap<String, Integer> getWalls(){
    return walls;
  }

  public ArrayList<Coor> getCoorNeighbors(){
    return coorNeighbors;
  }
  public Coor getCoor(){
    return coor;
  }
  
  public void setWalss(HashMap<String, Integer> walls){
    this.walls = walls;
  }
 
  public void setType(String type){
    this.type = type;
  }
  public void setCoorNeighbors(ArrayList<Coor> coorNeighbors){
    this.coorNeighbors = coorNeighbors;
  }
  public void setCoor(Coor coor){
    this.coor = coor;
  }
  
  
}
