import processing.sound.*;
import peasy.*;

SoundFile launch;
SoundFile explode;
PeasyCam camera;

PImage grass;
JSONArray locations;
PShape rocket = new PShape();
ArrayList<PShape> people = new ArrayList();
ArrayList<JSONObject> peopleCord = new ArrayList();
ArrayList<Firework> f = new ArrayList();
ArrayList<Trail> trail = new ArrayList();

float[] fireworkPos = new float[7];
int numParticles = 1000;
String projectTitle = "Fireworks";
float gravity = .05;
float zoom = 0; //Zoom magnitude
float translateX = 0; 
float translateY = 0;
boolean firing = false;
boolean movingLoc = false;

void setup() {
  size(1780,1220, P3D);
  launch = new SoundFile(this, "Launch.mp3");
  explode = new SoundFile(this, "Explode.mp3");
  camera = new PeasyCam(this, 690, 360, 700, 1000);
  people.add(loadShape("Audience/Female_LookingUp.obj"));
  people.add(loadShape("Audience/Female_Standing_CoveringEyes.obj"));
  people.add(loadShape("Audience/Female_Standing_Hips.obj"));
  people.add(loadShape("Audience/Female_Walking.obj"));
  people.add(loadShape("Audience/Male_LookingUp.obj"));
  people.add(loadShape("Audience/Male_Standing_Hips.obj"));
  people.add(loadShape("Audience/Male_PickingUp.obj"));
  people.add(loadShape("Audience/Male_Standing_Waving.obj"));
  people.add(loadShape("Audience/Woman_Standing_Waving.obj"));
  rocket = loadShape("rocket/rocket.obj");
  rocket.scale(.03);

  locations = loadJSONArray("Audience/positions.json");
  for(int i = 0; i < people.size(); i++){
    people.get(i).scale(50);
    peopleCord.add(locations.getJSONObject(i));
  }
  for(int i = 1; i < 6; i++){
    fireworkPos[i] = fireworkPos[i-1] + 200;
  }

  grass = loadImage("grass.jpg");

}

void launchPhysics(Firework curr){
  curr.initalLaunch.y += curr.initalLaunchVel.y;  
  curr.timer++;
  if (curr.timer % 5 == 0){
    trail.add(new Trail(curr.initalLaunch.x, curr.initalLaunch.y, curr.initalLaunch.z));
  }
}

void explodePhysics(Firework curr){
  for(int i = 0; i < numParticles; i++) {
      curr.particles[i].x += curr.velocity[i].x;
      curr.particles[i].y += curr.velocity[i].y;
      curr.particles[i].z += curr.velocity[i].z;
      
      curr.velocity[i].y += gravity; 
  }
}

void smokePhysics(Trail trl){
  trl.smoke.x += trl.velocity.x;
  trl.smoke.y += trl.velocity.y;
  trl.smoke.z += trl.velocity.z;

}

void drawTrail(Trail trl){
    if(!trl.isSmokeOn){
      strokeWeight(7);
      stroke(trl.col, trl.life);
      point(trl.position.x+random(-10, 10)+translateX, trl.position.y+random(10, 20)+translateY, trl.position.z+random(-10, 10)+zoom);
      stroke(trl.col, trl.life-100);
      point(trl.position.x+random(-10, 10)+translateX, trl.position.y+random(10, 20)+translateY, trl.position.z+random(-10, 10)+zoom);
      stroke(trl.col, trl.life-50);
      point(trl.position.x+random(-10, 10)+translateX, trl.position.y+random(10, 20)+translateY, trl.position.z+random(-10, 10)+zoom);
      trl.life-=10;
    } else {
      strokeWeight(20);
      stroke(trl.col, trl.life);
      point(trl.smoke.x+trl.offSet+translateX, trl.smoke.y+trl.offSet+translateY, trl.smoke.z+trl.offSet+zoom);
      stroke(trl.col, trl.life-3); 
      point(trl.smoke.x+trl.offSet+translateX, trl.smoke.y+trl.offSet+translateY, trl.smoke.z-trl.offSet+zoom);
      stroke(trl.col, trl.life-15);
      point(trl.smoke.x-trl.offSet+translateX, trl.smoke.y+trl.offSet+translateY, trl.smoke.z-trl.offSet+zoom);
      stroke(trl.col, trl.life-18);
      point(trl.smoke.x-trl.offSet+translateX, trl.smoke.y-trl.offSet+translateY, trl.smoke.z+trl.offSet+zoom);
      stroke(trl.col, trl.life-21);
      point(trl.smoke.x-trl.offSet+translateX, trl.smoke.y-trl.offSet+translateY, trl.smoke.z-trl.offSet+zoom);
      trl.life-=.3;
    }
} 

void drawLaunch(Firework curr){
  noStroke();
  pushMatrix();
  translate(curr.initalLaunch.x+translateX,curr.initalLaunch.y-50+translateY, curr.initalLaunch.z+zoom);
  rotateY(PI);
  rotateZ(PI);
  shape(rocket);
  popMatrix();
}

void drawExplode(Firework curr){
  noStroke();
  strokeWeight(5);
  for(int i = 0; i < numParticles; i++) {
    stroke(curr.particleColor[i][0], curr.particleColor[i][1], curr.particleColor[i][2], curr.fade);
    line(curr.particles[i].x+translateX, curr.particles[i].y+translateY, curr.particles[i].z+zoom, curr.particles[i].x + curr.velocity[i].x*5+translateX, curr.particles[i].y + curr.velocity[i].y*5+translateY, curr.particles[i].z + curr.velocity[i].z*5+zoom);
    line(curr.particles[i].x+translateX, curr.particles[i].y+translateY, curr.particles[i].z+zoom, curr.particles[i].x - curr.velocity[i].x*5+translateX, curr.particles[i].y - curr.velocity[i].y*5+translateY, curr.particles[i].z - curr.velocity[i].z*5+zoom);
    curr.particleColor[i][0] += random(-10, 10);
    curr.particleColor[i][1] += random(-10, 10);
    curr.particleColor[i][2] += random(-10, 10);
  }
  curr.fade -=4;
}

void setExplodePosition(Firework curr, float x, float y, float z){
  for(int i = 0; i < numParticles; i++){
    curr.particles[i].x = x;
    curr.particles[i].y = y;
    curr.particles[i].z = z;
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
      } else if (key == 'w') {
         translateY += 10;
      } else if (key == ' ' && !firing) {
         f.add(new Firework(floor(random(0, 6)), random(-400, -200)));
         launch.play();
         firing = true;
      } 
      else if (key == '1' && !movingLoc) {
         camera.lookAt(0, 100, -300, 750);
         camera.setRotations(camera.getRotations()[0],camera.getRotations()[1]-1.5,camera.getRotations()[2]);
         movingLoc = true;
      } 
      else if (key == '2' && !movingLoc) {
         camera.lookAt(1200, 100, -300, 750);
         camera.setRotations(camera.getRotations()[0],camera.getRotations()[1]+1.5,camera.getRotations()[2]);
         movingLoc = true;
      } 
  }
}
void keyReleased(){
  if (key == ' ' && firing) {
     firing = false;
   } 
  if (key == '1') {
     movingLoc = false;
   } 
}

void draw() {
  background(0);
  lights();
    if(keyPressed) {
      keyPressed();
  }
  //Ground
  pushMatrix();
  beginShape();
  noStroke();
  texture(grass);
  vertex(-1000+translateX, 720+translateY, 2000+zoom, 0, 0);
  vertex(-1000+translateX, 720+translateY, -2000+zoom, grass.width, 0);
  vertex(2000+translateX, 720+translateY, -2000+zoom, grass.width, grass.height);
  vertex(2000+translateX, 720+translateY, 2000+zoom, 0, grass.height);
  endShape();
  popMatrix();
  //People
  for(int i = 0; i < people.size(); i++){
    pushMatrix();
    int x = peopleCord.get(i).getInt("x");
    int y = peopleCord.get(i).getInt("y");
    int z = peopleCord.get(i).getInt("z");

    translate(x+translateX,y+translateY, z+zoom);
    rotateY(PI);
    rotateZ(PI);
    shape(people.get(i));
    popMatrix();
  }
  //holes
  for(int i = 0; i < 6; i++){
    pushMatrix();
    translate(fireworkPos[i], 700, -300); 
    box(40, 20, 40);
    popMatrix();
  }
  //Fireworks
  for(int i = 0; i < f.size(); i++){
    if (f.get(i).launching) {
    launchPhysics(f.get(i));
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
      setExplodePosition(f.get(i), f.get(i).initalLaunch.x, f.get(i).initalLaunch.y, f.get(i).initalLaunch.z);
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
  for(int i = 0; i < trail.size(); i++){
     drawTrail(trail.get(i));
     if (trail.get(i).life <100 && !trail.get(i).isSmokeOn){
       trail.get(i).life = random(70, 100);
       trail.get(i).smoke = new PVector(trail.get(i).position.x+random(-5, 5), trail.get(i).position.y+random(-20, 0), trail.get(i).position.z);
       trail.get(i).isSmokeOn = true;
       float darken = random(50, 200);
       trail.get(i).col = color(darken, darken, darken);
       trail.get(i).velocity = new PVector(random(0, .5), -.5, 0);
       trail.get(i).offSet = random(20);
     } 
     if (trail.get(i).isSmokeOn == true){
       smokePhysics(trail.get(i));
       drawTrail(trail.get(i));
       if (trail.get(i).life < 0) {
         trail.remove(i);
       }
     }
   }
   int numParticles = f.size() + trail.size();
   //Number of exploding particles or just inital launch, for all fireworks
   for(Firework elem : f) {
     if(elem.launching) {
       numParticles += 1;
     } else {
       numParticles += elem.particles.length;
     }
    }
   
   //Number of trail particles plus 3 (3 points drawn per particle), for all trails
   for(Trail elem : trail) {numParticles += 3;};
  
 String runtimeReport = "Number of Particles: "+str(numParticles)+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);
  print(runtimeReport);
  print(runtimeReport);
}

class Trail{
  PVector position;
  PVector velocity;
  PVector smoke;
  float life;
  float smokeLife;
  boolean isSmokeOn;
  color col;
  float offSet;
  
  Trail(float x, float y, float z){
    position = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0); 
    life = 300;
    isSmokeOn = false;
    col = color(255, random(180, 255), 0);
  }
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
 float timer = 0;
 
  Firework(int x, float y){
    initalLaunch = new PVector(fireworkPos[x], 720, -300);
    initalLaunchVel = new PVector(0, -5);
    launching = true;
    exploding = false;
    maxHeight = y;
    float mult = random(2, 9);
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
                                                                
