
float floor = 1000;
float grav = 500; //0
float radius = 7;
float restLen = 40;
float mass = 10;
float k = 1000; //1 1000
float kv = 50;
int numPoints = 10;
int numStrings = 10;
Camera camera;


ArrayList<Strings> strings = new ArrayList();


void setup() {
  size(1500, 1500, P3D);
  camera = new Camera();
  
  surface.setTitle("Strings");
  float stringX = -400;
  float windX = 0;
  float windZ = 0;
  for (int i = 0; i < numStrings; i++){
    strings.add(new Strings());
  }
  for (int j = 0; j < numStrings; j++){
    float yposInc = 200;
    strings.get(j).anchorX = stringX;
    strings.get(j).anchorY = 100;
    strings.get(j).anchorZ = 0;
    for(int i = 0; i < numPoints; i++){
      strings.get(j).point.add(new PVector(strings.get(j).anchorX, yposInc, 0));
      strings.get(j).vel.add(new PVector(50+windX, 0, 50+windZ));
      strings.get(j).accel.add(new PVector(0, 0, 0));
      strings.get(j).force.add(new PVector(0, 0, 0));
      strings.get(j).projVel[i] = 0;
      yposInc += 50;
    }
    stringX += 100;
    windX+=5;
    windZ+=5;
  }
}

void update(float dt){
  //for (int i = 0; i < numPoints; i++){
  //  str.accel.get(i).x = 0;
  //  str.accel.get(i).y = 0;
  //}
  //for (int i = 0; i < numPoints - 1; i++){
  //  float sx, sy, ax, ay, stringLen, dampF;
  //    sx = (str.point.get(i+1).x - str.point.get(i).x);
  //    sy = (str.point.get(i+1).y - str.point.get(i).y);
  //    stringLen = sqrt(sx*sx + sy*sy);
  //    float stringF = (k/restLen)*(stringLen-restLen);
      
  //    float dirX = sx/stringLen;
  //    float dirY = sy/stringLen;
      
            
  //    ax = dirX * stringF;
  //    ay = dirY * stringF;
  //    ax += kv*(str.vel.get(i+1).x - str.vel.get(i).x );
  //    ay += kv*(str.vel.get(i+1).x  - str.vel.get(i).y);
  //    str.accel.get(i).x += ax/2;
  //    str.accel.get(i).y += ay/2;
  //    str.accel.get(i+1).x += -ax/2;
  //    str.accel.get(i+1).y += -ay/2;
  //}
  //for (int i = 0; i < numPoints; i++){
  //  str.vel.get(i).x += str.accel.get(i).x*dt;
  //  str.vel.get(i).y += str.accel.get(i).y*dt;
  //  str.point.get(i).x += str.vel.get(i).x*dt;
  //  str.point.get(i).y += str.vel.get(i).y*dt;
  //}
  
   for (int j = 0; j < numStrings; j++){
     Strings str = strings.get(j);
     Strings neighbor = new Strings();
     for (int i = 0; i < numPoints; i ++){ 
      float sx, sy, sz, stringLen, dampF;
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
        if (i == 0){
          dampF = -kv*(str.projVel[i] - 0);
        } else {
          dampF = -kv*(str.projVel[i] + str.projVel[i-1]);
        }
        
        str.force.get(i).x = (stringF+dampF)*dirX;
        str.force.get(i).y = (stringF+dampF)*dirY;
        str.force.get(i).z = (stringF+dampF)*dirZ;
        if(i == numPoints - 1){//last point
          str.vel.get(i).x += (.5*str.force.get(i).x/mass)*dt;
          str.vel.get(i).z += (.5*str.force.get(i).z/mass)*dt;
          str.vel.get(i).y += (grav + (.5*str.force.get(i).y)/mass)*dt;
        } else {
          str.vel.get(i).x += ((.5*str.force.get(i).x - .5*str.force.get(i+1).x)/mass)*dt;
          str.vel.get(i).z += ((.5*str.force.get(i).z - .5*str.force.get(i+1).z)/mass)*dt;
          str.vel.get(i).y += (grav + (.5*str.force.get(i).y - .5*str.force.get(i+1).y)/mass)*dt;
        }
  
        
        str.point.get(i).x += str.vel.get(i).x*dt;
        str.point.get(i).y += str.vel.get(i).y*dt;
        str.point.get(i).z += str.vel.get(i).z*dt;
         //if (str.point.get(i).y+radius > floor){
         //  str.vel.get(i).y *= -.9;
         //  str.point.get(i).y = floor - radius;
         //}
     }       
   }
}

void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();
}


void draw() {
  background(0,0,0);
  lights();
  camera.Update( 1.0/frameRate );
  for (int i = 0; i < 10; i++){
    update(1/(10.0*frameRate));
  }
  for(int j = 0; j < numStrings; j++){
    for(int i = 0; i < numPoints; i++){
      pushMatrix();
      fill(255,255,255);
      stroke(200);
      if(i == 0){
        line(strings.get(j).anchorX,strings.get(j).anchorY, strings.get(j).anchorZ, strings.get(j).point.get(i).x,strings.get(j).point.get(i).y, strings.get(j).point.get(i).z);
      } else {
        line(strings.get(j).point.get(i-1).x,strings.get(j).point.get(i-1).y, strings.get(j).point.get(i-1).z, strings.get(j).point.get(i).x,strings.get(j).point.get(i).y, strings.get(j).point.get(i).z);
      }
      translate(strings.get(j).point.get(i).x,strings.get(j).point.get(i).y, strings.get(j).point.get(i).z);
      noStroke();
      fill(0,200,10);
      sphere(radius);
      popMatrix();
    }
  }
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
}
