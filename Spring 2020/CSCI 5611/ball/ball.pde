PVector ball1;  // ball1of shape
PVector velocity;  // Velocity of shape
PVector gravity;   // Gravity acts at the shape's acceleration
boolean drag1= false;
int radius1 = 70;


void setup() {
  size(1000,1000, P3D);
  ball1 = new PVector(100,100, 130);
  velocity = new PVector(4,4,4);
  gravity = new PVector(0,0.4, 0);

}

void drawScene() {
  background(0);
  lights();
  stroke(255);
  fill(0,200,10);
  
  //far side
  line(0, 0, -700, width, 0, -700);
  line(0, 0, -700, 0, height, -700);
  line(0, height, -700, width, height, -700);
  line(width, height, -700, width, 0, -700);
  
  //close side
  line(67, 931, 35, 931, 931, 35);
  line(67,69, 35, 931, 69, 35);
  line(931,69,35, 931, 931, 35);
  line(67,931, 35, 67, 69, 35);
  
  //Left Side
  line(0, 0, -700, 0, 0, -100);
  line(0, height, -700, 0, height, -100);
  
  //Right Side
  line(width, height, -700, width, height, -100);
  line(width, 0, -700, width, 0, -100);
  translate(ball1.x,ball1.y, -ball1.z); 
  sphere(radius1);
}

void computePhysics(float dt){
  ball1.x += velocity.x*dt;
  ball1.y += velocity.y*dt;
  ball1.z += velocity.z*dt;
  
  velocity.x += gravity.x*dt;
  velocity.y += gravity.y*dt;
  velocity.z += gravity.z*dt;

  
  // Bounce off edges
  if ((ball1.x + radius1 > width) || (ball1.x - radius1 < 0)) {
    velocity.x = velocity.x * -1;
    print("x: " + ball1.x + ", y: " + ball1.x + ", z: " + ball1.z + "\n");
  }
  if (ball1.y + radius1> height) {
    print("x: " + ball1.x + ", y: " + ball1.x + ", z: " + ball1.z + "\n");
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
      print(velocity.x +"\n");
      velocity.x *= .99;
      velocity.y *= .99;
      //Complete Stop
      if(abs(velocity.x) < .4) {
        velocity.x = 0;
        velocity.z = 0;
      }
  }
}

void draw() {
  computePhysics(.9);
  drawScene();

}
