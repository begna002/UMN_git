import processing.opengl.*;

int numParticles = 5000;
PVector[] ball = new PVector[numParticles];  // ball1of shape
PVector[] velocity = new PVector[numParticles];  // Velocity of shape
int[] numBounces = new int[numParticles];  // Return particle after a certain amount
float[] delay = new float[numParticles]; //Starting Delay for particles
boolean[] hasStarted = new boolean[numParticles]; //Particle is starting
int[] transperency = new int[numParticles];


PVector gravity;   // Gravity acts at the shape's acceleration
int radius = 5;
int waterDirection = 1;
PImage img;
String projectTitle = "Water";

void setup() {
  size(1280,720, P3D);
  noStroke();
  img = loadImage("fountain.jpg");
  for(int i = 0; i < numParticles; i++) {
    ball[i] = new PVector(random(630, 650), random(200, 475));
    velocity[i] = new PVector(random(8*waterDirection, 5*waterDirection), random(-40, -20));
    waterDirection*=-1;
    numBounces[i]=0;
    delay[i] = random(0, 100);
    hasStarted[i] = false;
    transperency[i]=500;
  }
  gravity = new PVector(0,1);
}

void drawScene() {
  background(0, 0, 0);
  // Display fountain
  image(img, 520, 475);
  noStroke();
  for(int i = 0; i < numParticles; i++){
      //Only draw when inital delay point is reached
      if(hasStarted[i]) {
        // Randomize opacity
        fill(12,107,255,transperency[i]);
        ellipse(ball[i].x,ball[i].y,radius,radius);
      }
  }
}

void draw() {
  background(0);
  float startFrame = millis(); //Time how long various components are taking
  
  // Add velocity to the ball1.
  for(int i = 0; i < numParticles; i++){
    //If delay point is reached, start movement
    if (delay[i] > 75){
      hasStarted[i] = true;
      ball[i].x += velocity[i].x;
      ball[i].y += velocity[i].y;
      velocity[i].x += gravity.x;
      velocity[i].y += gravity.y;
      transperency[i] -=5;
    }
    delay[i] += 1;
    
    //upon particle recycling
    if ((ball[i].x + radius/2 - random(0, 200)> width) || (ball[i].x - radius/2 + random(0, 200) < 0)
    || numBounces[i] == 4) {
    //when water reaches edge, or has bounced 4 times, send back to middle
    ball[i].x = random(640, 650);
    ball[i].y = random(200, 475);
    velocity[i].x = random(8*waterDirection, 5*waterDirection);
    waterDirection*=-1;
    velocity[i].y = random(-40, -20);
    numBounces[i] = 0;
    transperency[i] = 500;
    }
    if (ball[i].y + radius/2> height) {
      // Reduce y velocity by random amount, x veloxity can now go left or right
      velocity[i].y = velocity[i].y * random(-0.5, -.2); 
      velocity[i].x *= random(1*waterDirection, 3*waterDirection);
      waterDirection *= -1;
      numBounces[i]++;
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
