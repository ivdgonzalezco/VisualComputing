int counter = 1;

void setup() {
  size(900, 600);          
  strokeWeight(9);         
  smooth();               
  stroke(100, 100, 100);  
  noLoop();
  ellipseMode(CENTER);
}

void draw() {
  int step = width/16;
  
  fill(0,0,0);
  rect(0,0,300,600);
  
  fill(0,0,0);
  rect(600,0,300,600);
  
  for (int x = step; x < 600; x = x + step){
    stroke(100, 100, 100); 
    line(x, 0, x, height);
    counter++;
  }
  
  for (int x = step*counter; x < width; x = x + step){
    stroke(255,0,0);
    line(x, 0, x, height);
  }
  
  for (int y = step; y < height; y = y + step){
    stroke(100, 100, 100); 
    line(0, y, 600, y);
    stroke(255,0,0);
    line(600, y, width, y);
  }
  
  smooth();
  
  stroke(256, 256, 256); 
  for (int i = 0; i < width; i = i + step) {
    for (int j = 0; j < height -15; j = j + step) {
      strokeWeight(15); 
      point(i, j); 
    }
  }
}
