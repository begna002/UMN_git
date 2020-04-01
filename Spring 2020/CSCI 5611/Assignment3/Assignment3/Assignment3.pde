ArrayList<Boid> flock;
int numBoids;
float r;
int numFlocks;
float maxVelocity;
float neighbordist;
ArrayList<PVector> flockPos;
ArrayList<PVector> flockGoals;
private static final int NO_PARENT = -1; 
float dt = .99;


ArrayList<Obstacle> obstacles;
int numObstacles;
float obstacleRad;


class Obstacle{
  PVector position;
  float radius;
  
  Obstacle(float x, float y){
      position = new PVector(x, y);
      radius = obstacleRad;
  }
}

PVector createGoal(PVector start){
  float x = random(0 + r, width - r);
  float y = random(0 + r, height - r);
  PVector goal = new PVector(x, y);
  //Don't inizitalize goal on an obstacle
  float distanceToObst1 = (goal).dist(obstacles.get(0).position);
  float distanceToObst2 = (goal).dist(obstacles.get(1).position);
  float distanceToObst3 = (goal).dist(obstacles.get(2).position);
  float distanceToObst4 = (goal).dist(obstacles.get(3).position);
  float distanceToGoal = (goal).dist(start);

  //randomize points until they don't collide with obstacle
  while(distanceToObst1 < r + obstacleRad && distanceToObst2 < r + obstacleRad && distanceToObst3 < r + obstacleRad && distanceToObst4 < r + obstacleRad && distanceToGoal > 500) {
    x = random(0 + r, width - r);
    y = random(0 + r, height - r);
    goal = new PVector(x, y);
    
    distanceToObst1 = (goal).dist(obstacles.get(0).position);
    distanceToObst2 = (goal).dist(obstacles.get(1).position);
    distanceToObst3 = (goal).dist(obstacles.get(2).position);
    distanceToObst4 = (goal).dist(obstacles.get(3).position);
    distanceToGoal = (goal).dist(start);  
  }
  return goal;
}

void init(){
  numBoids = 300;
  numFlocks = 4;
  numObstacles = 5;
  r = 7;
  obstacleRad = 100;
  maxVelocity = 4;
  neighbordist = 70;
  flockPos = new ArrayList();
  flockGoals = new ArrayList();
  obstacles = new ArrayList();
  
  for(int i = 0; i < numObstacles; i++){
    obstacles.add(new Obstacle(random(0 + obstacleRad, width - obstacleRad), random(0 + obstacleRad, height - obstacleRad)));
  }
  
  //Randomize position of flocks
  for(int i = 0; i < numFlocks; i++){
    float x = random(0 + r, width - r);
    float y = random(0 + r, height - r);
    PVector pos = new PVector(x, y);
    //Don't inizitalize flock on an obstacle
    float distanceToObst1 = (pos).dist(obstacles.get(0).position);
    float distanceToObst2 = (pos).dist(obstacles.get(1).position);
    float distanceToObst3 = (pos).dist(obstacles.get(2).position);
    float distanceToObst4 = (pos).dist(obstacles.get(3).position);

    //randomize points until they don't collide with obstacle
    while(distanceToObst1 < r + obstacleRad && distanceToObst2 < r + obstacleRad && distanceToObst3 < r + obstacleRad && distanceToObst4 < r + obstacleRad) {
      x = random(0 + r, width - r);
      y = random(0 + r, height - r);
      pos = new PVector(x, y);
      
      distanceToObst1 = (pos).dist(obstacles.get(0).position);
      distanceToObst2 = (pos).dist(obstacles.get(1).position);
      distanceToObst3 = (pos).dist(obstacles.get(2).position);
      distanceToObst4 = (pos).dist(obstacles.get(3).position);
      
    }
    flockPos.add(pos);
    flockGoals.add(createGoal(pos));
  }
  flock = new ArrayList();
  // Add boid to a random flock
  for (int i = 0; i < numBoids; i++) {
    int ind = floor(random(0, numFlocks));
    flock.add(new Boid(flockPos.get(ind).x,flockPos.get(ind).y, new PVector(0, 255, 0), ind, flockGoals.get(ind)));
  }
}
void setup() {
  size(1280, 1280);
  init();
}

void draw() {
  background(0, 0, 0);
  //for(int i = 0; i < numObstacles; i++){
  //  beginShape();
  //  fill(255,255,255);
  //  noStroke();
  //  circle(obstacles.get(i).position.x, obstacles.get(i).position.y, obstacles.get(i).radius);
  //  endShape(CLOSE);
  //}
  //for(int i = 0; i < flockGoals.size(); i++){
  //  beginShape();
  //  fill(255,255,255);
  //  noStroke();
  //  circle(flockGoals.get(i).x, flockGoals.get(i).y, 10);
  //  endShape(CLOSE);
  //}

  for(int i = 0; i < flock.size(); i++){
    try{
      flock.get(i).update(flock, dt);
    } catch(Exception e){
      init();
    }

  }
}

void keyPressed(){
   if (keyPressed){
    if (key == ' ') {
      init();
    } 
   }
}




class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector endGoal;
  float maxforce;    
  PVector colVals;
  color col;
  int flockId;
  float robotX;
  float robotY;
  float nextX;
  float nextY;
  int currentInd;
  float Speed;
  float mileStoneRad;
  ArrayList<PVector> mileStones;
  ArrayList<MileStone> mileStoneObjs;
  float neighborLimit = 4;
  int numVertices = 10;
  ArrayList<PVector> startEnd;
  int[][] adjacencyMatrix = new int[numVertices][numVertices];
  private static final int NO_PARENT = -1; 
  ArrayList<PVector> finalPath;

  //Skelaton of class derived from https://www.processing.org/examples/flocking.html (Daniel Shiffman)
  Boid(float x, float y, PVector c, int id, PVector end) {
    colVals = c;
    col = color(colVals.x, colVals.y, colVals.z);
    acceleration = new PVector(0, 0);
    flockId = id;
    endGoal = end;

    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    position = new PVector(x, y);
    maxforce = 0.03;
    //currentInd = 1;
    robotX = x;
    robotY = y;
    
    mileStoneObjs = new ArrayList();
    finalPath = new ArrayList();
    
    
    for(int i = 0; i < numVertices; i ++){
      for(int j = 0; j < numVertices; j ++){
        adjacencyMatrix[i][j] = 0;
      }
    }
    mileStoneRad = 10;
    obstacleRad = 100;
    mileStones();
    for(int i = 0; i < mileStones.size(); i++){
      mileStoneObjs.add(new MileStone(mileStones.get(i), i+1));
    }
    findNeighbors();
    makeMatrix();
    dijkstra(adjacencyMatrix, 0);
    int ind = floor(finalPath.get(currentInd).x);
    for(int i = 0; i < mileStoneObjs.size(); i++){
      if(ind == mileStoneObjs.get(i).id){
        nextX = mileStoneObjs.get(i).position.x;
        nextY = mileStoneObjs.get(i).position.y;
        PVector goal = new PVector(nextX, nextY);
        endGoal = goal;
        break;
      }
    }
  }
  
  void computePhysics(float dt){
    if(abs(position.x - nextX) < 5 && abs(position.y - nextY) < 5){
      if (currentInd+1 > finalPath.size()-1){//Robot is 1 milestone away from end
        nextX = endGoal.x;
        nextY = endGoal.y;
        
        PVector nextGoal = new PVector(nextX, nextY);
        endGoal = nextGoal;
        flockGoals.set(flockId, endGoal);
      } else {//Robot is going to next milestone
        currentInd+=1;
        int ind = floor(finalPath.get(currentInd).x);
        for(int i = 0; i < mileStoneObjs.size(); i++){
          if(ind == mileStoneObjs.get(i).id){
            nextX = mileStoneObjs.get(i).position.x;
            nextY = mileStoneObjs.get(i).position.y;
            PVector nextGoal = new PVector(nextX, nextY);
            endGoal = nextGoal;
            println("here");
            flockGoals.set(flockId, endGoal);
            break;
          }
        }
      }
      
      //robot.trajectory.x = 0;
      //robot.trajectory.y = 0;
    }
    else {
      updateTrajectory();
      //robot.position.x -= robot.trajectory.x*dt;
      //robot.position.y -= robot.trajectory.y*dt;
    }
    if(abs(position.x - endGoal.x) < 3 && abs(position.y - endGoal.y) < 3){
       Speed = 0;
    }
  }
  
  void makeMatrix(){
    for(int i = 0; i < mileStoneObjs.size(); i++){
      for(int j = 0; j < mileStoneObjs.get(i).neighbors.size();j++){
        int id = mileStoneObjs.get(i).neighbors.get(j).id;
        if(id != 1000 && id != -1000){
           adjacencyMatrix[i+1][id] = floor(mileStoneObjs.get(i).distToNeighbors.get(j));
        } 
      }
    }
    for(int i = 0; i < mileStoneObjs.size(); i++){
      if(mileStoneObjs.get(i).Start.size() != 0){
        int id = mileStoneObjs.get(i).Start.get(0).id;
        adjacencyMatrix[i+1][id] = floor(mileStoneObjs.get(i).distToStart);
      }
      if(mileStoneObjs.get(i).End.size() != 0){
        int id = mileStoneObjs.get(i).End.get(0).id;
        adjacencyMatrix[i+1][id] = floor(mileStoneObjs.get(i).distToEnd);
      }
    }
    for(int i = 0; i < numVertices; i++){
      if (adjacencyMatrix[i][0] != 0){
        adjacencyMatrix[0][i] = adjacencyMatrix[i][0];
      }
      //if (adjacencyMatrix[i][numVertices-1] != 0){
      //  adjacencyMatrix[numVertices-1][i] = adjacencyMatrix[i][numVertices-1];
      //}
    }
  }

  boolean checkIntersections(MileStone e, MileStone s){
    //https://forum.processing.org/one/topic/2d-intersection-between-lines-and-circle-how-to.html by User tfguy44
    float dx = e.position.x - s.position.x; 
    float dy = e.position.y - s.position.y;
    float a = dx*dx + dy*dy;
    float b = 2 * (dx * (s.position.x - 1000) + dy * (s.position.y - 1000));
    float c = (1000*1000)*2;
    c += s.position.x*s.position.x + s.position.y * s.position.y;
    c -= 2*(1000*s.position.x+1000*s.position.y);
    c -= (obstacleRad/2)*(obstacleRad/2);
    float delt = b*b-4*a*c;
    
    
    if(delt >= 0){
      return false;
    }
    
   
    
    
    return true;
  
  }
  void findNeighbors(){
  float distFromStart = 10000;
  float distToEnd = 10000;
  PVector Start = new PVector(robotX, robotY);
  PVector End = new PVector(endGoal.x, endGoal.y);
  int startInd = 0;
  int endInd = 0;
  for(int i = 0; i < mileStoneObjs.size(); i++){
    for(int j = 0; j < mileStoneObjs.size(); j++){
      //float dist = 100000;
      //int neighborInd = 0;
      if(i != j){//don't check itself
        float distanceToMilestone = (mileStoneObjs.get(i).position).dist(mileStoneObjs.get(j).position);
        //if (distanceToMilestone < dist){
        //  dist = distanceToMilestone;
        //  neighborInd = j;
        //}
        if(distanceToMilestone <= 700 & mileStoneObjs.get(i).neighbors.size() <= neighborLimit && checkIntersections(mileStoneObjs.get(j), mileStoneObjs.get(i))){
          if(mileStoneObjs.get(j).neighbors.size() <= neighborLimit){
            mileStoneObjs.get(i).neighbors.add(mileStoneObjs.get(j));
            mileStoneObjs.get(i).distToNeighbors.add(distanceToMilestone);
          }
          
        }
      }
      //if(!found){
      //  mileStoneObjs.get(i).neighbors.add(mileStoneObjs.get(neighborInd));
      //  mileStoneObjs.get(i).distToNeighbors.add(dist);
      //}
    }
    
    float distStart = (mileStoneObjs.get(i).position).dist(Start);
    float distEnd = (mileStoneObjs.get(i).position).dist(End);
    
    if(distStart < distFromStart){
      distFromStart = distStart;
      startInd = i;
    }
    if(distEnd < distToEnd){
      distToEnd = distEnd;
      endInd = i;
    }
    
  }
   mileStoneObjs.get(startInd).neighbors.add(new MileStone(Start, -1000));
   mileStoneObjs.get(startInd).Start.add(new MileStone(Start, 0));
   mileStoneObjs.get(startInd).distToNeighbors.add(distFromStart);
   mileStoneObjs.get(startInd).distToStart = distFromStart;
   
   mileStoneObjs.get(endInd).neighbors.add(new MileStone(End, 1000));
   mileStoneObjs.get(endInd).End.add(new MileStone(End, numVertices-1));
   mileStoneObjs.get(endInd).distToNeighbors.add(distToEnd);
   mileStoneObjs.get(endInd).distToEnd = distToEnd;
  }
  
  void mileStones(){
    //Don't inizitalize goal on an obstacle

  
    //randomize points until they don't collide with obstacle

    
    mileStones = new ArrayList();
    for(int i = 1; i < numVertices-1; i++){
      PVector goal = new PVector(random(0 + r, width - r),random(0 + r, height - r));
      float distanceToObst1 = (goal).dist(obstacles.get(0).position);
      float distanceToObst2 = (goal).dist(obstacles.get(1).position);
      float distanceToObst3 = (goal).dist(obstacles.get(2).position);
      float distanceToObst4 = (goal).dist(obstacles.get(3).position);
      //randomize points until they don't collide with obstacle
       while(distanceToObst1 < r + obstacleRad && distanceToObst2 < r + obstacleRad && distanceToObst3 < r + obstacleRad && distanceToObst4 < r) {
         goal = new PVector(random(0 + r, width - r), random(0 + r, height - r));
          
          distanceToObst1 = (goal).dist(obstacles.get(0).position);
          distanceToObst2 = (goal).dist(obstacles.get(1).position);
          distanceToObst3 = (goal).dist(obstacles.get(2).position);
          distanceToObst4 = (goal).dist(obstacles.get(3).position);
       }

       mileStones.add(goal);    
      }
    } 
  
  
  
  void updateTrajectory(){
    float xVel = endGoal.x - position.x;
    float yVel = endGoal.y - position.y;
    float dir = atan2(yVel, xVel);
    PVector goalVelocity = new PVector(maxVelocity*cos(dir),maxVelocity*sin(dir));
    
    float xVelDiff = goalVelocity.x - velocity.x;
    float yVelDiff = goalVelocity.y - velocity.y;
    if(abs(xVelDiff) > .9 && abs(yVelDiff) > .9){//If the difference is to great, reorient towards the goal
      velocity.x += xVelDiff/30;
      velocity.y += yVelDiff/30;
    }

  }
  
  void goalReached(){
    float distance = position.dist(endGoal);
    if(distance < 30){ // near enough to the goal
      // If new goal hasn't changed
      if (flockGoals.get(flockId).x == endGoal.x & flockGoals.get(flockId).y == endGoal.y){
        endGoal = createGoal(position);
        robotX = position.x;
        robotY = position.y;
          Speed = 8;

    //currentInd = 1;
      mileStoneObjs = new ArrayList();
      finalPath = new ArrayList();
      
      
      for(int i = 0; i < numVertices; i ++){
        for(int j = 0; j < numVertices; j ++){
          adjacencyMatrix[i][j] = 0;
        }
      }
      mileStoneRad = 10;
      obstacleRad = 100;
      mileStones();
      for(int i = 0; i < mileStones.size(); i++){
        mileStoneObjs.add(new MileStone(mileStones.get(i), i+1));
      }
      findNeighbors();
      makeMatrix();
      dijkstra(adjacencyMatrix, 0);
      int ind = floor(finalPath.get(currentInd).x);
      for(int i = 0; i < mileStoneObjs.size(); i++){
        if(ind == mileStoneObjs.get(i).id){
          nextX = mileStoneObjs.get(i).position.x;
          nextY = mileStoneObjs.get(i).position.y;
          PVector goal = new PVector(nextX, nextY);
          endGoal = goal;
          break;
        }
      }
      flockGoals.set(flockId, endGoal);
      }
    }
    if (flockGoals.get(flockId).x != endGoal.x & flockGoals.get(flockId).y != endGoal.y){//This indicates a Boid that is laging behind
        if(distance < 100){
           endGoal = flockGoals.get(flockId);
        }
    }
  }

  void avoidObstacles(){
    for(int i = 0; i < numObstacles; i++){
      float distance = position.dist(obstacles.get(i).position);
      if(distance < obstacleRad) {
       println(distance);
       PVector dist = new PVector(position.x - obstacles.get(i).position.x, position.y - obstacles.get(i).position.y).normalize();
       position.x = obstacles.get(i).position.x + dist.x*obstacleRad*1.05;
       position.y = obstacles.get(i).position.y + dist.y*obstacleRad*1.05;
       float angle = velocity.heading() + radians(10);
       velocity.x = cos(angle);
       velocity.y = sin(angle);

      }
    }
  }



  void update(ArrayList<Boid> boids, float dt) {
    PVector seperationForce = separate(boids);   
    PVector alignmentForce = align(boids);      
    PVector cohesionForce = cohesion(boids);  
    

    acceleration.x += seperationForce.x*2.5 + alignmentForce.x + cohesionForce.x; 
    acceleration.y += seperationForce.y*2.5 + alignmentForce.y + cohesionForce.y; 
    
    velocity.x += acceleration.x*dt;
    velocity.y += acceleration.y*dt;
        
    velocity.limit(maxVelocity);

    //updateTrajectory();
    goalReached();
        //avoidObstacles();
    position.x += velocity.x*dt;
    position.y += velocity.y*dt;
        computePhysics(.9);
    acceleration = new PVector(0, 0);

    
    //Curve boids away from borders
    if(position.x + r + 20 > width){
      if(velocity.y > 0){
        velocity.y+=.1;
        velocity.x-=.1;
      } else {
        velocity.y-=.1;
        velocity.x-=.1;
      }
    }
    if(position.y + r + 20> height){
       if(velocity.x > 0){
        velocity.y-=.1;
        velocity.x+=.1;
      } else {
        velocity.y-=.1;
        velocity.x-=.1;
      }
    }
    if(position.x - r - 20< 0){
       if(velocity.y > 0){
        velocity.y+=.1;
        velocity.x+=.1;
      } else {
        velocity.y-=.1;
        velocity.x+=.1;
      }
    }
    if(position.y - r - 20< 0){
      if(velocity.x > 0){
        velocity.y+=.1;
        velocity.x+=.1;
      } else {
        velocity.y+=.1;
        velocity.x-=.1;
      }
    }
    drawScene();

  }


  void drawScene() {
    float angle = velocity.heading() + radians(90);
    
    fill(col);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    beginShape(TRIANGLES);
    vertex(-r, r);
    vertex(0, -r*2);
    vertex(r, r);
    endShape();
    popMatrix();
    //beginShape();
    //fill(128,0,128);
    //noStroke();
    //circle(endGoal.x, endGoal.y, 5);
    //endShape(CLOSE);
  
  
  }



  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25;
    PVector dir = new PVector();
    int count = 0;
    
    for (int i = 0; i < boids.size(); i++) {
      float distance = PVector.dist(position, boids.get(i).position);
      if ((distance > 0) && (distance < desiredseparation)) {
        
        PVector difference = PVector.sub(position, boids.get(i).position);
        difference.normalize();
        difference.div(distance);       
        dir.add(difference);
        count++;            
      }
    }
    if (count > 0) {
      dir.div(count);
    }

    dir.limit(maxforce);
    return dir;
  }


  PVector align (ArrayList<Boid> boids) {
    PVector sum = new PVector();
    int count = 0;
    for (int i = 0; i < boids.size(); i++) {
      float d = PVector.dist(position, boids.get(i).position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(boids.get(i).velocity);
        count++;
      }
    }
    //Color based on the number of neighbors
    col = color(colVals.x, min(colVals.y - count*7, 255), min(colVals.z + count*7, 255));
    if (count > 0) {
      sum.div((float)count);


      PVector dir = PVector.sub(sum, velocity);
      dir.limit(maxforce);
      return dir;
    } 
    else {
      return new PVector();
    }
  }


  PVector cohesion (ArrayList<Boid> boids) {
    PVector sum = new PVector();   
    int count = 0;
    for (int i = 0; i < boids.size(); i++) {
      float d = PVector.dist(position, boids.get(i).position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(boids.get(i).position);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      PVector desired = PVector.sub(endGoal, position); 

      desired.normalize();
      desired.mult(maxVelocity);

      PVector dir = PVector.sub(desired, velocity);
      dir.limit(maxforce);  
      return dir;
    
    } 
    else {
      return new PVector();
    }
  }
  
    
  private void dijkstra(int[][] adjacencyMatrix, 
                                      int startVertex) 
  { //Algorithm derived from https://www.geeksforgeeks.org/printing-paths-dijkstras-shortest-path-algorithm/
      int nVertices = adjacencyMatrix[0].length; 
      // shortestDistances[i] will hold the 
      // shortest distance from src to i 
      int[] shortestDistances = new int[nVertices]; 
  
      // added[i] will true if vertex i is 
      // included / in shortest path tree 
      // or shortest distance from src to  
      // i is finalized 
      boolean[] added = new boolean[nVertices]; 
  
      // Initialize all distances as  
      // INFINITE and added[] as false 
      for (int vertexIndex = 0; vertexIndex < nVertices;  
                                          vertexIndex++) 
      { 
          shortestDistances[vertexIndex] = Integer.MAX_VALUE; 
          added[vertexIndex] = false; 
      } 
        
      // Distance of source vertex from 
      // itself is always 0 
      shortestDistances[startVertex] = 0; 
  
      // Parent array to store shortest 
      // path tree 
      int[] parents = new int[nVertices]; 
  
      // The starting vertex does not  
      // have a parent 
      parents[startVertex] = NO_PARENT; 
  
      // Find shortest path for all  
      // vertices 
      for (int i = 1; i < nVertices; i++) 
      { 
  
          // Pick the minimum distance vertex 
          // from the set of vertices not yet 
          // processed. nearestVertex is  
          // always equal to startNode in  
          // first iteration. 
          int nearestVertex = nVertices - 1; 
          int shortestDistance = Integer.MAX_VALUE; 
          for (int vertexIndex = 0; 
                   vertexIndex < nVertices;  
                   vertexIndex++) 
          { 
              if (!added[vertexIndex] && 
                  shortestDistances[vertexIndex] <  
                  shortestDistance)  
              { 
                  nearestVertex = vertexIndex; 
                  shortestDistance = shortestDistances[vertexIndex]; 
              } 
          } 
  
          // Mark the picked vertex as 
          // processed 
          added[nearestVertex] = true; 
  
          // Update dist value of the 
          // adjacent vertices of the 
          // picked vertex. 
          for (int vertexIndex = 0; 
                   vertexIndex < nVertices;  
                   vertexIndex++)  
          { 
              int edgeDistance = adjacencyMatrix[nearestVertex][vertexIndex]; 
                
              if (edgeDistance > 0
                  && ((shortestDistance + edgeDistance) <  
                      shortestDistances[vertexIndex]))  
              { 
                  parents[vertexIndex] = nearestVertex; 
                  shortestDistances[vertexIndex] = shortestDistance +  
                                                     edgeDistance; 
              } 
          } 
      } 
      printSolution(startVertex, shortestDistances, parents); 
  } 
  
  void printPath(int currentVertex, 
                                int[] parents, boolean isPath) 
  { 
        
      // Base case : Source node has 
      // been processed 
      if (currentVertex == NO_PARENT) 
      { 
          return; 
      } 
      printPath(parents[currentVertex], parents, isPath); 
      System.out.print(currentVertex + " "); 
      if(isPath){
          PVector path = new PVector(currentVertex, -1);
          finalPath.add(path);
      }
    
  } 
  
  private void printSolution(int startVertex, 
                                        int[] distances, 
                                        int[] parents) 
  { 
      int nVertices = distances.length; 
      System.out.print("Vertex\t Distance\tPath"); 
        
      for (int vertexIndex = 0;  
               vertexIndex < nVertices;  
               vertexIndex++)  
      { 
          if (vertexIndex != startVertex)  
          { 
              System.out.print("\n" + startVertex + " -> "); 
              System.out.print(vertexIndex + " \t\t "); 
              System.out.print(distances[vertexIndex] + "\t\t"); 
              if(vertexIndex == nVertices-1){
                 printPath(vertexIndex, parents, true); 
              }
              else{
                            printPath(vertexIndex, parents, false); 
              }
          } 
      } 
  } 
}

class MileStone{
  PVector position;
  ArrayList<MileStone> neighbors;
  ArrayList<Float> distToNeighbors;
  float distToEnd = 0;
  float distToStart = 0;
  ArrayList<MileStone> Start;
  ArrayList<MileStone> End;
  int id;
  
  MileStone(PVector pos, int i){
    position = pos;
    neighbors = new ArrayList();
    distToNeighbors = new ArrayList();
    Start = new ArrayList();
    End = new ArrayList();
    id = i;
  }
}
