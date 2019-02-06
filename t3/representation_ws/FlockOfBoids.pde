/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 *
 * This example displays the famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 [1] and then adapted to Processing by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * The Boid under the mouse will be colored blue. If you click on a boid it will
 * be selected as the scene avatar for the eye to follow it.
 *
 * 1. Reynolds, C. W. Flocks, Herds and Schools: A Distributed Behavioral Model. 87.
 * http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
 * 2. Check also this nice presentation about the paper:
 * https://pdfs.semanticscholar.org/73b1/5c60672971c44ef6304a39af19dc963cd0af.pdf
 * 3. Google for more...
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the boid visual mode.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fit(1).
 */

import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Scene scene;
//flock bounding box
int flockWidth = 1280;
int flockHeight = 720;
int flockDepth = 600;
boolean avoidWalls = true;

int initBoidNum = 10; // amount of boids to start the program with
ArrayList<Boid> flock;
Frame avatar;
boolean animate = true;

Interpolator interpolator;

ArrayList<Vector> points;

int curveMode = 2;

void setup() {
  size(1000, 800, P3D);
  scene = new Scene(this);
  scene.setFrustum(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.fit();
  // create and fill the list of boids
  flock = new ArrayList();
  for (int i = 0; i < initBoidNum; i++)
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2)));
    
  interpolator = new Interpolator(scene, new Frame());
  
  for (int i = 0; i < initBoidNum; i++) {
    Frame ctrlPoint = new Frame(scene);
    ctrlPoint.setPosition(flock.get(i).position);
    interpolator.addKeyFrame(ctrlPoint);
  }
  
}

void draw() {
  background(10, 50, 25);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  scene.traverse();
  // uncomment to asynchronously update boid avatar. See mouseClicked()
  // updateAvatar(scene.trackedFrame("mouseClicked"));
 
   points = new ArrayList<Vector>();
  
  for(Frame frame : interpolator.keyFrames()){
    points.add(frame.position());
  }
 
  setPoints(points);
 
  hermite();
  //bezier();
}

void walls() {
  pushStyle();
  noFill();
  stroke(255, 255, 0);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void updateAvatar(Frame frame) {
  if (frame != avatar) {
    avatar = frame;
    if (avatar != null)
      thirdPerson();
    else if (scene.eye().reference() != null)
      resetEye();
  }
}

// Sets current avatar as the eye reference and interpolate the eye to it
void thirdPerson() {
  scene.eye().setReference(avatar);
  scene.fit(avatar, 1);
}

// Resets the eye
void resetEye() {
  // same as: scene.eye().setReference(null);
  scene.eye().resetReference();
  scene.lookAt(scene.center());
  scene.fit(1);
}

// picks up a boid avatar, may be null
void mouseClicked() {
  // two options to update the boid avatar:
  // 1. Synchronously
  updateAvatar(scene.track("mouseClicked", mouseX, mouseY));
  // which is the same as these two lines:
  // scene.track("mouseClicked", mouseX, mouseY);
  // updateAvatar(scene.trackedFrame("mouseClicked"));
  // 2. Asynchronously
  // which requires updateAvatar(scene.trackedFrame("mouseClicked")) to be called within draw()
  // scene.cast("mouseClicked", mouseX, mouseY);
}

// 'first-person' interaction
void mouseDragged() {
  if (scene.eye().reference() == null)
    if (mouseButton == LEFT)
      // same as: scene.spin(scene.eye());
      scene.spin();
    else if (mouseButton == RIGHT)
      // same as: scene.translate(scene.eye());
      scene.translate();
    else
      scene.moveForward(mouseX - pmouseX);
}

// highlighting and 'third-person' interaction
void mouseMoved(MouseEvent event) {
  // 1. highlighting
  scene.cast("mouseMoved", mouseX, mouseY);
  // 2. third-person interaction
  if (scene.eye().reference() != null)
    // press shift to move the mouse without looking around
    if (!event.isShiftDown())
      scene.lookAround();
}

void mouseWheel(MouseEvent event) {
  // same as: scene.scale(event.getCount() * 20, scene.eye());
  scene.scale(event.getCount() * 20);
}

void keyPressed() {
  switch (key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fit(1);
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  case ' ':
    if (scene.eye().reference() != null)
      resetEye();
    else if (avatar != null)
      thirdPerson();
    break;
   case '1':
    curveMode = 1;
    break;
   case '2':
     curveMode = 0;
  }
  
 
}
  
  public void setPoints(ArrayList<Vector> points){
    stroke(213,11,11);
    this.points = points;
  }
  
  public int factorial(int n){
    int factorial = 1;
    while ( n!=0) {
      factorial=factorial*n;
      n--;
    }
    return factorial;
  }
  
  public float combinatorial(int n,int i){
    return factorial(n)/(factorial(i) * factorial(n-i));
  }
  
  public float bernstein(float t, int n, int i){
    return combinatorial(n,i)*pow(t,i)*pow(1-t,n-i);
  }
  
  public void bezier(){
    int n = points.size();
    Vector aux = null;
    Vector current_point = points.get(0);
    
    for(float t=0; t<=1; t+=0.01){
      aux = new Vector(0, 0, 0);
      for (int i=0; i<n; i++){
        aux.add(Vector.multiply(points.get(i),  bernstein(t,n,i)));
      }
      line(current_point.x(),current_point.y(),current_point.z(),aux.x(),aux.y(),aux.z());
      current_point = aux;
    }
  }
  
  private Vector tangent_point(int i) {
    return Vector.multiply( Vector.subtract( points.get(i+1), points.get(i-1) ), 0.5 );
  }
  
  public void hermite(){
  int n = points.size();
  Vector aux = null;
  Vector punto_actual = points.get(0);
  for (int i=1; i<n-2;i++){
    Vector P0 = points.get(i);
    Vector P1 = points.get(i+1);

    punto_actual = P0;
    Vector m0= tangent_point(i);
    Vector m1= tangent_point(i+1); 

    for(float t=0; t<=1; t+=0.01){  
      
      float h00 = 2*pow(t,3)-3*pow(t,2)+1;
      float h10 = pow(t,3)-2*pow(t,2)+t;
      float h01 = -2*pow(t,3)+3*pow(t,2);
      float h11 = pow(t,3)-pow(t,2);

      Vector aux1 = Vector.add(Vector.multiply(P0, h00),Vector.multiply(m0, h10));
      Vector aux2 = Vector.add(Vector.multiply(P1, h01),Vector.multiply(m1, h11));
      aux = Vector.add(aux1, aux2);
      
      line(punto_actual.x(),punto_actual.y(),punto_actual.z(),aux.x(),aux.y(),aux.z());
      punto_actual = aux;
      }  
        
      line(punto_actual.x(),punto_actual.y(),punto_actual.z(),P1.x(),P1.y(),P1.z());
    }
}
