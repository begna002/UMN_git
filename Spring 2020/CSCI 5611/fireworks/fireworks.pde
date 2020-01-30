import processing.sound.*;
import peasy.*;

SoundFile launch;
SoundFile explode;
PeasyCam camera;


int numParticles = 500;

ArrayList<Firework> f = new ArrayList();

void setup() {
  size(1280,720, P3D);
  f.add(new Firework(-1000, 2));
  launch = new SoundFile(this, "Launch.mp3");
  explode = new SoundFile(this, "Explode.mp3");
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
      
      curr.velocity[i].y += .1; 
  }
}

void drawExplode(Firework curr){
  noStroke();
  strokeWeight(5);
  for(int i = 0; i < numParticles; i++) {
    fill(curr.particleColor[i], curr.fade);
    ellipse(curr.particles[i].x, curr.particles[i].y, 10, 10);
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
  for(int i = 0; i < f.size(); i++){
    if (f.get(i).launching) {
    launchPhysics(f.get(i));
    drawLaunch(f.get(i));
    //Firework is now exploding
    if (f.get(i).initalLaunch.y < f.get(i).maxHeight&&f.get(i).launching == true){
      explode.play();
      int num = int(random(0, 3));
      color col;
      switch(num){
        case 0: col = color(255, random(0, 255), random(0, 255));break;
        case 1: col = color(random(0, 255), 255, random(0, 255));break;
        case 2: col = color(random(0, 255), random(0, 255), 255);break;
        default: col = color(255, 255, 255);
      }
      for(int j = 0; j < numParticles; j++){
        f.get(i).particleColor[j] = col;
      }
      f.get(i).exploding = true;
      f.get(i).launching = false;
      setExplodePosition(f.get(i), f.get(i).initalLaunch.x, f.get(i).initalLaunch.y);
    }
 }
 if (f.get(i).exploding){
   explodePhysics(f.get(i));
   drawExplode(f.get(i));
   if (f.get(i).fade < 0) {
     f.remove(i);
   }
 }
  }
  
  
}

class Firework{
 PVector initalLaunch, initalLaunchVel;
 PVector[] particles = new PVector[numParticles];;
 PVector[] velocity = new PVector[numParticles];
 PVector[] time = new PVector[numParticles];
 boolean launching, exploding;
 color[] particleColor = new color[numParticles];
 int fade = 300;
 float maxHeight ;
 
  Firework(float x, float y){
    initalLaunch = new PVector(x, 720);
    initalLaunchVel = new PVector(0, -5);
    launching = true;
    exploding = false;
    maxHeight = y;
    for (int i = 0; i < numParticles; i++){
        particles[i] = new PVector(0, 0);
        float angle = 360/random(30);
        velocity[i] = new PVector(sin(radians(angle*i))*random(1, 7), cos(radians(angle*i))*random(1, 7));
        launching = true;
        exploding = false;
    }
  }
}
                                                                
