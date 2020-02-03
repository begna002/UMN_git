import processing.sound.*;
import peasy.*;

SoundFile launch;
SoundFile explode;
PeasyCam camera;


int numParticles = 1000;
String projectTitle = "Fireworks";

ArrayList<Firework> f = new ArrayList();

void setup() {
  size(1280,720, P3D);
  launch = new SoundFile(this, "Launch.mp3");
  explode = new SoundFile(this, "Explode.mp3");
  camera = new PeasyCam(this, 690, 360, 0, 750);

}

void launchPhysics(Firework curr){
  curr.initalLaunch.y += curr.initalLaunchVel.y;  
}

void drawLaunch(Firework curr){
  noStroke();
  fill(255, 255, 255);
  rect(curr.initalLaunch.x, curr.initalLaunch.y, 10, 20);
}

void explodePhysics(Firework curr){
  for(int i = 0; i < numParticles; i++) {
      curr.particles[i].x += curr.velocity[i].x;
      curr.particles[i].y += curr.velocity[i].y;
      curr.particles[i].z += curr.velocity[i].z;
      
      curr.velocity[i].y += .2; 
  }
}

void drawExplode(Firework curr){
  noStroke();
  strokeWeight(5);
  for(int i = 0; i < numParticles; i++) {
    stroke(curr.particleColor[i][0], curr.particleColor[i][1], curr.particleColor[i][2], curr.fade);
    line(curr.particles[i].x, curr.particles[i].y, curr.particles[i].z, curr.particles[i].x + curr.velocity[i].x*5, curr.particles[i].y + curr.velocity[i].y*5, curr.particles[i].z + curr.velocity[i].z*5);
    curr.particleColor[i][0] += random(-10, 10);
    curr.particleColor[i][1] += random(-10, 10);
    curr.particleColor[i][2] += random(-10, 10);
  }
  curr.fade -=4;
}

void setExplodePosition(Firework curr, float x, float y){
  for(int i = 0; i < numParticles; i++){
    curr.particles[i].x = x;
    curr.particles[i].y = y;
  }
}

void mousePressed(){
  f.add(new Firework(mouseX, mouseY));
  launch.play();
}

void draw() {
  background(0);
  float startFrame = millis(); //Time how long various components are taking
  float endPhysics = millis();
  for(int i = 0; i < f.size(); i++){
    if (f.get(i).launching) {
    launchPhysics(f.get(i));
    endPhysics = millis();
    drawLaunch(f.get(i));
    //Firework is now exploding
    if (f.get(i).initalLaunch.y < f.get(i).maxHeight&&f.get(i).launching == true){
      explode.play();
      int num = int(random(0, 3));
      float[] col = new float[3];
      switch(num){
        case 0: col[0] = 255; col[1] = random(0, 255); col[2] = random(0, 255);break;
        case 1: col[0] = random(0, 255); col[1] =  255; col[2] = random(0, 255);break;
        case 2: col[0] = random(0, 255); col[1] = random(0, 255); col[2] = 255;break;
        default: col[0] = 255; col[0] = 255; col[0] = 255;
      }
      for(int j = 0; j < numParticles; j++){
        f.get(i).particleColor[j][0] = col[0];
        f.get(i).particleColor[j][1] = col[1];
        f.get(i).particleColor[j][2] = col[2];

      }
      f.get(i).exploding = true;
      f.get(i).launching = false;
      setExplodePosition(f.get(i), f.get(i).initalLaunch.x, f.get(i).initalLaunch.y);
    }
   }
   if (f.get(i).exploding){
     explodePhysics(f.get(i));
     endPhysics = millis();
     drawExplode(f.get(i));
     if (f.get(i).fade < 0) {
       f.remove(i);
     }
   }
  }
  float endFrame = millis();
    String runtimeReport = "Frame: "+str(endFrame-startFrame)+"ms,"+
        " Physics: "+ str(endPhysics-startFrame)+"ms,"+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
  print(runtimeReport);
}

class Firework{
 PVector initalLaunch, initalLaunchVel;
 PVector[] particles = new PVector[numParticles];;
 PVector[] velocity = new PVector[numParticles];
 PVector[] time = new PVector[numParticles];
 boolean launching, exploding;
 float[][] particleColor = new float[numParticles][3];
 int fade = 300;
 float maxHeight ;
 
  Firework(float x, float y){
    initalLaunch = new PVector(x, 720, 0);
    initalLaunchVel = new PVector(0, -5);
    launching = true;
    exploding = false;
    maxHeight = y;
    float mult = random(2, 10);
    for (int i = 0; i < numParticles; i++){
        particles[i] = new PVector(0, 0, 0);
        //Sphere Equation derived from CORY SIMON (http://corysimon.github.io/articles/uniformdistn-on-sphere/)
        float theta = 2*PI*random(5);
        float phi = acos(1 - 2 * random(5));
        float xVel = sin(phi) * cos(theta);
        float yVel = sin(phi) * sin(theta);
        float zVel = cos(phi);
        velocity[i] = new PVector(xVel*mult, yVel*mult, zVel*mult);
        launching = true;
        exploding = false;
    }
  }
}
                                                                
