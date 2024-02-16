// Copyright Zoey Schlemper, Feb 16th 2024
class Point{
  // Movement
  PVector velocity;
  PVector acceleration;
  float maxForce;
  float maxSpeed;
  PVector position;
  PVector  home;  // How far away a point will travel from home
  String name;
  int maxRange;

  //Appearance
  int radius;
  color fillColor;
  int colorVariance;
  boolean warped;
  color shineColor;
  float shineTime;
  
  //Misc
  boolean mouseControlled;
  
  Point(int x, int y, color baseColor, int maxLineRange, boolean isPlayer) {
    radius = 30;
    colorVariance = 30;
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    acceleration = new PVector(0,0);
    position = new PVector(x, y);
    home = new PVector(x, y);
    name = str(x) + "_" + str(y);
    maxSpeed = 0.5;
    maxForce = 0.03;
    maxRange = maxLineRange;
    fillColor = color(
                      random(-colorVariance, colorVariance) + red(baseColor),
                      random(-colorVariance, colorVariance) + green(baseColor),
                      random(-colorVariance, colorVariance) + blue(baseColor)
                      );
    shineColor = fillColor;
    shineTime = 0;
    warped = false;
    mouseControlled = isPlayer;
    
  }
  
  void update(Point[] points, int density){
    // move the point
    if (mouseControlled){
      position.x = mouseX;
      position.y = mouseY;
    } else{
      steer();
    }
    stroke(fillColor);
    strokeWeight(1);
    fill(fillColor, 255);
    ellipse(position.x, position.y, radius, radius);    
    //DEBUG DRAWING
    boolean DEBUG = false;
    if (DEBUG == true){
      float lineSize = 20.0f;
      line(position.x, position.y, position.x+(velocity.x*lineSize), position.y+(velocity.y*lineSize));
      //Debug: Draw home.
      ellipse(home.x, home.y, 2,2);
      //Debug: Draw maxrange;
      fill(fillColor, 0);
      ellipse(home.x, home.y, maxRange, maxRange);
    }
  }
  
  void steer(){
    // each point will meander within its set range
    float randomAmt = 0.05;
    PVector randomImpulse = new PVector(random(-randomAmt, randomAmt), random(-randomAmt, randomAmt));
    //shift the acceleration towards home based on the homeBias
    acceleration.add(randomImpulse);
    PVector correction = new PVector(0,0);
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    if (position.x > width+(maxRange/2)){
      position.x = 0;
      warped = true;
    } else if (position.x < 0-(maxRange/2)) {
      position.x = width +(maxRange/2) - 1 ;
      warped = true;
    }
    if (position.y > height + (maxRange/2)){
      position.y = 0-(maxRange/2)+1;
      warped = true;
    } else if (position.y < 0-(maxRange/2)) {
      position.y = height + (maxRange/2) - 1;
      warped = true;
    } else {
      warped = false;
    }
  }
}
