float floor = 1000;
float grav = 500; //0
float radius = 7;
float restLen = 30;
float mass = 10;
float k = 3700; //1 1000
float kv = 60;
int numPoints = 31;
int numStrings = 31;
Camera camera;
int showSpheres = -1;
int addWind;
PVector ball = new PVector(-100, 3000, -2000);
int ballRad = 500;
String projectTitle = "Cloth";
PImage texture;
boolean[][] burnSeg = new boolean[31][31];
boolean[] burningString = new boolean[31];
boolean isBurning = false;
boolean moveFire = false;
int burnCounter = 0;
int burnInc = 0;
int burnMov = 1;
ArrayList<Trail> trail = new ArrayList();
boolean removeTrail = false;
int createMovingSmoke = 0;
boolean removeSmoke = false;
boolean setUpBall = false;



ArrayList<Strings> strings = new ArrayList();

void init(){
  camera = new Camera();
  texture = loadImage("cloth.jpg");
  showSpheres = -1;
  ball.x = 200; ball.y = 2500; ball.z = -2000;
  ballRad = 500;
  burnSeg = new boolean[31][31];
  burningString = new boolean[31];
  isBurning = false;
  moveFire = false;
  burnCounter = 0;
  burnInc = 0;
  burnMov = 1;
  strings = new ArrayList();
  trail = new ArrayList();
  removeTrail = false;
  createMovingSmoke = 0;
  removeSmoke = false;
  
  float stringX = -400;
  float windX = 0;
  float windZ = 0;
  for (int i = 0; i < numStrings; i++){
    strings.add(new Strings());
  }
  for (int j = 0; j < numStrings; j++){
    burningString[j] = false;
    float yposInc = 200;
    strings.get(j).anchorX = stringX;
    strings.get(j).anchorY = 100;
    strings.get(j).anchorZ = 0;
    for(int i = 0; i < numPoints; i++){
      burnSeg[j][i] = false;
      strings.get(j).point.add(new PVector(strings.get(j).anchorX, yposInc, 0));
      float windx = random(0, 75);
      float windy = random(0, 200);
      float windz = random(0, 200);

      strings.get(j).vel.add(new PVector(100+windx, 100+windy, 100+windz));
      strings.get(j).accel.add(new PVector(0, 0, 0));
      strings.get(j).force.add(new PVector(0, 0, 0));
      strings.get(j).projVel[i] = 0;
      yposInc += 60;
    }
    stringX += 50;
  }
}

void setup() {
  size(1500, 1500, P3D);
  frameRate(30);
    surface.setTitle("Strings");
  init();
  
}

void burnCloth(){
  if(burnCounter%(10+burnInc) == 0){
    for(int i = 0; i < numStrings; i++){
      //if (burningString[i]){
           for(int j = 0; j < numPoints; j++){
        if(burnSeg[i][j] == true){
          if( j > 0){
            if(burnSeg[i][j-1] == false & moveFire){
               trail.add(new Trail(strings.get(i).point.get(j).x, strings.get(i).point.get(j).y, strings.get(i).point.get(j).z, strings.get(i).vel.get(j), i, j, false));
            }
            burnSeg[i][j-1] = true;
          }
           if( i < 30){
             if(burnSeg[i+1][j] == false & moveFire){
               trail.add(new Trail(strings.get(i).point.get(j).x, strings.get(i).point.get(j).y, strings.get(i).point.get(j).z, strings.get(i).vel.get(j), i, j, false));
              }
            burnSeg[i+1][j] = true;
          }
        }
      }
      //}
    }
    if(createMovingSmoke%2 == 0 && !removeSmoke){
      for(int i = 0; i < 10; i++){
        int ind = floor(random(0,trail.size()));
        trail.add(new Trail(trail.get(ind).smokePosition.x, trail.get(ind).smokePosition.y, trail.get(ind).smokePosition.z, strings.get(0).vel.get(0), 0, 0, true));
      }
      
    }
  }
  if(burnMov < numStrings){
      burningString[burnMov] = true;
      burnMov++;
  }

}


void firePhysics(Trail trl){
  if(!trl.isMovingSmoke){
    trl.smoke.x = strings.get(trl.i).point.get(trl.j-trl.pos).x;
    trl.smoke.y = strings.get(trl.i).point.get(trl.j-trl.pos).y+10;
    trl.smoke.z = strings.get(trl.i).point.get(trl.j-trl.pos).z+30;
    if(burnCounter%(10+burnInc) == 0 & trl.pos<numPoints){
      trl.pos+=1;
    }
    if(trl.pos >= numPoints -1){
      trl.pos = numPoints-1;
    }
  }
  
}

void smokePhysics(Trail trl){
  if(trl.isMovingSmoke){//Dispersing smoke objs
      trl.smokePosition.x += trl.velocity.x;
      trl.smokePosition.y += trl.velocity.y;
      trl.smokePosition.z += trl.velocity.z;
      trl.smokeLife -= random(5, 10);
  } else{
    if(trl.pos >= numPoints -1){
      trl.smokePosition.x += trl.velocity.x;
      trl.smokePosition.y += trl.velocity.y;
      trl.smokePosition.z += trl.velocity.z;
      trl.smokeLife -= random(5, 10);
    } else {
       trl.smokePosition.x = strings.get(trl.i).point.get(trl.j-trl.pos).x;
       trl.smokePosition.y = strings.get(trl.i).point.get(trl.j-trl.pos).y-30 + trl.velocity.y;
       trl.smokePosition.z = strings.get(trl.i).point.get(trl.j-trl.pos).z+30;
    }
  }

 
}

void drawTrail(Trail trl){
    if(!trl.isSmokeOn || trl.lifeF > 10){
      trl.lifeF-=10;
    } 
    if (trl.isSmokeOn) {
      strokeWeight(10);
      int[] offsetDir = {-1, 1};
      int life = 3;
      if(!trl.isMovingSmoke){
        for(int i = 0; i < 30; i++){
          stroke(trl.col, trl.life-life);
          point(trl.smoke.x+trl.offSet*offsetDir[floor(random(2))]+ random(5, 50)*offsetDir[floor(random(2))], trl.smoke.y+trl.offSet*offsetDir[floor(random(2))]-random(20, 200), trl.smoke.z+trl.offSet*offsetDir[floor(random(2))]);
          life+=1;
        }
      }

      life = -15;
      for(int i = 0; i < 20; i++){
        stroke(trl.smokeCol, trl.smokeLife-15);
              strokeWeight(20);
        point(trl.smokePosition.x+trl.offSet*offsetDir[floor(random(2))], trl.smokePosition.y+trl.offSet*offsetDir[floor(random(2))]-random(50, 200), trl.smokePosition.z+trl.offSet*offsetDir[floor(random(2))]);
        life-=2;
      }
    }
} 

void update(float dt){
   for (int j = 0; j < numStrings; j++){
     Strings str = strings.get(j);
     for (int i = 0; i < numPoints; i ++){ 
      float sx, sy, sz, stringLen, dampF;
      //Vertical
      if(i == 0){
        sx = (str.point.get(i).x - str.anchorX);
        sy = (str.point.get(i).y - str.anchorY);
        sz = (str.point.get(i).z - str.anchorZ);
        stringLen = sqrt(sx*sx + sy*sy + sz*sz);
        
      } else {
        sx = (str.point.get(i).x - str.point.get(i-1).x);
        sy = (str.point.get(i).y - str.point.get(i-1).y);
        sz = (str.point.get(i).z - str.point.get(i-1).z);
        stringLen = sqrt(sx*sx + sy*sy + sz*sz);
      }
         
        float stringF = -k*(stringLen - restLen);
        float dirX = sx/stringLen;
        float dirY = sy/stringLen;
        float dirZ = sz/stringLen;

        str.projVel[i] = str.vel.get(i).x*dirX + str.vel.get(i).y*dirY + str.vel.get(i).z*dirZ;
        if (i == numPoints - 1){//last point
          dampF = -kv*(str.projVel[i] - 0);
        } else {
          str.projVel[i+1] = str.vel.get(i+1).x*dirX + str.vel.get(i+1).y*dirY + str.vel.get(i+1).z*dirZ;
          dampF = -kv*(str.projVel[i+1] + str.projVel[i]);
        }
        
        
        str.force.get(i).x = (stringF+dampF)*dirX;
        str.force.get(i).y = (stringF+dampF)*dirY;
        str.force.get(i).z = (stringF+dampF)*dirZ;
        if(i == numPoints - 1){//last point
          str.vel.get(i).x += (.5*str.force.get(i).x/mass)*dt;
          str.vel.get(i).z += (.5*str.force.get(i).z/mass)*dt+addWind;
          str.vel.get(i).y += (grav + (.5*str.force.get(i).y)/mass)*dt;
        } else {
          str.vel.get(i).x += ((.5*str.force.get(i).x - .5*str.force.get(i+1).x)/mass)*dt;
          str.vel.get(i).z += ((.5*str.force.get(i).z - .5*str.force.get(i+1).z)/mass)*dt+addWind;
          str.vel.get(i).y += (grav + (.5*str.force.get(i).y - .5*str.force.get(i+1).y)/mass)*dt;
          
        }
  

       ////Horizontal
       //if (j < numStrings - 1){
       //   sx = (str.point.get(i).x - strings.get(j+1).point.get(i).x);
       //   sy = (str.point.get(i).y - strings.get(j+1).point.get(i).y);
       //   sz = (str.point.get(i).z - strings.get(j+1).point.get(i).z);
       //   stringLen = sqrt(sx*sx + sy*sy + sz*sz);
        
           
       //   float stringFR = -k*(stringLen - restLen);
       //   float dirXL = sx/stringLen;
       //   float dirYL = sy/stringLen;
       //   float dirZL = sz/stringLen;
  
       //   str.projVel[i] = str.vel.get(i).x*dirXL + str.vel.get(i).y*dirYL + str.vel.get(i).z*dirZL;
       //   if (j == 0){
       //     dampF = 0;
       //   } else {
       //     strings.get(j+1).projVel[i] = strings.get(j+1).vel.get(i).x*dirXL + strings.get(j+1).vel.get(i).y*dirYL + strings.get(j+1).vel.get(i).z*dirZL;
       //     dampF = -kv*(str.projVel[i] + strings.get(j+1).projVel[i]);
       //   }
                  
          
          
       //   str.force.get(i).x = (stringFR+dampF)*dirXL;
       //   str.force.get(i).y = (stringFR+dampF)*dirYL;
       //   str.force.get(i).z = (stringFR+dampF)*dirZL;
 
       //   str.vel.get(i).x += ((.5*str.force.get(i).x - .5*strings.get(j+1).force.get(i).x)/mass)*dt;
       //   str.vel.get(i).y += ((.5*str.force.get(i).y - .5*strings.get(j+1).force.get(i).y)/mass)*dt;
       //   str.vel.get(i).z += ((.5*str.force.get(i).z - .5*strings.get(j+1).force.get(i).z)/mass)*dt;

       //}

       
             
      str.point.get(i).x += str.vel.get(i).x*dt;
      str.point.get(i).y += str.vel.get(i).y*dt;
      str.point.get(i).z += str.vel.get(i).z*dt;
     }       
   }
   addWind=0;
}

void keyPressed()
{
  camera.HandleKeyPressed();
  if (keyPressed){
    if (key == ' ') {
      showSpheres*=-1;
    } 
    else if (key == 'z') {
      addWind = 20;
    }
    else if (key == 'x') {
      addWind = -20;
    } 
    else if (key == 'c') {
      init();
    } 
    else if (key == 'u') {
      setUpBall = true;
    } 
    else if (key == 'l') { //Start Burn
      burnSeg[0][numPoints-1] = true;
      burningString[0] = true;
      isBurning = true;
      moveFire = true;
    } 
    else if (key == 'i') { //Increase Burn Rate
      if (isBurning){
        burnInc -= 1;
        if (burnInc <= -10){
          burnInc = 1;
        }
      }
    } 
    else if (key == 'o') { //Decrease Burn Rate
      if (isBurning){
        burnInc += 1;
      }
    } 
   }
}
void sphereMovement(){
  if (key == 'f') {
    ball.z +=20;
  } else if (key == 'b') {
    ball.z -=20;
  }
}

void keyReleased()
{
  camera.HandleKeyReleased();
}


void draw() {
  background(0,0,0);
  if(!isBurning){
    lights();
  }

  if(keyPressed) {
      sphereMovement();
  }
  camera.Update( 1.0/frameRate );
  for (int i = 0; i < 50; i++){
    update(1/(10.0*frameRate));
  }
  for(int j = 0; j < numStrings; j++){
    for(int i = 0; i < numPoints; i++){
      pushMatrix();
      fill(255,255,255);
      stroke(200);
      float distance = (strings.get(j).point.get(i)).dist(ball);
      if(distance < ballRad+radius+.9) {
       PVector dist = new PVector(strings.get(j).point.get(i).x - ball.x, strings.get(j).point.get(i).y - ball.y, strings.get(j).point.get(i).z - ball.z).normalize();
       strings.get(j).point.get(i).x = ball.x + dist.x*ballRad*1.15;
       strings.get(j).point.get(i).y = ball.y + dist.y*ballRad*1.15;
       strings.get(j).point.get(i).z = ball.z + dist.z*ballRad*1.15;
       
       strings.get(j).vel.get(i).x *= -.0000001;
       strings.get(j).vel.get(i).y *= -.0000001;
       strings.get(j).vel.get(i).z *= -.0000001;

      }
      noStroke();
      if(i == 0){
        line(strings.get(j).anchorX,strings.get(j).anchorY, strings.get(j).anchorZ, strings.get(j).point.get(i).x,strings.get(j).point.get(i).y, strings.get(j).point.get(i).z);
      } else {
        line(strings.get(j).point.get(i-1).x,strings.get(j).point.get(i-1).y, strings.get(j).point.get(i-1).z, strings.get(j).point.get(i).x,strings.get(j).point.get(i).y, strings.get(j).point.get(i).z);
      }
      if (showSpheres == 1){
        translate(strings.get(j).point.get(i).x,strings.get(j).point.get(i).y, strings.get(j).point.get(i).z);
        noStroke();
        fill(0,200,10);
        sphere(radius);
      }
      popMatrix();
      for(int m = 0; m < trail.size(); m++){//string point and smoke collision detection
         float distanceS = (strings.get(j).point.get(i)).dist(trail.get(m).smokePosition);
         if (distanceS < 3){
           trail.get(m).velocity.z *= -1;
           }
         
      }
    }
  }
  //if(setUpBall){
  //    directionalLight(255, 255, 255, 0, 0, -1); 
  //}
  for(int k = 0; k < numStrings - 1; k++){
        for(int l = 0; l < numPoints - 1; l++){
          if(showSpheres == -1){
            pushMatrix();
            beginShape();
            noStroke();
            if (burnSeg[k][l]){
              fill(0, 0, 0);
            } else {
              texture(texture);
            }
            if(!setUpBall){
              vertex(strings.get(k).point.get(l).x,strings.get(k).point.get(l).y, strings.get(k).point.get(l).z, 0, 0);
              vertex(strings.get(k+1).point.get(l).x,strings.get(k+1).point.get(l).y, strings.get(k+1).point.get(l).z, 0, texture.height);
              vertex(strings.get(k).point.get(l+1).x,strings.get(k).point.get(l+1).y, strings.get(k).point.get(l+1).z, texture.width, 0);
              
              endShape();
              popMatrix();
              pushMatrix();
              beginShape();
              noStroke();
              if (burnSeg[k][l]){
                fill(0, 0, 0);
                if(l == 0){
                  removeTrail = true;
                }
              } else {
                texture(texture);
              }
              vertex(strings.get(k).point.get(l+1).x,strings.get(k).point.get(l+1).y, strings.get(k).point.get(l+1).z, texture.width, 0);
              vertex(strings.get(k+1).point.get(l+1).x,strings.get(k+1).point.get(l+1).y, strings.get(k+1).point.get(l+1).z, texture.width, texture.height);
              vertex(strings.get(k+1).point.get(l).x,strings.get(k+1).point.get(l).y, strings.get(k+1).point.get(l).z, 0, texture.height);
              endShape();
              popMatrix();
              
            } else {
              if ((strings.get(k).point.get(l)).dist(strings.get(k+1).point.get(l)) > 50){
              PVector dist = new PVector(strings.get(k+1).point.get(l).x - strings.get(k).point.get(l).x, strings.get(k+1).point.get(l).y - strings.get(k).point.get(l).y, strings.get(k+1).point.get(l).z - strings.get(k).point.get(l).z);
      
              strings.get(k+1).point.get(l).x = strings.get(k).point.get(l).x + dist.x*.9;
              strings.get(k+1).point.get(l).y = strings.get(k).point.get(l).y + dist.y*.9;
              strings.get(k+1).point.get(l).z = strings.get(k).point.get(l).z + dist.z*.9;

              
              vertex(strings.get(k).point.get(l).x,strings.get(k).point.get(l).y, strings.get(k).point.get(l).z, 0, 0);
              vertex(strings.get(k+1).point.get(l).x,strings.get(k+1).point.get(l).y, strings.get(k+1).point.get(l).z, 0, texture.height);
              vertex(strings.get(k).point.get(l+1).x,strings.get(k).point.get(l+1).y, strings.get(k).point.get(l+1).z, texture.width, 0);
            } else {
               vertex(strings.get(k).point.get(l).x,strings.get(k).point.get(l).y, strings.get(k).point.get(l).z, 0, 0);
               vertex(strings.get(k+1).point.get(l).x,strings.get(k+1).point.get(l).y, strings.get(k+1).point.get(l).z, 0, texture.height);
               vertex(strings.get(k).point.get(l+1).x,strings.get(k).point.get(l+1).y, strings.get(k).point.get(l+1).z, texture.width, 0);
            }
            endShape();
            popMatrix();
            
            pushMatrix();
            beginShape();
            noStroke();
            if (burnSeg[k][l]){
              fill(0, 0, 0);
              if(l == 0){
                removeTrail = true;
              }
            } else {
              texture(texture);
            }
            if((strings.get(k).point.get(l+1)).dist(strings.get(k+1).point.get(l+1)) > 50){
              PVector dist = new PVector(strings.get(k+1).point.get(l+1).x - strings.get(k).point.get(l+1).x, strings.get(k+1).point.get(l+1).y - strings.get(k).point.get(l+1).y, strings.get(k+1).point.get(l+1).z - strings.get(k).point.get(l+1).z);
              
              strings.get(k+1).point.get(l+1).x = strings.get(k).point.get(l+1).x + dist.x*.9;
              strings.get(k+1).point.get(l+1).y = strings.get(k).point.get(l+1).y + dist.y*.9;
              strings.get(k+1).point.get(l+1).z = strings.get(k).point.get(l+1).z + dist.z*.9;
              
              vertex(strings.get(k).point.get(l+1).x,strings.get(k).point.get(l+1).y, strings.get(k).point.get(l+1).z, texture.width, 0);
              vertex(strings.get(k+1).point.get(l+1).x,strings.get(k+1).point.get(l+1).y, strings.get(k+1).point.get(l+1).z, texture.width, texture.height);
              vertex(strings.get(k+1).point.get(l).x,strings.get(k+1).point.get(l).y, strings.get(k+1).point.get(l).z, 0, texture.height);
            } else {
              vertex(strings.get(k).point.get(l+1).x,strings.get(k).point.get(l+1).y, strings.get(k).point.get(l+1).z, texture.width, 0);
              vertex(strings.get(k+1).point.get(l+1).x,strings.get(k+1).point.get(l+1).y, strings.get(k+1).point.get(l+1).z, texture.width, texture.height);
              vertex(strings.get(k+1).point.get(l).x,strings.get(k+1).point.get(l).y, strings.get(k+1).point.get(l).z, 0, texture.height);
            }
           
            endShape();
            popMatrix();
            }
            
             
        
          
        
          }
        
        }
      }
  for(int i = 0; i < trail.size(); i++){
     drawTrail(trail.get(i));
     if (trail.get(i).lifeF <295 && !trail.get(i).isSmokeOn){
       trail.get(i).life = random(70, 100);
       trail.get(i).smoke = new PVector(trail.get(i).position.x+random(-5, 5), trail.get(i).position.y+random(-20, 0), trail.get(i).position.z);
       trail.get(i).isSmokeOn = true;
       float darken = random(50, 200);
       trail.get(i).smokeCol = color(darken, darken, darken);
       trail.get(i).col = color(255, random(180, 255), 0);
       trail.get(i).offSet = random(20);
         moveFire = false;

     } 
     if (trail.get(i).isMovingSmoke == true && trail.get(i).smokeLife < 3){
       trail.remove(i);
     } 
     if(i >= 0 && i < trail.size()){
       if (trail.get(i).isSmokeOn == true){
         firePhysics(trail.get(i));
         smokePhysics(trail.get(i));
         drawTrail(trail.get(i));
         if (removeTrail) {
           trail.get(i).life = 0;
           if(trail.get(i).smokeLife < 0){
             trail.remove(i);
             removeSmoke = true;
           }
         }
       }
     }

   }
  if(isBurning){
    lights();
    burnCounter++;
    createMovingSmoke++;
    burnCloth();
  } else {
    pushMatrix();
    fill(200,0,0);
    translate(ball.x, ball.y, ball.z);
    noStroke();
    sphere(ballRad);
    popMatrix();
  }
  
  String runtimeReport = "Size: "+str(numStrings-1)+ "x"+str(numPoints-1)+
        " FPS: "+ str(round(frameRate)) +"\n";
  surface.setTitle(projectTitle+ "  -  " +runtimeReport);


}

class Strings{
  ArrayList<PVector> point = new ArrayList();
  ArrayList<PVector> vel = new ArrayList();
  ArrayList<PVector> accel = new ArrayList();
  float[] projVel = new float[numPoints];
  ArrayList<PVector> force = new ArrayList();
  IntList neigbors;
  float anchorX;
  float anchorY;
  float anchorZ;

  
  Strings(){}
  
  void noValues(){
    for (int j = 0; j < numPoints; j++){
      anchorX = 0;
      anchorY = 0;
      anchorZ = 0;
      point.add(new PVector(0, 0, 0));
      vel.add(new PVector(0, 0));
      accel.add(new PVector(0, 0, 0));
      force.add(new PVector(0, 0, 0));
      projVel[j] = 0;
    }
  }
}


class Trail{
  PVector position;
  PVector smokePosition;
  PVector velocity;
  PVector smoke;
  float life;
  float lifeF;
  float smokeLife;
  boolean isSmokeOn;
  color col;
  color smokeCol;
  float offSet;
  int i;
  int j;
  int pos = 0;
  boolean isMovingSmoke;
  
  
  Trail(float x, float y, float z, PVector vel, int iIn, int jIn, boolean movingSmoke){
    position = new PVector(x, y, z);
    smokePosition = new PVector(x, y, z);
    velocity = new PVector(0, 0, 0); 
    isMovingSmoke = movingSmoke;
    if(movingSmoke){
      life = 0;
    } else {
      life = 300;
    }
    lifeF = 300;
    smokeLife = 300;
    isSmokeOn = false;
    col = color(255, random(180, 255), 0);
    i = iIn;
    j = jIn;
    velocity = new PVector(random(-20, 20), random(-20, -60), random(-10, 10));
  }
}
