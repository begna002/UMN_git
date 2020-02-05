import processing.sound.*;
import peasy.*;

SoundFile fountainSound;
PeasyCam camera;
int numParticles = 20000;

PShape s;
PShape s2;
PImage grass;
PVector gravity;   // Gravity acts at the shape's acceleration
PVector carLoc;
PVector[] ball = new PVector[numParticles];  // ball1of shape
PVector[] velocity = new PVector[numParticles];  // Velocity of shape


int[] numBounces = new int[numParticles];  // Return particle after a certain amount
float[] delay = new float[numParticles]; //Starting Delay for particles
boolean[] hasStarted = new boolean[numParticles]; //Particle is starting
float[] transperency = new float[numParticles];
int radius = 7;
int waterDirection = 1;
String projectTitle = "Water Fountain";
float zoom = 0; //Zoom magnitude
float translateX = 0; 
float translateY = 0;
color[] col = new color[numParticles];

void setup() {
  size(1780,1220, P3D);
  noStroke();
  s = loadShape("CarFolder/Car.obj");
  s.scale(100);
  s2 = loadShape("EagleFolder/Eagle.obj");
  s2.scale(18.0);
  fountainSound = new SoundFile(this, "rain.mp3");
  fountainSound.loop(1.0, .5, .7);
  grass = loadImage("grass.jpg");
  camera = new PeasyCam(this, 690+translateX, 360+translateY, 0+zoom, 1000);
  for(int i = 0; i < numParticles; i++) {
    float angle = 360/random(30);
    ball[i] = new PVector(random(630, 650), random(400, 475), 0);
    velocity[i] = new PVector(cos(radians(angle*i))*random(1, 15), random(-40, -20), sin(radians(angle*i))*random(1, 15));
    waterDirection*=-1;
    numBounces[i]=0;
    delay[i] = random(0, 100);
    hasStarted[i] = false;
    transperency[i]=300;
    col[i] = color(21,112,233);
  }
  gravity = new PVector(0,3);
  //fountainSound.play();
}

void drawScene() {
  background(0, 51, 102);
  blendMode(0);
  lights();
  //Ground
  pushMatrix();
  beginShape();
  noStroke();
  texture(grass);
  vertex(-1000+translateX, 720+translateY, 1000+zoom, 0, 0);
  vertex(-1000+translateX, 720+translateY, -2000+zoom, grass.width, 0);
  vertex(2000+translateX, 720+translateY, -2000+zoom, grass.width, grass.height);
  vertex(2000+translateX, 720+translateY, 1000+zoom, 0, grass.height);
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
  blendMode(SCREEN);
  for(int i = 0; i < numParticles; i++){
      //Only draw when inital delay point is reached
    if(hasStarted[i]) {
        stroke(col[i], transperency[i]);
        point(ball[i].x+translateX,ball[i].y+translateY, ball[i].z+zoom);
        transperency[i]-=20;
      }
  }
}

void computePhysics(float dt){
  // Add velocity to the ball1.
  for(int i = 0; i < numParticles; i++){
    //If delay point is reached, start movement
    if (delay[i] > 75){
      hasStarted[i] = true;
      ball[i].x += velocity[i].x*dt;
      ball[i].y += velocity[i].y*dt;
      ball[i].z += velocity[i].z*dt;
      velocity[i].x += gravity.x*dt;
      velocity[i].y += gravity.y*dt;
    }
    delay[i] += 1;
    
    //when water has bounced 4 times, send back to middle
    if (numBounces[i] > 4) {
      ball[i].x = random(640, 650);
      ball[i].y = random(400, 475);
      ball[i].z = 0;
      float angle = 360/random(30);
      velocity[i].x = cos(radians(angle*i))*random(1, 15);
      velocity[i].z = sin(radians(angle*i))*random(1, 15);
      waterDirection*=-1;
      velocity[i].y = random(-40, -20);
      numBounces[i] = 0;
      transperency[i] = 300;
      col[i] = color(21,50,233);
    }
    //Hits ground
    if (ball[i].y + radius/2> (height-551)) {
      // Calculate Reflection
      PVector normal = new PVector(0, -1, 0);
      PVector Vnorm = normal.mult(velocity[i].dot(normal));
      velocity[i] = velocity[i].sub(Vnorm.mult((1+.1)));
      col[i] = color(121,212,255);
      
      numBounces[i]++;
    }
    //Hits top car
    if (ball[i].y>528 && ball[i].x>750 && ball[i].x<930 && ball[i].z < 300 && ball[i].z > 100){
      PVector normal = new PVector(0, -1, 0);
      PVector Vnorm = normal.mult(velocity[i].dot(normal));
      velocity[i] = velocity[i].sub(Vnorm.mult((1+.05)));
      numBounces[i]++;
      col[i] = color(121,212,255);
    }
    //Hits Hood
    if (ball[i].y>600 && ball[i].x>580 && ball[i].x<750 && ball[i].z < 300 && ball[i].z > 100){
      PVector normal = new PVector(0, -1, 0);
      PVector Vnorm = normal.mult(velocity[i].dot(normal));
      velocity[i] = velocity[i].sub(Vnorm.mult((1+.1)));
      numBounces[i]++;
      col[i] = color(121,212,255);
    } 
    //Hits Side of car
    if (ball[i].y>600 && ball[i].y<720 && ball[i].x>580 && ball[i].x<1000 && ball[i].z > 100){
      PVector normal = new PVector(0, 0, -1);
      PVector Vnorm = normal.mult(velocity[i].dot(normal));
      velocity[i] = velocity[i].sub(Vnorm.mult((1+.1)));
      numBounces[i]++;
      col[i] = color(121,212,255);
    }
    
    //Hits Trunk
    if (ball[i].y>610 && ball[i].x>930 && ball[i].x<1000 && ball[i].z < 300 && ball[i].z > 100){
      PVector normal = new PVector(0, -1, 0);
      PVector Vnorm = normal.mult(velocity[i].dot(normal));
      velocity[i] = velocity[i].sub(Vnorm.mult((1+.1)));
      numBounces[i]++;
      col[i] = color(121,212,255);
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      zoom += 10;
    } else if (keyCode == DOWN) {
      zoom -=10;
    }  
    } else if (keyPressed) {
        if (key == 'a') {
        translateX += 10;
        } else if (key == 'd') {
          translateX -= 10;
        } else if (key == 's') {
           translateY -= 10;
        } 
        else if (key == 'w') {
           translateY += 10;
        } 
    }
}

void draw() {
  background(0);
  if(keyPressed) {
      keyPressed();
  }
  computePhysics(.9);
  drawScene();
    String runtimeReport = "Number of Particles: "+str(numParticles)+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
  print(runtimeReport);

}
