float x1;
float angle1, angle2;
float scalar = 100;
float scalar1 = 100;
int step;
int exp = 0;
int alter = -1;
int change = 10;
int control = 0;

void setup() {
  size(600, 600);
  noLoop();
}

void draw() {
  background(255);
  
  step = width/16;
  
  for (int i = 0; i < width; i = i + step) {
      if (control%2==0){
        for (int j = 0; j < height; j = j + step) {
          if ((i + j + 1) % 2 == 0) {
            fill(255, 255, 255);
          } else {
            fill(0, 0, 0);
          }
          rect(j, i, step, step);
        }
      }else{
        for (int j = 0; j < height; j = j + step) {
          if ((i + j + 1) % 2 == 0) {
            fill(255, 255, 255);
          } else {
            fill(0, 0, 0);
          }
          rect(j  + change * alter^exp, i, step, step);
        }
        exp++;
      }
      control++;
      exp = 0;
    }
}
