float floor = 1000;
float grav = 500; //0
float radius = 7;
float restLen = 30;
float mass = 10;
float k = 3700; //1 1000
float kv = 60;
int numPoints = 20;
int numStrings = 600;
Camera camera;
int showSpheres = -1;
int addWind;
PVector ball = new PVector(-100, -100, -2000);
int ballRad = 500;
String projectTitle = "Cloth";
boolean setUpBall = false;
float zInc = 0;
float zMove = 0;
float xInc = 0;
float xMove = 0;



ArrayList<Strings> strings = new ArrayList();

void init(){
  camera = new Camera();
  showSpheres = -1;
  ball.x = 0; ball.y = 570; ball.z = 0;
  ballRad = 500;
  
  for (int i = 0; i < numStrings; i++){
    strings.add(new Strings());
  }
  for (int j = 0; j < numStrings; j++){
    float yposInc = 400;
    float angle = random(-360, 360);
    if((radians(angle) > -2) && (radians(angle) < .7*PI)){
    } else{
      while(!((radians(angle) > -2) && (radians(angle) < .7*PI))){
        angle = random(360);
      }
    }
    strings.get(j).anchorX = ballRad/1.8*cos(radians(angle));
    strings.get(j).anchorY = 145;
    strings.get(j).anchorZ = ballRad/1.8*sin(radians(angle));
    for(int i = 0; i < numPoints; i++){
      strings.get(j).point.add(new PVector(strings.get(j).anchorX, yposInc, strings.get(j).anchorZ));


      strings.get(j).vel.add(new PVector(random(-500, 500), random(-100, 100), random(-500, 500)));
      strings.get(j).accel.add(new PVector(0, 0, 0));
      strings.get(j).force.add(new PVector(0, 0, 0));
      strings.get(j).projVel[i] = 0;
      yposInc += 60;
      strings.get(j).heightOffset = random(0, 5);
    }
  }
}

void setup() {
  size(1500, 1500, P3D);
  frameRate(30);
    surface.setTitle("Strings");
  init();
  
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
          str.vel.get(i).x += (.5*str.force.get(i).x/mass)*dt+xMove;
          str.vel.get(i).z += (.5*str.force.get(i).z/mass)*dt+zMove;
          str.vel.get(i).y += (grav + (.5*str.force.get(i).y)/mass)*dt;
        } else {
          str.vel.get(i).x += ((.5*str.force.get(i).x - .5*str.force.get(i+1).x)/mass)*dt+xMove;
          str.vel.get(i).z += ((.5*str.force.get(i).z - .5*str.force.get(i+1).z)/mass)*dt+zMove;
          str.vel.get(i).y += (grav + (.5*str.force.get(i).y - .5*str.force.get(i+1).y)/mass)*dt;
          
        }

       
             
      str.point.get(i).x += str.vel.get(i).x*dt;
      str.point.get(i).y += str.vel.get(i).y*dt;
      str.point.get(i).z += str.vel.get(i).z*dt;
     }       
   }
   zMove = 0;
   xMove = 0;
}

void keyPressed()
{
  camera.HandleKeyPressed();
  if (keyPressed){
    if (key == ' ') {
      showSpheres*=-1;
    } 
    else if (key == 'c') {
      init();
    } 
    else if (key == 'u') {
      setUpBall = true;
    } 
    
   }
}
void sphereMovement(){
  if (key == 'f') {
    zInc +=20;
    zMove = -50;
  } else if (key == 'b') {
    zInc -= 20;
    zMove = 50;
  }
  if (key == 'g') {
    xInc +=20;
    xMove = -50;
  } else if (key == 'n') {
    xInc -= 20;
    xMove = 50;
  }
}

void keyReleased()
{
  camera.HandleKeyReleased();
}


void draw() {
  background(135,206,235);
  lights();
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
      stroke(200);
      //Place hair on sphere
      float distance = (strings.get(j).point.get(i)).dist(ball);
      if(distance < ballRad+radius+.9) {
       PVector dist = new PVector(strings.get(j).point.get(i).x - ball.x, strings.get(j).point.get(i).y - ball.y, strings.get(j).point.get(i).z - ball.z).normalize();
       strings.get(j).point.get(i).x = ball.x + dist.x*ballRad*1.01;
       strings.get(j).point.get(i).y = ball.y + dist.y*ballRad*1.01;
       strings.get(j).point.get(i).z = ball.z + dist.z*ballRad*1.01;
       
       strings.get(j).vel.get(i).x = 0 ;
       strings.get(j).vel.get(i).y = 0;
       strings.get(j).vel.get(i).z = 0;

      }
      strokeWeight(2);
      stroke(0, 0, 0);
      if(i == 0){
        line(strings.get(j).anchorX+xInc,strings.get(j).anchorY, strings.get(j).anchorZ+zInc, strings.get(j).point.get(i).x+xInc,strings.get(j).point.get(i).y, strings.get(j).point.get(i).z+zInc);
      } else if(i < numPoints - strings.get(j).heightOffset){
        line(strings.get(j).point.get(i-1).x+xInc,strings.get(j).point.get(i-1).y, strings.get(j).point.get(i-1).z+zInc, strings.get(j).point.get(i).x+xInc,strings.get(j).point.get(i).y, strings.get(j).point.get(i).z+zInc);
      } 

      //if (showSpheres == 1){
      //  translate(strings.get(j).point.get(i).x,strings.get(j).point.get(i).y, strings.get(j).point.get(i).z);
      //  noStroke();
      //  fill(0,200,10);
      //  sphere(radius);
      //}
      popMatrix();
    }
  }
  //Hair Collision
  for(int j = 0; j < numStrings-1; j++){
    for(int i = 0; i < numPoints; i++){
      float distance = (strings.get(j).point.get(i)).dist(strings.get(j+1).point.get(i));
      if(distance < radius+radius+.9) {
       PVector dist = new PVector(strings.get(j).point.get(i).x - strings.get(j+1).point.get(i).x, strings.get(j).point.get(i).y - strings.get(j+1).point.get(i).y, strings.get(j).point.get(i).z - strings.get(j+1).point.get(i).z).normalize();
       strings.get(j).point.get(i).x = strings.get(j+1).point.get(i).x + dist.x*radius*1.01;
       strings.get(j).point.get(i).y = strings.get(j+1).point.get(i).y + dist.y*radius*1.01;
       strings.get(j).point.get(i).z = strings.get(j+1).point.get(i).z + dist.z*radius*1.01;
       
       strings.get(j).vel.get(i).x = 0 ;
       strings.get(j).vel.get(i).y = 0;
       strings.get(j).vel.get(i).z = 0;
      }
    }
  }
  pushMatrix();
  fill(203,132,66);
  translate(ball.x+xInc, ball.y, ball.z+zInc);
  noStroke();
  sphere(ballRad);
  popMatrix();
  
  
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
  float heightOffset;

  
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
