Obstacle obstacle;
Robot robot;

float robotRad;
float obstacleRad;
float endX;
float endY;
float endRad;

void init(){
  endX = 800;
  endY = 600;
  PVector robPos = new PVector(200, 800);
  PVector endGoal = new PVector(endX, endY);
  robot = new Robot(robPos, endGoal);
  obstacle = new Obstacle(600, 600);

  robotRad = 50;
  endRad = 70;
  obstacleRad = 200;
}
void setup() {
  size(1000,1000);
  init();
}

void drawScene() {
  background(173, 216, 230);

  
  beginShape();
  fill(200,0,0);
  ellipse(obstacle.position.x, obstacle.position.y, obstacleRad, obstacleRad);
  endShape(CLOSE);
  
  beginShape();
  fill(0,200,0);
  ellipse(endX, endY, endRad, endRad);
  endShape(CLOSE);
  
  beginShape();
  fill(255,255,255);
  ellipse(robot.position.x, robot.position.y, robotRad, robotRad);
  endShape(CLOSE);
}

void computePhysics(float dt){
  
  if(robot.position.x - endX < 3 && robot.position.y - endY < 3){
    robot.position.x = endX;
    robot.position.y = endY;
    
    //robot.trajectory.x = 0;
    //robot.trajectory.y = 0;
  } else {
    robot.updateTrajectory();
    robot.position.x -= robot.trajectory.x*dt;
    robot.position.y -= robot.trajectory.y*dt;
  }
  
}

void keyPressed(){
   if (keyPressed){
    if (key == ' ') {
      init();
    } 
   }
}

void draw() {

  computePhysics(.9);
  
   float distance = (robot.position).dist(obstacle.position);
   println(distance);
     if(distance < (robotRad+obstacleRad)/2 +1.5) {
       PVector dist = new PVector(robot.position.x - obstacle.position.x, robot.position.y - obstacle.position.y).normalize();
       robot.position.x  = obstacle.position.x + dist.x*(obstacleRad/2)*1.3;
       robot.position.y  = obstacle.position.y + dist.y*(obstacleRad/2)*1.3;
     }
  
  drawScene();
}

class Obstacle{
  PVector position;
  
  Obstacle(float x, float y){
      position = new PVector(x, y);
  }
}

class Robot{
  PVector position;
  PVector endGoal;
  PVector trajectory;
  
  Robot(PVector pos, PVector end){
      position = pos;
      endGoal = end;
      float xVel = end.x - pos.x;
      float yVel = end.y - pos.y;
      float simpl = min(xVel, yVel);
      trajectory = new PVector(xVel/simpl, yVel/simpl);
  }
  
  void updateTrajectory(){
    float xVel = endGoal.x - position.x;
    float yVel = endGoal.y - position.y;
    float simpl = min(xVel, yVel);
    trajectory.x = xVel/simpl;
    trajectory.y = yVel/simpl;

  }
}
