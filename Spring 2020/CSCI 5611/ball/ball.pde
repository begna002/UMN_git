PVector ball1;  // ball1of shape
PVector ball2;  // ball1of shape
PVector velocity;  // Velocity of shape
PVector velocity2;  // Velocity of shape
PVector gravity;   // Gravity acts at the shape's acceleration
boolean drag1= false;
boolean drag2= false;
int radius1 = 70;
int radius2 = 140;


void setup() {
  size(1280,720);
  ball1 = new PVector(100,300);
  ball2= new PVector(1000,50);
  velocity = new PVector(1.5,2.1);
  velocity2 = new PVector(-1.5,2.1);
  gravity = new PVector(0,0.2);

}

void drawScene() {
  // Display circle at ball1vector
  noStroke();
  fill(0,200,10);
  ellipse(ball1.x,ball1.y,radius1,radius1);
  ellipse(ball2.x,ball2.y,radius2,radius2);
}

void draw() {
  background(0);
  
  // Add velocity to the ball1.
  ball1.x += velocity.x;
  ball1.y += velocity.y;
  ball2.x += velocity2.x;
  ball2.y += velocity2.y;
  
  velocity.x += gravity.x;
  velocity.y += gravity.y;
  velocity2.x += gravity.x;
  velocity2.y += gravity.y;

  
  // Bounce off edges
  if ((ball1.x + radius1/2 > width) || (ball1.x - radius1/2 < 0)) {
    velocity.x = velocity.x * -1;
  }
  if ((ball2.x + radius2/2 > width) || (ball2.x + radius2/2 < 0)) {
    velocity2.x = velocity2.x * -1;
  }
  if (ball1.y + radius1/2> height) {
    // We're reducing velocity ever so slightly 
    // when it hits the bottom of the window
    velocity.y = velocity.y * -0.85; 
    ball1.y = height - 35;
    //At a certain point, start rolling
    if(abs(velocity.y) < 2.1) {
      velocity.y = 0;
      drag1 = true;
    }
  }
  if (ball2.y + radius2/2> height) {
    // We're reducing velocity ever so slightly 
    // when it hits the bottom of the window
    velocity2.y = velocity2.y * -0.85; 
    ball2.y = height - radius1;
    //At a certain point, start rolling
    if(abs(velocity2.y) < 2.2) {
      velocity2.y = 0;
      drag2 = true;
    }
  }
  //Drag
  if (drag1 == true){
      velocity.x *= .99;
      //Complete Stop
      if(abs(velocity.x) < .4) {
        velocity.x = 0;
      }
  }
  if (drag2 == true){
    velocity2.x *= .99;
     //Complete Stop
    if(abs(velocity2.x) < .4) {
        velocity2.x = 0;
      }
  }
   
  //Ball Collission
  if (dist(ball1.x, ball1.y, ball2.x, ball2.y) < radius1/2 + radius2/2) {
    float tempx = velocity.x;
    float tempy = velocity.y;
    velocity.x = velocity2.x;
    velocity.y = velocity2.y;
    velocity2.x = tempx;
    velocity2.y = tempy;
  }
  
  drawScene();

}
