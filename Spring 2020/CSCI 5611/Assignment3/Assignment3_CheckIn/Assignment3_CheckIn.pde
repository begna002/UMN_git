Obstacle obstacle;
Robot robot;

float robotRad;
float robotX;
float robotY;
float obstacleRad;
float nextX;
float nextY;
float endX;
float endY;
float endRad;
int currentInd;
float Speed;
float mileStoneRad;
PVector robPos;
ArrayList<PVector> mileStones;
ArrayList<MileStone> mileStoneObjs;
float neighborLimit = 4;
int numVertices = 22;
ArrayList<PVector> startEnd;
int[][] adjacencyMatrix = new int[numVertices][numVertices];
private static final int NO_PARENT = -1; 
static ArrayList<PVector> finalPath;

void init(){
  Speed = 8;
  currentInd = 1;
  endX = 1900;
  endY = 100;
  robotX = 100;
  robotY = 1900;
  robPos = new PVector(robotX, robotY);
  obstacle = new Obstacle(1000, 1000);
  mileStoneObjs = new ArrayList();
  finalPath = new ArrayList();
  
  
  for(int i = 0; i < numVertices; i ++){
    for(int j = 0; j < numVertices; j ++){
      adjacencyMatrix[i][j] = 0;
    }
  }

  robotRad = 100;
  endRad = 100;
  mileStoneRad = 50;
  obstacleRad = 400;
  mileStones();
  for(int i = 0; i < mileStones.size(); i++){
    mileStoneObjs.add(new MileStone(mileStones.get(i), i+1));
  }
  findNeighbors();
  makeMatrix();
  printAdjacencyMatrix();
  
  dijkstra(adjacencyMatrix, 0);
  printFinalPath();
  int ind = floor(finalPath.get(currentInd).x);
  for(int i = 0; i < mileStoneObjs.size(); i++){
    if(ind == mileStoneObjs.get(i).id){
      nextX = mileStoneObjs.get(i).position.x;
      nextY = mileStoneObjs.get(i).position.y;
      PVector endGoal = new PVector(nextX, nextY);
      robot = new Robot(robPos, endGoal);
      break;
    }
  }
  
  
}
void setup() {
  size(2000,2000);
  init();
}

void printFinalPath(){
  println("");
  for(int i = 0; i < finalPath.size(); i ++){
    print(finalPath.get(i).x);
    if( i < finalPath.size()-1){
       print(" -> ");
    }
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

void printAdjacencyMatrix(){
  for(int i = 0; i < numVertices; i++){
    String str = "[";
    for(int j = 0; j < numVertices; j++){
      if(j == numVertices - 1){
        str += " " + str(adjacencyMatrix[i][j]) + "]";
      } else {
        str += " " + str(adjacencyMatrix[i][j]) + ",";
      }
      
    }
    println("Vertex: " + str(i) + " " + str);
  }
}

void mileStones(){
  mileStones = new ArrayList();
  for(int i = 1; i < numVertices-1; i++){
    PVector elem = new PVector(random(200, 1800), random(200, 1800));
    float distanceToObst = (elem).dist(obstacle.position);
    //randomize points until they don't collide with obstacle
    while(distanceToObst < (robotRad+obstacleRad)/2) {
      elem = new PVector(random(200, 1800), random(200, 1800));
      distanceToObst = (elem).dist(obstacle.position);
      //for(int j = 0; j < mileStones.size(); j++){
      //  float distanceToMilestone = (elem).dist(mileStones.get(j));
      //  while(distanceToMilestone < 500) {
      //    println(distanceToMilestone);
      //    elem = new PVector(random(200, 1800), random(200, 1800));
      //    distanceToMilestone = (elem).dist(mileStones.get(j));
      //  }
      //}
    }
    mileStones.add(elem);    
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
  PVector End = new PVector(endX, endY);
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

void drawScene() {
  background(173, 216, 230);
  
  beginShape();
  fill(200,0,0);
  noStroke();
  ellipse(obstacle.position.x, obstacle.position.y, obstacleRad, obstacleRad);
  endShape(CLOSE);
  

  for(int i = 0; i < mileStoneObjs.size(); i++){
    for(int j = 0; j < mileStoneObjs.get(i).neighbors.size(); j++){
      if(j < neighborLimit){//Don't draw extra edges that seem to come up due to some bug, they don't exist in the adjacency matrix anyway
        beginShape();
        strokeWeight(2);
        PVector line1 = new PVector(mileStoneObjs.get(i).id, -1);
        PVector line2 = new PVector(mileStoneObjs.get(i).neighbors.get(j).id, -1);
        if(finalPath.contains(line1) && finalPath.contains(line2) || mileStoneObjs.get(i).Start.size() != 0 && mileStoneObjs.get(i).neighbors.get(j).id < 1|| mileStoneObjs.get(i).End.size() != 0 && mileStoneObjs.get(i).neighbors.get(j).id >20){
            strokeWeight(7);
            stroke(0, 200, 0);
        } else {
            stroke(0, 0, 0);
            strokeWeight(2);
        }
        line(mileStoneObjs.get(i).position.x, mileStoneObjs.get(i).position.y, mileStoneObjs.get(i).neighbors.get(j).position.x, mileStoneObjs.get(i).neighbors.get(j).position.y);
        //float midpointX = mileStoneObjs.get(i).position.x -mileStoneObjs.get(i).neighbors.get(j).position.x;
        //float midpointY = mileStoneObjs.get(i).position.y -mileStoneObjs.get(i).neighbors.get(j).position.y;
        //PVector mid = new PVector(midpointX, midpointY);
        //PVector midNorm = mid.normalize();
        //PVector pos = new PVector(mid.x/midNorm.x, mid.y/midNorm.y);
        ////float dist = sqrt(midpointX*midpointX + midpointY*midpointY);
  
        //textSize(20);
        //println(mileStoneObjs.get(i).distToNeighbors.size() + " " + mileStoneObjs.get(i).neighbors.size());
        //text(floor(mileStoneObjs.get(i).distToNeighbors.get(j)),mileStoneObjs.get(i).position.x+midpointX/2,mileStoneObjs.get(i).position.y+midpointY/2);
        endShape(CLOSE);
      }
    }
  }
  for(int i = 0; i < mileStoneObjs.size(); i++){
    if(mileStoneObjs.get(i).Start.size() > 0){
       beginShape();
       strokeWeight(7);
       stroke(0, 200, 0);
       line(mileStoneObjs.get(i).Start.get(0).position.x, mileStoneObjs.get(i).Start.get(0).position.y, mileStoneObjs.get(i).position.x, mileStoneObjs.get(i).position.y);
       endShape(CLOSE);
    }
    if(mileStoneObjs.get(i).End.size() > 0){
       beginShape();
       strokeWeight(7);
       stroke(0, 200, 0);
       line(mileStoneObjs.get(i).position.x, mileStoneObjs.get(i).position.y, mileStoneObjs.get(i).End.get(0).position.x, mileStoneObjs.get(i).End.get(0).position.y);
       endShape(CLOSE);
    }
  }

    
  for(int i = 0; i < mileStoneObjs.size(); i++){
    beginShape();
    fill(128,0,128);
    noStroke();
    ellipse(mileStoneObjs.get(i).position.x, mileStoneObjs.get(i).position.y, mileStoneRad, mileStoneRad);
    fill(255,255,255);
    textSize(50);
    text(mileStoneObjs.get(i).id,mileStoneObjs.get(i).position.x-mileStoneRad/2,mileStoneObjs.get(i).position.y+mileStoneRad/2);
    endShape(CLOSE);
  }
  beginShape();
  fill(0,200,0);
  noStroke();
  ellipse(endX, endY, endRad, endRad);
  endShape(CLOSE);
  
  beginShape();
  fill(255,255,255);
  noStroke();
  ellipse(robot.position.x, robot.position.y, robotRad, robotRad);
  endShape(CLOSE);
}

void computePhysics(float dt){
  if(abs(robot.position.x - nextX) < 5 && abs(robot.position.y - nextY) < 5){
    if (currentInd+1 > finalPath.size()-1){//Robot is 1 milestone away from end
      nextX = endX;
      nextY = endY;
      robPos = new PVector(robot.position.x, robot.position.y);
      PVector endGoal = new PVector(nextX, nextY);
      robot = new Robot(robPos, endGoal);
    } else {//Robot is going to next milestone
      currentInd+=1;
      int ind = floor(finalPath.get(currentInd).x);
      for(int i = 0; i < mileStoneObjs.size(); i++){
        if(ind == mileStoneObjs.get(i).id){
          robPos = new PVector(robot.position.x, robot.position.y);
          nextX = mileStoneObjs.get(i).position.x;
          nextY = mileStoneObjs.get(i).position.y;
          PVector endGoal = new PVector(nextX, nextY);
          robot = new Robot(robPos, endGoal);
          break;
        }
      }
    }
    
    //robot.trajectory.x = 0;
    //robot.trajectory.y = 0;
  }
  else {
    robot.updateTrajectory();
    //robot.position.x -= robot.trajectory.x*dt;
    //robot.position.y -= robot.trajectory.y*dt;
  }
  if(abs(robot.position.x - endX) < 3 && abs(robot.position.y - endY) < 3){
    Speed = 0;
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
  try{
    computePhysics(.9);
    drawScene();
  } catch(Exception e){
    init();
  }
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
    float dir = atan2(yVel, xVel);
    position.x += Speed*cos(dir);
    position.y += Speed*sin(dir);

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


// A Java program for Dijkstra's 
// single source shortest path  
// algorithm. The program is for 
// adjacency matrix representation 
// of the graph. 
  
static void printPath(int currentVertex, 
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

private static void printSolution(int startVertex, 
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

// representation 
private static void dijkstra(int[][] adjacencyMatrix, 
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
