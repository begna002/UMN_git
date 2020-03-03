Camera camera;
int nx;
float dx;
float g;
float dt;
float[] h;
float[] uh;
int counter = 0;
float totlen;
float[] hm;
float[] uhm;

void setup() {
  size(1000, 1000, P3D);
  frameRate(30);
    surface.setTitle("ShallowWater");
  
  nx = 10000;
  dx = 10;
  g = 5;
  dt = 0.002;
  h = new float[nx];
  uh = new float[nx];
  
  totlen = nx*dx;
  hm = new float[nx];
  uhm = new float[nx];
  surface.setTitle("Strings");
  camera = new Camera();
  
  for(int i = 0; i < nx; i++){
    h[i] = 300-i;
    uh[i] = 50;
    hm[i] = 300-i;
    uhm[i] = 50;
  }
  
}


void update(float dt){
   for(int i = 0; i < nx-1; i++){
     if(counter >= 0 && counter <= 100){                  println(h[i] + " one " + i + " " + uh[i]);
} counter++;
     hm[i] = (h[i]+h[i+1])/2.0 -(dt/2.0)*(uh[i+1]-uh[i])/dx;
     uhm[i] = (uh[i]+uh[i+1])/2.0 -(dt/2.0)*(sqrt(uh[i+1])/h[i+1] + .5*g*sqrt(h[i+1]) - sqrt(uh[i])/h[i] -.5*g*sqrt(h[i]))/dx; //<>//
   }
   float damp = .1;
   for(int i = 0; i < nx-2; i++){
     h[i+1] -= dt*(uhm[i+1]-uhm[i])/dx;
        
     uh[i+1] -= dt*(damp+uh[i+1] + sqrt(uhm[i+1])/hm[i+1] + .5*g*sqrt(hm[i+1]) -sqrt(uhm[i])/hm[i] -.5*g*sqrt(hm[i]))/dx;
   if(counter >= 0 && counter <= 100){                  println(uh[i] + " two " + i + " " + uhm[i] + " " + hm[i]);
} counter++;
 }
   h[0] = h[1];
   h[h.length - 1] = h[h.length - 2];
   uh[0] = -uh[1];
   uh[h.length-1] = -uh[h.length - 2];
   

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
  for (int i = 0; i < 10; i++){
        update(dt);
  }
  int xOffset = -5000;
  int zOffset = 5000;
    camera.Update( 1.0/frameRate );
  for (int i = 0; i < 100; i++){
    for (int j = 0; j < 100; j++){
       stroke(255, 255, 255);
       strokeWeight(5);
       point(xOffset, 0, zOffset);
       zOffset -= 100; 
       if( i == 50 & j == 50){
         //PFont mono = createFont("andalemo.ttf", 10);
        //textFont(mono);
         text("Z", xOffset, 0, zOffset);
       }
    }
    zOffset = 5000;
    xOffset += 100;
  }

  
  for(int i = 0; i < nx-1; i++){
    float x1 = 10 + i*dx;
    float x2 = 10 +(i+1)*dx;
    PVector v1 = new PVector(x2-x1, h[i+1]-h[i], 0);
    PVector v2 = new PVector(x1-x1, h[i]-h[i], -1);
    PVector n = v1.cross(v2);
    
    pushMatrix();
    beginShape(QUADS);
    noStroke();
    fill(255, 255, 255);
    normal(n.x, n.y, n.z);
    vertex(x1,h[i],0);
    vertex(x2,h[i+1],0);
    vertex(x2,h[i+1],-1000);
    vertex(x1,h[i],-1000);
    endShape();
    popMatrix();
   
  }
}
