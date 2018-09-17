PVector center;
float angle;
float radius;
float x;
float y;

void setup(){
  size(700,700);
  center = new PVector(width/2, height/2);

  PVector point = new PVector(350, 270);

  float deltaX = center.x - point.x;
  float deltaY = center.y - point.y;
  angle = atan2(deltaX, deltaY);

  radius = dist(center.x, center.y, point.x, point.y);

  ellipseMode(RADIUS);
}
 
void draw(){
  background(255);
  noFill();
  
  ellipse(center.x, center.y, 320, 320);

  x = center.x + cos(angle)*radius;
  y = center.y + sin(angle)*radius;

  ellipse(x, y, 20, 20);
  ellipse(x, y, 40, 40);
  ellipse(x, y, 60, 60);
  ellipse(x, y, 80, 80);
  ellipse(x, y, 100, 100);
  ellipse(x, y, 120, 120);
  ellipse(x, y, 140, 140);
  ellipse(x, y, 160, 160);
  ellipse(x, y, 180, 180);
  ellipse(x, y, 200, 200);

  if (keyPressed == true) {
    angle = 0;
  } else {
    angle += PI/55;
  }
  
}
