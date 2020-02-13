//Triple Spring (damped) - 1D Motion
//CSCI 5611 Thread Sample Code
// Stephen J. Guy <sjguy@umn.edu>

//Create Window
void setup() {
  size(400, 500, P3D);
  surface.setTitle("Ball on Spring!");
}

//Simulation Parameters
float floor = 500;
float gravity = 10;
float radius = 10;
float stringTop = 50;
float restLen = 40;
float mass = 30; //TRY-IT: How does changing mass affect resting length?
float k = .5; //TRY-IT: How does changing k affect resting length?
float kv = 20;

//Inital positions and velocities of masses
float ballY1 = 200;
float ballX1 = 200;
float velY1 = 0;
float velX1 = 0;
float ballY2 = 250;
float ballX2 = 200;
float velY2 = 0;
float velX2 = 0;
float ballY3 = 300;
float ballX3 = 200;
float velY3 = 0;
float velX3 = 0;


void update(float dt){
  //Compute (damped) Hooke's law for each spring
  float sx1 = ballY1 - stringTop;
  float sy1 = ballX1 - 200;
  float stringLen1 = sqrt(sx1*sx1 + sy1*sy1);
  float stringF1 = -k*(stringLen1 - restLen);
  float dirX1 = sx1/stringLen1;
  float dirY1 = sy1/stringLen1;
  float dampFX1 = -kv*(velX1 - 0);
  float dampFY1 = -kv*(velY1 - 0);
  float forceY1 = stringF1 + dampFY1;
  float forceX1 = stringF1 + dampFX1;

  
  float sx2 = ballY2 - ballY1;
  float sy2 = ballX2 - ballX1;
  float stringLen2 = sqrt(sx2*sx2 + sy2*sy2);
  float stringF2 = -k*(stringLen2 - restLen);
  float dirX2 = sx2/stringLen2;
  float dirY2 = sy2/stringLen2;
  float dampFX2 = -kv*(velX2 - velX1);
  float dampFY2 = -kv*(velY2 - velY1);
    float forceY2 = stringF2 + dampFY2;
  float forceX2 = stringF2 + dampFX2;
  
  float sx3 = ballY3 - ballY2;
  float sy3 = ballX3 - ballX2;
  float stringLen3 = sqrt(sx3*sx3 + sy3*sy3);
  float stringF3 = -k*(stringLen3 - restLen);
  float dirX3 = sx3/stringLen3;
  float dirY3 = sy2/stringLen3;
  float dampFX3 = -kv*(velX3 - velX2);
  float dampFY3 = -kv*(velY3 - velY2);
    float forceY3 = stringF3 + dampFY3;
  float forceX3 = stringF3 + dampFX3;
    

 
  //If are are doing this right, the top spring should be much longer than the bottom
  println("l1:",ballY1 - stringTop, " l2:",ballY2 - ballY1, " l3:",ballY3-ballY2);
  
  //Eulerian integration
  velY1 += gravity + dt*forceY1*dirY1/mass - dt*forceY2*dirY2/mass;
  velX1 += dt*forceX1*dirX1/mass - dt*forceX2*dirX2/mass;
  ballX1 += velX1*dt;
  ballY1 += velY1*dt;
 
   velY2 += gravity + dt*forceY2*dirY2/mass - dt*forceY3*dirY3/mass;
  velX2 += dt*forceX2*dirX2/mass - dt*forceX3*dirX3/mass;
  ballX2 += velX2*dt;
  ballY2 += velY2*dt;
  
  velY3 += gravity + dt*forceY3*dirY3/mass;
  velX3 += dt*forceX3*dirX3/mass;
  ballX3 += velX3*dt;
  ballY3 += velY3*dt;
  
  //Collision detection and response
  if (ballY1+radius > floor){
    velY1 *= -.9;
    ballY1 = floor - radius;
  }
  if (ballY2+radius > floor){
    velY2 *= -.9;
    ballY2 = floor - radius;
  }
  if (ballY3+radius > floor){
    velY3 *= -.9;
    ballY3 = floor - radius;
  }
}

//Draw the scene: one sphere per mass, one line connecting each pair
void draw() {
  background(255,255,255);
  update(.5); //We're using a fixed, large dt -- this is a bad idea!!
  fill(0,0,0);
  
  pushMatrix();
  line(200,stringTop,200,ballY1);
  translate(ballX1,ballY1);
  sphere(radius);
  popMatrix();
  
  pushMatrix();
  line(200,stringTop,200,ballY2);
  translate(ballX2,ballY2);
  sphere(radius);
  popMatrix();
  
  pushMatrix();
  line(200,stringTop,200,ballY3);
  translate(ballX3,ballY3);
  sphere(radius);
  popMatrix();
}
