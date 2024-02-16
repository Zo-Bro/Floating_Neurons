// Copyright Zoey Schlemper, Feb 16th 2024
/*
Looks at the given set of points and lines, finds points that are conencted to one another, and then spawns a chain of particles across those points.
*/
class LineJumper{
  float mainTimerMax;
  float mainTimer;
  float jumpTimeMax;
  float jumpTimer;
  Point[] jumpSquad;
  int maxJumpDist;
  int jumpIdx;
  
  LineJumper(float mainTime, float jumpTime, int maxJump){
    mainTimerMax = mainTime;
    mainTimer = mainTime;
    jumpTimeMax = jumpTime;
    jumpTimer = jumpTime;
    jumpSquad = new Point[0];
    maxJumpDist = maxJump;
  }
  Particle update(Point[] points, Line[] lines){
    mainTimer = mainTimer - 0.1;
    if (mainTimer > 0.0){
      return new Particle();
    }
    println("Starting Jump!");
    // its Jump time!
    if (jumpSquad.length < 1){
      Point lastJumper = points[floor(random(0,points.length))]; 
      // find a jump combo.
      jumpSquad = new Point[0];
      for(int i = 1; i < 5; i = i+ 1){
        for (Line toCheck : lines){
          // check if this line is connected to the starting point
          if (toCheck.pointA.name.equals(lastJumper.name)){
            boolean keeper = true;
            for (Point jumper : jumpSquad){
              // dont take repeats
              if (jumper.name.equals(toCheck.pointB.name)){
                keeper = false;
                break;
              }
            }
            if (keeper == true){
              jumpSquad = (Point[])append(jumpSquad, toCheck.pointB);
              lastJumper = toCheck.pointB;
            }  
            
        } else if (toCheck.pointB.name.equals(lastJumper.name)){
            boolean keeper = true;
            for (Point jumper : jumpSquad){
              // dont take repeats
              if (jumper.name.equals(toCheck.pointA.name)){
                keeper = false;
                break;
              }
            }
            if (keeper == true){
            jumpSquad = (Point[])append(jumpSquad, toCheck.pointA);
            lastJumper = toCheck.pointA;
          }
          //reset the jump index if we found one.
          jumpIdx = 0;
          println("Found " + jumpSquad.length + " Jumpers!");
          break;
        }
      }
      }
    }

    // cant jump if theres only 1
    if (jumpSquad.length < 1){
      return new Particle();
    }
    // run the jump timer
    jumpTimer = jumpTimer - 0.1;
    // cant jump if timer is not run down yet.
    if (jumpTimer > 0.0){
      return new Particle();
    }
    // do a jump!
    jumpTimer = jumpTimeMax;
    // check if we are done jumping
    if (jumpIdx >= jumpSquad.length){
      jumpSquad = new Point[0];
      mainTimer = mainTimerMax;
      return new Particle();
    }
    Point jumper = jumpSquad[jumpIdx];
    if (jumpIdx > 0){
      // check if this is still connected to the previous one.
      Point prevJumper = jumpSquad[jumpIdx-1];
      if (dist(prevJumper.position.x, prevJumper.position.y, jumper.position.x, jumper.position.y) > maxJumpDist){
        jumpSquad = new Point[0];
        mainTimer = mainTimerMax;
        return new Particle();
      }
    }
    jumpIdx = jumpIdx + 1;
    //jumper.fillColor = color(255, 0, 0);
    return new OrbParticle(jumper.position, 0.5, color(255, 255, 255, 128), color(255, 255, 255, 0), jumper.radius*2.0, jumper.radius);
  }
}
