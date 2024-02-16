// Copyright Zoey Schlemper, Feb 16th 2024
class PointCloud{
  Point[] points;
  Line[] activeLines;
  Particle[] activeParticles;
  String[] activeLineIds;
  int density;
  int maxLineDistance; 
  color sharedColor;
  
  PointCloud(int w, int h, int distanceBetweenPoints, int lineDistance, color baseColor, boolean allowPlayer){
    density = distanceBetweenPoints;
    int totalWidth = w/density;
    int totalHeight = h/density;
    int totalPoints = totalWidth*totalHeight;
    if (allowPlayer == true){
      points = new Point[totalPoints+1];
    } else {
      points = new Point[totalPoints];
    }
    activeLines = new Line[0];
    activeParticles = new Particle[0];
    maxLineDistance = lineDistance;
    // Create new points
    int counter = 0;
    for (int i = 0; i < totalWidth; i = i+1){
      for (int j = 0; j < totalHeight; j = j+1){
        int px = int(random(-density/2, density/2)) + (i*density);
        int py = int(random(-density/2, density/2)) + (j*density);
        points[counter] = new Point(px, py, baseColor, maxLineDistance, false);
        counter += 1;
      }
    }
    if (allowPlayer == true){
      points[counter] = new Point(mouseX, mouseY, color(red(baseColor)+80,green(baseColor)+80,blue(baseColor)+80) , maxLineDistance, true);
    } 
    sharedColor = baseColor;
}
  void update(){
    //SIM POINTS
    // Draw each point, and then find any lines that point is eligible to draw.
    Line[] outLines = new Line[0];
    for (int i = 0; i < points.length; i = i+1){
      points[i].update(points, density);
      findLines(points[i]);
    }
     // SIM LINES
    // note which ones should be removed.
    int[] linesToKill = new int[0];
    for (int l = 0; l < activeLines.length; l = l+1){
      Line line = activeLines[l];
      if (line.drawLine(maxLineDistance) == false) {
        linesToKill = append(linesToKill, l);
      }
      
      //handle on line complete event
      if (line.life == line.maxLife && line.hasParticle == false && activeParticles.length < 10){
        //Particle newParticle = new Particle(line.getMidpoint(), random(2, 3), sharedColor, color(255,255,255), random(200,250));
        //activeParticles = (Particle[])append(activeParticles, newParticle);
        //line.hasParticle = true;
      }
    }
    // Remove all dead lines.
    Line[] tempLineArr = new Line[0];
    // for each existing line
    for (int l = 0; l < activeLines.length; l = l+1){
      boolean skip = false;
      // compare it against each of the lines to kill
      for (int k = 0; k < linesToKill.length; k = k+1){
        int deadIndex = linesToKill[k];
        // if a known deadIndex matches the index of a line we are tracking, note that it should be skipped, then break out of the for loop.
        if (l == deadIndex){
          //This index should be skipped.
          skip = true;
          break;
        }
      }
      // after checking it against all dead indexes, only keep the line if we didn't try to skip it.
      if (skip == false){
        tempLineArr = (Line[])append(tempLineArr, activeLines[l]);
      }
    }
    activeLines = tempLineArr;
    //println("Lines: ", activeLines.length);
  
}
  
  void findLines(Point thisPoint){
    for (int i = 0; i < points.length; i = i+1){
      Point otherPoint = points[i];
      if (otherPoint.name.equals(thisPoint.name)){
        continue;
      }
      float distance = dist(thisPoint.position.x, thisPoint.position.y, otherPoint.position.x, otherPoint.position.y);
      if (distance > maxLineDistance) {
        continue;
      }
      
      if (lineExists(thisPoint.name, otherPoint.name)){
        continue;
      } else {
        Line newLine = new Line(thisPoint, otherPoint);
        activeLines = (Line[])append(activeLines, newLine);
      }
    }
  }
  boolean lineExists(String nameA, String nameB){
    String lineName = nameA + nameB;
    for (int x = 0; x < activeLines.length; x = x+1){
      Line lineToTest = activeLines[x];
      String nameVariant1 = lineToTest.pointA.name + lineToTest.pointB.name;
      String nameVariant2 = lineToTest.pointB.name + lineToTest.pointA.name;
      if (lineName.equals(nameVariant1)){
        return true;  
      } else if (lineName.equals(nameVariant2)){
        return true;
      }
    }
    return false;
  }
}
