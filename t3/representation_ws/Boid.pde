class Boid {
  public Frame frame;
  // fields
  Vector position, velocity, acceleration, alignment, cohesion, separation; // position, velocity, and acceleration in
  // a vector datatype
  float neighborhoodRadius; // radius in which it looks for fellow boids
  float maxSpeed = 4; // maximum magnitude for the velocity vector
  float maxSteerForce = .1f; // maximum magnitude of the steering vector
  float sc = 3; // scale factor for the render of the boid
  float flap = 0;
  float t = 0;
  
  ArrayList<ArrayList<Vertex>> vertexVertexSet;
  ArrayList<ArrayList<Face>> faceVertexSet;
  
  Vertex v0 = new Vertex(0, 0, 0);
  Vertex v1 = new Vertex(5, 0, 5);
  Vertex v2 = new Vertex(5, 5, 0);
  Vertex v3 = new Vertex(5, 0, -5);
  Vertex v4 = new Vertex(5, -5, 0);
  Vertex v5 = new Vertex(10, 0, 0);
  
  PShape ramiel;
    

  Boid(Vector inPos) {
    position = new Vector();
    position.set(inPos);
    frame = new Frame(scene) {
      // Note that within visit() geometry is defined at the
      // frame local coordinate system.
      @Override
      public void visit() {
        if (animate)
          run(flock);
        render();
      }
    };
    frame.setPosition(new Vector(position.x(), position.y(), position.z()));
    velocity = new Vector(random(-1, 1), random(-1, 1), random(1, -1));
    acceleration = new Vector(0, 0, 0);
    neighborhoodRadius = 100;
  }

  public void run(ArrayList<Boid> bl) {
    t += .1;
    flap = 10 * sin(t);
    // acceleration.add(steer(new Vector(mouseX,mouseY,300),true));
    // acceleration.add(new Vector(0,.05,0));
    if (avoidWalls) {
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), flockHeight, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), 0, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(flockWidth, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(0, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), 0)), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), flockDepth)), 5));
    }
    flock(bl);
    move();
    checkBounds();
  }

  Vector avoid(Vector target) {
    Vector steer = new Vector(); // creates vector for steering
    steer.set(Vector.subtract(position, target)); // steering vector points away from
    steer.multiply(1 / sq(Vector.distance(position, target)));
    return steer;
  }

  //-----------behaviors---------------

  void flock(ArrayList<Boid> boids) {
    //alignment
    alignment = new Vector(0, 0, 0);
    int alignmentCount = 0;
    //cohesion
    Vector posSum = new Vector();
    int cohesionCount = 0;
    //separation
    separation = new Vector(0, 0, 0);
    Vector repulse;
    for (int i = 0; i < boids.size(); i++) {
      Boid boid = boids.get(i);
      //alignment
      float distance = Vector.distance(position, boid.position);
      if (distance > 0 && distance <= neighborhoodRadius) {
        alignment.add(boid.velocity);
        alignmentCount++;
      }
      //cohesion
      float dist = dist(position.x(), position.y(), boid.position.x(), boid.position.y());
      if (dist > 0 && dist <= neighborhoodRadius) {
        posSum.add(boid.position);
        cohesionCount++;
      }
      //separation
      if (distance > 0 && distance <= neighborhoodRadius) {
        repulse = Vector.subtract(position, boid.position);
        repulse.normalize();
        repulse.divide(distance);
        separation.add(repulse);
      }
    }
    //alignment
    if (alignmentCount > 0) {
      alignment.divide((float) alignmentCount);
      alignment.limit(maxSteerForce);
    }
    //cohesion
    if (cohesionCount > 0)
      posSum.divide((float) cohesionCount);
    cohesion = Vector.subtract(posSum, position);
    cohesion.limit(maxSteerForce);

    acceleration.add(Vector.multiply(alignment, 1));
    acceleration.add(Vector.multiply(cohesion, 3));
    acceleration.add(Vector.multiply(separation, 1));
  }

  void move() {
    velocity.add(acceleration); // add acceleration to velocity
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    position.add(velocity); // add velocity to position
    frame.setPosition(position);
    frame.setRotation(Quaternion.multiply(new Quaternion(new Vector(0, 1, 0), atan2(-velocity.z(), velocity.x())), 
      new Quaternion(new Vector(0, 0, 1), asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  void checkBounds() {
    if (position.x() > flockWidth)
      position.setX(0);
    if (position.x() < 0)
      position.setX(flockWidth);
    if (position.y() > flockHeight)
      position.setY(0);
    if (position.y() < 0)
      position.setY(flockHeight);
    if (position.z() > flockDepth)
      position.setZ(0);
    if (position.z() < 0)
      position.setZ(flockDepth);
  }

  void render() {
    
    representation();
    
    //render1();
    
    render2();
    
  }
  
  void render1(){

    // uncomment to draw boid axes
    //scene.drawAxes(20)
    
    pushStyle();
    
    strokeWeight(2);
    stroke(color(0, 0, 255));
    fill(color(0, 0, 255));

    // highlight boids under the mouse
    if (scene.trackedFrame("mouseMoved") == frame) {
      stroke(color(40, 255, 40));
      fill(color(0, 255, 0, 125));
    }

    // highlight avatar
    if (frame ==  avatar) {
      stroke(color(255, 0, 0));
      fill(color(255, 0, 0));
    }

    //draw boid
    beginShape(TRIANGLES);
    
    //1
    vertex(0, 0, 0);
    //2
    vertex(5, 0, 5);
    //3
    vertex(5, 5, 0);

    //1
    vertex(0, 0, 0);
    //2
    vertex(5, 0, -5);
    //3
    vertex(5, 5, 0);
  
    //1
    vertex(0, 0, 0);
    //2
    vertex(5, 0, -5);
    //3
    vertex(5, -5, 0);

    //1
    vertex(0, 0, 0);
    //2
    vertex(5, 0, 5);
    //3
    vertex(5, -5, 0);
    
    //1
    vertex(10, 0, 0);
    //2
    vertex(5, 0, 5);
    //3
    vertex(5, 5, 0);

    //1
    vertex(10, 0, 0);
    //2
    vertex(5, 0, -5);
    //3
    vertex(5, 5, 0);
  
    //1
    vertex(10, 0, 0);
    //2
    vertex(5, 0, -5);
    //3
    vertex(5, -5, 0);

    //1
    vertex(10, 0, 0);
    //2
    vertex(5, 0, 5);
    //3
    vertex(5, -5, 0);

    endShape();
    
    popStyle();
  
  }
  
  void render2(){
    
    pushStyle();
    
    strokeWeight(2);
    stroke(color(0, 0, 255));
    fill(color(0, 0, 255));

    // highlight boids under the mouse
    if (scene.trackedFrame("mouseMoved") == frame) {
      stroke(color(40, 255, 40));
      fill(color(0, 255, 0, 125));
    }

    // highlight avatar
    if (frame ==  avatar) {
      stroke(color(255, 0, 0));
      fill(color(255, 0, 0));
    }
    
    ramiel = createShape();
    ramiel.beginShape(TRIANGLE);
    
    ramiel.vertex(v0.getX(), v0.getY(), v0.getZ());
    ramiel.vertex(v1.getX(), v1.getY(), v1.getZ());
    ramiel.vertex(v2.getX(), v2.getY(), v2.getZ());

    ramiel.vertex(v0.getX(), v0.getY(), v0.getZ());
    ramiel.vertex(v3.getX(), v3.getY(), v3.getZ());
    ramiel.vertex(v2.getX(), v2.getY(), v2.getZ());
  
    ramiel.vertex(v0.getX(), v0.getY(), v0.getZ());
    ramiel.vertex(v3.getX(), v3.getY(), v3.getZ());
    ramiel.vertex(v4.getX(), v4.getY(), v4.getZ());

    ramiel.vertex(v0.getX(), v0.getY(), v0.getZ());
    ramiel.vertex(v1.getX(), v1.getY(), v1.getZ());
    ramiel.vertex(v4.getX(), v4.getY(), v4.getZ());
  
    ramiel.vertex(v5.getX(), v5.getY(), v5.getZ());
    ramiel.vertex(v1.getX(), v1.getY(), v1.getZ());
    ramiel.vertex(v2.getX(), v2.getY(), v2.getZ());

    ramiel.vertex(v5.getX(), v5.getY(), v5.getZ());
    ramiel.vertex(v3.getX(), v3.getY(), v3.getZ());
    ramiel.vertex(v2.getX(), v2.getY(), v2.getZ());
  
    ramiel.vertex(v5.getX(), v5.getY(), v5.getZ());
    ramiel.vertex(v3.getX(), v3.getY(), v3.getZ());
    ramiel.vertex(v4.getX(), v4.getY(), v4.getZ());

    ramiel.vertex(v5.getX(), v5.getY(), v5.getZ());
    ramiel.vertex(v1.getX(), v1.getY(), v1.getZ());
    ramiel.vertex(v4.getX(), v4.getY(), v4.getZ());
  
    ramiel.endShape();
    
    popStyle();
    
    shape(ramiel);
    
  }
  
  void representation(){
  
    ArrayList<Vertex> vertexSet = new ArrayList();
    
    vertexSet.add(v0);
    vertexSet.add(v1);
    vertexSet.add(v2);
    vertexSet.add(v3);
    vertexSet.add(v4);
    vertexSet.add(v5);
    
    vertexVertex(vertexSet);
    
    Face f0 = new Face(v0, v1, v2);
    Face f1 = new Face(v0, v2, v3);
    Face f2 = new Face(v0, v3, v4);
    Face f3 = new Face(v0, v1, v4);
    Face f4 = new Face(v5, v1, v2);
    Face f5 = new Face(v5, v2, v3);
    Face f6 = new Face(v5, v3, v4);
    Face f7 = new Face(v5, v1, v4);
    
    ArrayList<Face> faceSet = new ArrayList();
    
    faceSet.add(f0);
    faceSet.add(f1);
    faceSet.add(f2);
    faceSet.add(f3);
    faceSet.add(f4);
    faceSet.add(f5);
    faceSet.add(f6);
    faceSet.add(f7);
    
    vertexFace(faceSet);
    
  }
  
  void vertexVertex(ArrayList<Vertex> vertexSet){
    
    vertexVertexSet = new ArrayList();
    
    ArrayList<Vertex> v0Vertex = new ArrayList();
    v0Vertex.add(vertexSet.get(1));
    v0Vertex.add(vertexSet.get(2));
    v0Vertex.add(vertexSet.get(3));
    v0Vertex.add(vertexSet.get(4));
    
    ArrayList<Vertex> v1Vertex = new ArrayList();
    v1Vertex.add(vertexSet.get(0));
    v1Vertex.add(vertexSet.get(2));
    v1Vertex.add(vertexSet.get(4));
    v1Vertex.add(vertexSet.get(5));
    
    ArrayList<Vertex> v2Vertex = new ArrayList();
    v2Vertex.add(vertexSet.get(0));
    v2Vertex.add(vertexSet.get(1));
    v2Vertex.add(vertexSet.get(3));
    v2Vertex.add(vertexSet.get(5));
    
    ArrayList<Vertex> v3Vertex = new ArrayList();
    v3Vertex.add(vertexSet.get(0));
    v3Vertex.add(vertexSet.get(2));
    v3Vertex.add(vertexSet.get(4));
    v3Vertex.add(vertexSet.get(5));
    
    ArrayList<Vertex> v4Vertex = new ArrayList();
    v4Vertex.add(vertexSet.get(0));
    v4Vertex.add(vertexSet.get(1));
    v4Vertex.add(vertexSet.get(3));
    v4Vertex.add(vertexSet.get(5));
    
    ArrayList<Vertex> v5Vertex = new ArrayList();
    v5Vertex.add(vertexSet.get(1));
    v5Vertex.add(vertexSet.get(2));
    v5Vertex.add(vertexSet.get(3));
    v5Vertex.add(vertexSet.get(4));
 
    vertexVertexSet.add(v0Vertex);
    vertexVertexSet.add(v1Vertex);
    vertexVertexSet.add(v2Vertex);
    vertexVertexSet.add(v3Vertex);
    vertexVertexSet.add(v4Vertex);
    vertexVertexSet.add(v5Vertex);
  }
  
  void vertexFace(ArrayList<Face> faceSet){
    
    faceVertexSet = new ArrayList();
    
    ArrayList<Face> v0Vertex = new ArrayList();
    v0Vertex.add(faceSet.get(0));
    v0Vertex.add(faceSet.get(1));
    v0Vertex.add(faceSet.get(2));
    v0Vertex.add(faceSet.get(3));
    
    ArrayList<Face> v1Vertex = new ArrayList();
    v1Vertex.add(faceSet.get(0));
    v1Vertex.add(faceSet.get(3));
    v1Vertex.add(faceSet.get(4));
    v1Vertex.add(faceSet.get(7));
    
    ArrayList<Face> v2Vertex = new ArrayList();
    v2Vertex.add(faceSet.get(0));
    v2Vertex.add(faceSet.get(1));
    v2Vertex.add(faceSet.get(4));
    v2Vertex.add(faceSet.get(5));
    
    ArrayList<Face> v3Vertex = new ArrayList();
    v3Vertex.add(faceSet.get(1));
    v3Vertex.add(faceSet.get(2));
    v3Vertex.add(faceSet.get(5));
    v3Vertex.add(faceSet.get(6));
    
    ArrayList<Face> v4Vertex = new ArrayList();
    v4Vertex.add(faceSet.get(2));
    v4Vertex.add(faceSet.get(3));
    v4Vertex.add(faceSet.get(5));
    v4Vertex.add(faceSet.get(6));
    
    ArrayList<Face> v5Vertex = new ArrayList();
    v5Vertex.add(faceSet.get(4));
    v5Vertex.add(faceSet.get(5));
    v5Vertex.add(faceSet.get(6));
    v5Vertex.add(faceSet.get(7));
 
    faceVertexSet.add(v0Vertex);
    faceVertexSet.add(v1Vertex);
    faceVertexSet.add(v2Vertex);
    faceVertexSet.add(v3Vertex);
    faceVertexSet.add(v4Vertex);
    faceVertexSet.add(v5Vertex); 
  }
}
