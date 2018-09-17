int ang = 1;
int ang2 = 1;
int ang3 = 1;

void setup(){
  size(600,600);
  ellipseMode(CENTER);
  loop();
}
 
void draw(){
  background(150);
  
  fill(0,255,0);
  noStroke();
  ellipse(width/2, height/2, 500, 500);
  
  fill(255,0,0);
  noStroke();
  ellipse(width/2, height/2, 100, 100);
  
  ang += 4;
  
  fill(255,0,0);
  noStroke();
  arc(width/2, height/2, 350, 350, radians(ang), radians(ang+60));
  
  fill(255,0,0);
  noStroke();
  arc(width/2, height/2, 350, 350, radians(ang+120), radians(ang+180));
  
  fill(255,0,0);
  noStroke();
  arc(width/2, height/2, 350, 350, radians(ang+240), radians(ang+300));
  
  fill(255,255,255);
  noStroke();
  ellipse(width/2, height/2, 10, 10);
  
  fill(0,0,0);
  noStroke();
  ellipse(width/2, height/2, 5, 5);
}
