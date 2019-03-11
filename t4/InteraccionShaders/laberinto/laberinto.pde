import processing.serial.*;
import net.java.games.input.*;
import org.gamecontrolplus.*;
import org.gamecontrolplus.gui.*;

ControlDevice cont;
ControlIO control;
int thumb;
float thumb2;
int thumb3;

int counter;
int counter1;
float rotation;
int button;

Maze maze;
boolean drawAxes = true, drawShooterTarget = true, adaptive = true;
PImage label;
PShape sh;

int xPos = 0;
int yPos = 0;

float xRot = 0;
float yRot = 0;

int xMove = 0;
int yMove = 0;

void setup() {
  size(1000, 400, P3D);
  maze = new Maze(15,15);
  maze.generate();
  
  control = ControlIO.getInstance(this);
  cont = control.getMatchedDevice("xbc");

  if (cont == null) {
    println("not today chump"); // write better exit statements than me
    System.exit(-1);
  }
  
  counter = 0;
  counter1 = 0;
  rotation = 1.0;
  button = 0;

}

void printMaze(){
  
  float x = 200;
  float y = 200;
  float z = 200;
  
  float wallHeight = 24;
  float wallWidht = wallHeight * 0.05;
  
  for (int i = 0; i < maze.getRows(); i++){
      for (int j = 0; j < maze.getCols(); j++){
        Cell cell = maze.getMaze()[i][j];
        
        if(i == 0){
          pushMatrix();
          translate(x, y, z);
          fill(22,60,7);
          box(wallHeight, wallWidht, wallHeight);
          popMatrix();
        }
        
        //top
        if( cell.getWalls().get("top") == 1 ){
          pushMatrix();
          translate(x, y, z);
          fill(22,60,7);
          box(wallHeight, wallWidht, wallHeight);
          popMatrix();
        }
        
        //right
        if( cell.getWalls().get("right") == 1 ){
          pushMatrix();
          translate(x + (wallHeight/2), y + (wallHeight/2), z);
          fill(22,60,7);
          box(wallWidht, wallHeight, wallHeight);
          popMatrix();
        }
        
        //bottom
        if( cell.getWalls().get("bottom") == 1 ){
          pushMatrix();
          translate(x, y + wallHeight, z);
          fill(22,60,7);
          box(wallHeight, wallWidht, wallHeight);
          popMatrix();
        }
        
        //left
         
        if( cell.getWalls().get("left") == 1 ){
          pushMatrix();
          translate(x - (wallHeight / 2), y + (wallHeight/2), z);
          fill(22,60,7);
          box(wallWidht, wallHeight, wallHeight);
          popMatrix();
        }
        
        //floor
        
        
        pushMatrix();
        translate(x,y + ( wallHeight/2 ), z - ( wallHeight/2 ) );
        fill(50, 50, 200);
        box( wallHeight, wallHeight  , wallWidht );
        popMatrix();
        
        x = x + wallHeight;
      }
      x = 200;
      y = y + wallHeight;
  }
  
  
}

void draw() {
  getUserInput();
  background(255);
  pointLight(200, 200, 200, width/2, height/2, 360);
  printMaze();
  
  if(thumb == 360){
     counter += 3;
  }else if(thumb == 0){
     counter -= 3;
  }
  
  if(thumb2 == 360){
     counter1 += 3;
  }else if(thumb2 == 0){
     counter1 -= 3;
  }
  
  if(thumb3 == 360){
     rotation += 0.06283;
  }else if(thumb3 == 0){
     rotation -= 0.06283;
  }
  
  int camChange = 0;
  
  if(button == 8){
    camChange = 500;
  }else{
    camChange = 200;
  }
  
  
  
  float lookAround = (width/2)*rotation;
  camera(width/2, 750, camChange, width/2, height/2, 0, 0, 1, 0);
  
  if(lookAround > 2500.0 || lookAround < -2500.0 ){
    beginCamera();
    translate(counter, 0, counter1);
    endCamera();
  }else{
    beginCamera();
    translate(counter1, counter, 0);
    endCamera();
  }
}

public void getUserInput() {
  thumb = int(map(cont.getSlider("yMove").getValue(), 1, -1, 0, 360));
  thumb2 = int(map(cont.getSlider("xMove").getValue(), 1, -1, 0, 360));
  thumb3 = int(map(cont.getSlider("xRot").getValue(), 1, -1, 0, 360));
  button = int(cont.getButton("light").getValue());
}
