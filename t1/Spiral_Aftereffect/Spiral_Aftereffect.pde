final int NUM_LINES = 300;
final int NUM_LINES1 = 200; 
final int NUM_LINES2 = 100; 
float maxRadius = 400;            
final int NUM_TURNS = 15;  
float startAngle = 0;
float startAngle1 = 0;
float startAngle2 = 0;
final float START_ANGLE_CHANGE = 0.4; 
float x;
float y;
float x1;
float y1;
float x2;
float y2; 
 
void setup() {
  size(600, 600); 
}
 
void draw() {
  background(255);

  float xp=width/2;
  float yp=height/2;
  for(int i = 0; i<NUM_LINES;i++){    
    x = width/2+i*cos((i+startAngle)*NUM_TURNS*TWO_PI/maxRadius);
    y = height/2+i*sin((i+startAngle)*NUM_TURNS*TWO_PI/maxRadius);
    strokeWeight(10);
    line(x,y,xp,yp);
    xp=x;
    yp=y;
  }
  startAngle-=START_ANGLE_CHANGE;
  
  
  fill(255);
  strokeWeight(0);
  ellipse(300,300,400,400);
  
  float xp1=width/2;
  float yp1=height/2;
  for(int i = 0; i<NUM_LINES1;i++){    
    x1 = width/2+i*cos((i+startAngle1)*NUM_TURNS*TWO_PI/maxRadius);
    y1 = height/2+i*sin((i+startAngle1)*NUM_TURNS*TWO_PI/maxRadius);
    strokeWeight(10);
    line(x1,y1,xp1,yp1);
    xp1=x1;
    yp1=y1;
  }
  startAngle1+=START_ANGLE_CHANGE;
  
  fill(255);
  strokeWeight(0);
  ellipse(300,300,200,200);
  
  float xp2=width/2;
  float yp2=height/2;
  for(int i = 0; i<NUM_LINES2;i++){    
    x2 = width/2+i*cos((i+startAngle2)*NUM_TURNS*TWO_PI/maxRadius);
    y2 = height/2+i*sin((i+startAngle2)*NUM_TURNS*TWO_PI/maxRadius);
    strokeWeight(10);
    line(x2,y2,xp2,yp2);
    xp2=x2;
    yp2=y2;
  }
  startAngle2-=START_ANGLE_CHANGE;
  
}
