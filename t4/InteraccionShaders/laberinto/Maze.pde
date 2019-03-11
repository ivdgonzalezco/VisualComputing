class Maze{
  private int rows;
  private int cols;
  private Cell[][] maze;
  
  public Maze(int rows, int cols){
    this.rows = rows;
    this.cols = cols;
  }
  
  //functions
  
  public void drawMaze(){
    int x = 0;
    int y = 0;
    for (int i = 0; i < cols; i++){
      for (int j = 0; j < rows; j++){
        Cell cell = maze[i][j];
        
        //top
        if( cell.getWalls().get("top") == 1 ){
            strokeWeight(5);
            line(x,y,x + 40, y);
        }
        //right
        if( cell.getWalls().get("right") == 1 ){
            strokeWeight(5);
            line(x + 40,y,x + 40, y + 40);
        }
        //bottom
        if( cell.getWalls().get("bottom") == 1 ){
            strokeWeight(5);
            line(x,y + 40,x + 40, y + 40);
        }
        //left
        if( cell.getWalls().get("left") == 1 ){
            strokeWeight(5);
            line(x,y,x, y+40);
        }
        x = x + 40;
      }
      x = 0;
      y = y + 40;
    }
  }
  
  private void primsAlgorithm(){
    
    ArrayList<Cell> frontierCells = new ArrayList();
    
    //Paso 1:  Start by picking a cell, making it "in", and setting all its neighbors to "frontier".
    Cell startCell = maze[ 0 ][ randomNum(0,cols) ];
    startCell.setType("in");
    for(int i = 0; i < startCell.getCoorNeighbors().size(); i++){
      Coor coorNeighbor = startCell.getCoorNeighbors().get(i);
      Cell neighbor = maze[coorNeighbor.getRow()][coorNeighbor.getCol()];
      neighbor.setType("frontier");
      frontierCells.add(neighbor);
    }
    while(frontierCells.size() > 0){
      //Paso 2: Proceed by picking a "frontier" cell at random, and carving into it from one of its neighbor cells that are "in".
      int randomFrontierIndex = randomNum(0, frontierCells.size());
      Cell frontier = frontierCells.remove(randomFrontierIndex);
      ArrayList<Cell> neighborsIn = new ArrayList();
      for(int i = 0; i < frontier.getCoorNeighbors().size(); i++){
        Coor coor = frontier.getCoorNeighbors().get(i);
        Cell neighbor = maze[coor.getRow()][coor.getCol()];
        if( neighbor.getType().equals("in") ){
          neighborsIn.add(neighbor);
        }
      }
      int randomCellIn = randomNum(0,neighborsIn.size());
      Cell cellToCarving = neighborsIn.get(randomCellIn);
      removeWalls(cellToCarving, frontier);
      //Paso 3: Change that "frontier" cell to "in", and update any of its neighbors that are "out" to "frontier".
      frontier.setType("in");
      for(int i = 0; i < frontier.getCoorNeighbors().size(); i++){
        Coor coor = frontier.getCoorNeighbors().get(i);
        Cell neighbor = maze[coor.getRow()][coor.getCol()];
        if( neighbor.getType().equals("out")){
          neighbor.setType("frontier");
          frontierCells.add(neighbor);
        }
      }
    }
  }
  
  private void createMaze(){
    maze = new Cell[rows][cols];
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        Cell cell = new Cell(i,j);
        
        if( i == 0 ) cell.getWalls().put("top", -1);
        if( i == (rows - 1) ) cell.getWalls().put("right", -1);
        if( j == 0 ) cell.getWalls().put("bottom", -1);
        if( j == (cols - 1) ) cell.getWalls().put("left", -1);
        
        ArrayList<Coor> neighbors = new ArrayList();
        if( i - 1 >= 0) neighbors.add(new Coor(i - 1, j)); //top
        if( j + 1 < cols) neighbors.add(new Coor(i, j + 1)); //right
        if( i + 1 < rows) neighbors.add(new Coor(i + 1, j)); //bottom
        if( j - 1 >= 0) neighbors.add(new Coor(i, j - 1)); //left
        cell.setCoorNeighbors(neighbors);
        
        maze[i][j] = cell;
      }
    }    
  }
  
  private void removeWalls(Cell cellIn, Cell cellFrontier){
    Coor coorIn = cellIn.getCoor();
    Coor coorFron = cellFrontier.getCoor();
    if(coorIn.getRow() - 1 == coorFron.getRow() && coorIn.getCol() == coorFron.getCol()){
      cellIn.getWalls().put("top", 0);
      cellFrontier.getWalls().put("bottom", 0);
    }
    if(coorIn.getRow() == coorFron.getRow() && coorIn.getCol() + 1 == coorFron.getCol()){
      cellIn.getWalls().put("right", 0);
      cellFrontier.getWalls().put("left", 0);
    }
    if(coorIn.getRow() + 1 == coorFron.getRow() && coorIn.getCol() == coorFron.getCol()){
      cellIn.getWalls().put("bottom", 0);
      cellFrontier.getWalls().put("top", 0);
    }
    if(coorIn.getRow() == coorFron.getRow() && coorIn.getCol() - 1 == coorFron.getCol()){
      cellIn.getWalls().put("left", 0);
      cellFrontier.getWalls().put("right", 0);
    }
  }

  private int randomNum(int min, int max){
    return min + (int) ( Math.random() * ((max - min) ) ); 
  }
  
  //getters and setters
  
  public Cell[][] generate(){
    if(maze == null){
      createMaze();
      primsAlgorithm();
    }
    return maze;
  }
  
  public int getRows(){
    return this.rows;
  }
  
  public int getCols(){
    return this.cols;
  }
  
  public Cell[][] getMaze(){
    return this.maze;
  }
 
  public void setRows(int rows){
    this.rows = rows;
  }
  
  public void setcols(int cols){
    this.cols = cols;
  }
  
}
