PVector ball1;  // Shape
PVector velocity;  // Velocity of shape
PVector gravity;   // Gravity acts as the shape's acceleration
boolean drag1= false; //Flag for when ball is rolling
int radius1 = 70;
float zoom = 0; //Zoom magnitude
float translateX = 0; 
float translateY = 0;
int rot=0;

void setup() {
  size(1000,1000, P3D);
  ball1 = new PVector(100,100, 130);
  velocity = new PVector(7,7,7);
  gravity = new PVector(0,0.4, 0);
}

void drawScene() {
  background(173, 216, 230);
  
  float x = (width/2)*cos(rot*.0174);
  float z = (width/2)*sin(rot*.0174);
  camera(x, height/2, z, width/2, height/2, 0, 0 ,1, 0);
  lights();
  stroke(255);
  fill(220,220,220);
  
  
  
  //bottom
  beginShape();
  vertex(0+translateX, height+translateY, -100+zoom);
  vertex(width+translateX, height+translateY, -100+zoom);
  vertex(width+translateX, height+translateY, -700+zoom);
  vertex(0+translateX, height+translateY, -700+zoom);
  endShape(CLOSE);
  
  //left
  beginShape();
  vertex(0+translateX, height+translateY, -100+zoom);
  vertex(0+translateX, 0+translateY, -100+zoom);
  vertex(0+translateX, 0+translateY, -700+zoom);
  vertex(0+translateX, height+translateY, -700+zoom);
  endShape(CLOSE);
  
  //back
  beginShape();
  vertex(0+translateX, 0+translateY, -700+zoom);
  vertex(width+translateX, 0+translateY, -700+zoom);
  vertex(width+translateX, height+translateY, -700+zoom);
  vertex(0+translateX, height+translateY, -700+zoom);
  endShape(CLOSE);
  
  //right
  beginShape();
  vertex(width+translateX, 0+translateY, -100+zoom);
  vertex(width+translateX, 0+translateY, -700+zoom);
  vertex(width+translateX, height+translateY, -700+zoom);
  vertex(width+translateX, height+translateY, -100+zoom);
  endShape(CLOSE);  

  noStroke();
  fill(0,200,10);
 
  translate(ball1.x+translateX,ball1.y+translateY, -ball1.z+zoom); 
  sphere(radius1);
}

void computePhysics(float dt){
  //Update Postion
  ball1.x += velocity.x*dt;
  ball1.y += velocity.y*dt;
  ball1.z += velocity.z*dt;
  
  //Update Velocity
  velocity.x += gravity.x*dt;
  velocity.y += gravity.y*dt;
  velocity.z += gravity.z*dt;

  // Bounce off edges
  if ((ball1.x + radius1 > width) || (ball1.x - radius1 < 0)) {
    velocity.x = velocity.x * -1;
  }
  if (ball1.y + radius1> height) {
    velocity.y = velocity.y * -0.85; 
    ball1.y = height - radius1;
    //At a certain point, start rolling
    if(abs(velocity.y) < 3.8) {
      velocity.y = 0;
      drag1 = true;
    }
  }
  if(ball1.z < 100 || ball1.z > 700 ) {
    velocity.z*=-1;
  }
  //Drag
  if (drag1 == true){
      velocity.x *= .99;
      velocity.z *= .99;
      //Complete Stop
      if(abs(velocity.x) < .2) {
        velocity.x = 0;
        velocity.z = 0;
      }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      zoom += 5;
    } else if (keyCode == DOWN) {
      zoom -=5;
    } 
    if (keyCode == LEFT) {
      rot += 1;
    } else if (keyCode == RIGHT) {
      rot -=1;
    } 
  } else if (keyPressed) {
      if (key == 'a') {
      translateX -= 5;
      } else if (key == 'd') {
        translateX += 5;
      } else if (key == 's') {
         translateY += 5;
      } 
      else if (key == 'w') {
         translateY -= 5;
      } 
  }
}

void draw() {
  if(keyPressed) {
      keyPressed();
  }
  
  computePhysics(.9);
  
  drawScene();
}
