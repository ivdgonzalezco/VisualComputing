import frames.timing.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

ArrayList<Point> dots = new ArrayList<Point>();
ArrayList<Float> red = new ArrayList<Float>(); 
ArrayList<Float> green = new ArrayList<Float>();
ArrayList<Float> blue = new ArrayList<Float>();

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

void setup() {
  rectMode(CORNER);
  //use 2^n to change the dimensions
  size(700, 700, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

float edgeFun(Vector a, Vector b, Vector c){
  return (c.x() - a.x()) * (b.y() - a.y()) - (c.y() - a.y()) * (b.x() - a.x()); 
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.location converts points from world to frame
  // here we convert v1 to illustrate the idea
  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(frame.location(v1).x()), round(frame.location(v1).y()));
    point(round(frame.location(v2).x()), round(frame.location(v2).y()));
    point(round(frame.location(v3).x()), round(frame.location(v3).y()));
    
    point(v1.x(), v1.y());
    point(v2.x(), v2.y());
    point(v3.x(), v3.y());

    for(int k = (int) -pow(2,n-1); k < pow(2,n-1); k++){
      for(int l = (int) -pow(2,n)/2; l < pow(2,n)/2; l++){
        float xValue =  width/pow(2,n)*k;
        float yValue =  width/pow(2,n)*l;
        
        Vector point = new Vector(width/pow(2,n)*k, width/pow(2,n)*l);
      
        float v1v2 = edgeFun(v1,v2,point);
        float v2v3 = edgeFun(v2,v3,point);
        float v3v1 = edgeFun(v3,v1,point);

        float triangleArea = v1v2 + v2v3 + v3v1;
        
        float baricentric1 = v2v3/triangleArea;
        float baricentric2 = v3v1/triangleArea;
        float baricentric3 = v1v2/triangleArea;

        if( baricentric1 > 0 && baricentric2 > 0 && baricentric3 > 0 ){
          red.add(new Float(baricentric1*255));
          green.add(new Float(baricentric2*255));
          blue.add(new Float(baricentric3*255));
          dots.add(new Point(xValue,yValue));
        }
      }
    }

    popStyle();
  }
}

void randomizeTriangle() {
  dots = new ArrayList<Point>();
  red = new ArrayList<Float>(); 
  green = new ArrayList<Float>();
  blue = new ArrayList<Float>();
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  
  int size = 0;
  
  if(n == 2){
    size = 175;
  }else if(n == 3){
    size = 88;
  }else if(n == 4){
    size = 44;
  }else if(n == 5){
    size = 22;
  }else if(n == 6){
    size = 11;
  }else {
    size = 6;
  }
  

  int counter = 0;

  for(Point p: dots){
    noStroke();
    fill(red.get(counter), green.get(counter), blue.get(counter));
    rect(p.x(), p.y(), size, size);
    //point(p.x(),p.y());
    counter++;
  }

  pushStyle();
  stroke( 255, 0, 0 );
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
  popStyle();
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    dots = new ArrayList<Point>();
    red = new ArrayList<Float>(); 
    green = new ArrayList<Float>();
    blue = new ArrayList<Float>();
    n = n < 7 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    dots = new ArrayList<Point>();
    red = new ArrayList<Float>(); 
    green = new ArrayList<Float>();
    blue = new ArrayList<Float>();
    n = n >2 ? n-1 : 7;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
      randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
