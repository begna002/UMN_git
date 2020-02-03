import processing.sound.*;
import peasy.*;

PShape s;
PShape s2;
PImage img;
SoundFile fountainSound;


int numParticles = 20000;
PeasyCam camera;
PVector[] ball = new PVector[numParticles];  // ball1of shape
PVector[] velocity = new PVector[numParticles];  // Velocity of shape
int[] numBounces = new int[numParticles];  // Return particle after a certain amount
float[] delay = new float[numParticles]; //Starting Delay for particles
boolean[] hasStarted = new boolean[numParticles]; //Particle is starting
int[] transperency = new int[numParticles];


PVector gravity;   // Gravity acts at the shape's acceleration
int radius = 7;
int waterDirection = 1;
String projectTitle = "Water";
float zoom = 0; //Zoom magnitude
float translateX = 0; 
float translateY = 0;
PVector carLoc;
color[] col = new color[numParticles];

void setup() {
  size(1780,1220, P3D);
  noStroke();
  s = loadShape("CarFolder/Car.obj");
  s.scale(100);
  s2 = loadShape("EagleFolder/Eagle.obj");
  s2.scale(18.0);
  fountainSound = new Soundfile(this, "rain.mp3");
  camera = new PeasyCam(this, 690+translateX, 360+translateY, 0+zoom, 1000);
  for(int i = 0; i < numParticles; i++) {
    float angle = 360/random(30);
    ball[i] = new PVector(random(630, 650), random(400, 475), 0);
    velocity[i] = new PVector(cos(radians(angle*i))*random(1, 15), random(-40, -20), sin(radians(angle*i))*random(1, 15));
    waterDirection*=-1;
    numBounces[i]=0;
    delay[i] = random(0, 100);
    hasStarted[i] = false;
    transperency[i]=500;
    col[i] = color(51,142,233);
  }
  gravity = new PVector(0,3);
}

void drawScene() {
  background(0, 51, 102);
  blendMode(0);
  lights();
  //Ground
  pushMatrix();
  noStroke();
  fill(70, 70, 70);
  beginShape();
  vertex(-1000+translateX, 720+translateY, 1000+zoom);
  vertex(-1000+translateX, 720+translateY, -2000+zoom);
  vertex(2000+translateX, 720+translateY, -2000+zoom);
  vertex(2000+translateX, 720+translateY, 1000+zoom);
  endShape();
  popMatrix();
  // Display Car
  pushMatrix();
  translate(800+translateX,720+translateY,200+zoom);
  rotateZ(PI);
  rotateY(PI/2);
  shape(s);
  popMatrix();
  // Display fountain
  pushMatrix();
  translate(645+translateX,720+translateY, zoom);
  //rotateZ(PI);
  rotateX(PI/2);
  rotateZ(PI);
  shape(s2);
  popMatrix();
  noStroke();
  strokeWeight(7);
  blendMode(ADD);
  for(int i = 0; i < numParticles; i++){
      //Only draw when inital delay point is reached
    if(hasStarted[i]) {
        stroke(col[i], transperency[i]);
        point(ball[i].x+translateX,ball[i].y+translateY, ball[i].z+zoom);
        transperency[i]-=5;
      }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      zoom += 5;
    } else if (keyCode == DOWN) {
      zoom -=5;
    }  
  } else if (keyPressed) {
      if (key == 'a') {
      translateX += 5;
      } else if (key == 'd') {
        translateX -= 5;
      } else if (key == 's') {
         translateY -= 5;
      } 
      else if (key == 'w') {
         translateY += 5;
      } 
  }
}

void draw() {
  background(0);
  float startFrame = millis(); //Time how long various components are taking
  if(keyPressed) {
      keyPressed();
  }
  
  // Add velocity to the ball1.
  for(int i = 0; i < numParticles; i++){
    //If delay point is reached, start movement
    if (delay[i] > 75){
      hasStarted[i] = true;
      ball[i].x += velocity[i].x;
      ball[i].y += velocity[i].y;
      ball[i].z += velocity[i].z;
      velocity[i].x += gravity.x;
      velocity[i].y += gravity.y;
      transperency[i] -=5;
    }
    delay[i] += 1;
    
    //when water has bounced 4 times, send back to middle
    if (numBounces[i] == 4) {
    ball[i].x = random(640, 650);
    ball[i].y = random(400, 475);
    ball[i].z = 0;
    float angle = 360/random(30);
    velocity[i].x = cos(radians(angle*i))*random(1, 15);
    velocity[i].z = sin(radians(angle*i))*random(1, 15);
    waterDirection*=-1;
    velocity[i].y = random(-40, -20);
    numBounces[i] = 0;
    transperency[i] = 500;
    col[i] = color(51,142,233);
    }
    //Hits ground
    if (ball[i].y + radius/2> (height-550)) {
      // Reduce y velocity by random amount
      velocity[i].y = velocity[i].y * -.2; 
      velocity[i].x *= .5;
      if(ball[i].x>500 && ball[i].z > 0){
        velocity[i].z = 0;
      } else {
          velocity[i].z *= .5;
      }
      numBounces[i]++;
    }
    //Hits top car
    if (ball[i].y>530 && ball[i].x>750 && ball[i].x<1000 && ball[i].z < 300 && ball[i].z > 70){
      velocity[i].y = velocity[i].y * -.05; 
      velocity[i].x *= .05;
      velocity[i].z *= .05;
      numBounces[i]++;
      transperency[i] = 900;
      col[i] = color(51,142,255);
    }
    if (ball[i].y>600 && ball[i].x>580 && ball[i].x<750 && ball[i].z < 300 && ball[i].z > 70){
      velocity[i].y = velocity[i].y * -.05; 
      velocity[i].x *= .05;
      velocity[i].z *= .05;
      numBounces[i]++;
      transperency[i] = 900;
      col[i] = color(51,142,255);
    }
  }
  float endPhysics = millis();

  drawScene();
  float endFrame = millis();
    String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ str(endPhysics-startFrame)+"ms,"+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
  print(runtimeReport);

}
