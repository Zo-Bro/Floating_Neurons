// Copyright Zoey Schlemper, Feb 16th 2024
class Line {
  Point pointA;
  Point pointB;
  int life;
  int maxLife;
  //Appearance
  int weight;
  boolean hasParticle;
  Line(Point a, Point b) {
    pointA = a;
    pointB = b;
    life = 1;
    maxLife = 30;
    weight = 10;
    hasParticle = false;
  }
  boolean drawLine(int maxDistance) {
    // Draws the line if this line would continue to live on this frame.
    // returns False if this line should die
    //
    //println(pointA.position.x, pointA.position.y);
    strokeWeight(map(life, 0, maxLife, weight/2, weight));
    float distance = dist(pointA.position.x, pointA.position.y, pointB.position.x, pointB.position.y);
    if (distance > maxDistance) {
      life = life - 1;
    } else {
      life = life + 1;
    }
    life = constrain(life, 0, maxLife);
    if (life < 1) {
      return false;
    }
    // draw one half of line
    PVector toTarget =  new PVector(pointB.position.x-pointA.position.x, pointB.position.y-pointA.position.y);
    float amt = map(life, 0, maxLife, 0, .5);
    toTarget.mult(amt);
    PVector applied = new PVector(pointA.position.x, pointA.position.y).add(toTarget);
    
    if (dist(pointA.position.x, pointA.position.y, applied.x, applied.y) < maxDistance/2){
      stroke(pointA.fillColor, map(life, 0, maxLife, 0, 255));
      line(pointA.position.x, pointA.position.y, applied.x, applied.y);
    }
    // draw other half of line
    PVector toTarget2 =  new PVector(pointA.position.x-pointB.position.x, pointA.position.y-pointB.position.y);
    toTarget2.mult(amt);
    PVector applied2 = new PVector(pointB.position.x, pointB.position.y).add(toTarget2);
    if (dist(pointB.position.x, pointB.position.y, applied2.x, applied2.y) > maxDistance/2){
      return true;
    }
    stroke(pointB.fillColor, map(life, 0, maxLife, 0, 255));
    line(pointB.position.x, pointB.position.y, applied2.x, applied2.y);
    return true;
  }
  PVector getMidpoint(){
     PVector mid = new PVector(pointB.position.x-pointA.position.x, pointB.position.y-pointA.position.y);
     mid.mult(0.5);
     return new PVector(pointA.position.x, pointA.position.y).add(mid);
  }
}
