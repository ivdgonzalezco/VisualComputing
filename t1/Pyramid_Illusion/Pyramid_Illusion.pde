//39 clicks para ver el efecto deseado

int squares = 2;
int x;
int b = 255;
int r = 0;
int g = 0;

void setup() {
  size(600, 600);
  noStroke();
  rectMode(CENTER);
}

void draw(){
    
    for (int i=squares; i>0; i--){
      fill(r+i*1.5,g+i*1.5,0);
      x=width/squares;
      rect(width/2,height/2,i*x, i*x);
    }
}

void mouseClicked() {
  squares += 3;
}
