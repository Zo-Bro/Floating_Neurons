// Copyright Zoey Schlemper, Feb 16th 2024
class Particle{
  PVector position;
  float startLife;
  float lifetime;
  color startColor;
  color endColor;
  float finalSize;
  boolean dead;
  Particle(PVector startPos, float lifeDuration, color startClr, color endClr, float deathSize){
    position = startPos;
    startLife = lifeDuration;
    lifetime = lifeDuration;
    startColor = startClr;
    endColor = endClr;
    finalSize = deathSize;
    dead = false;
  }
  Particle(){
  dead= true;
  }
  boolean update(){
     lifetime = lifetime - 0.01;
     if (lifetime < 0){
       dead = true;
       return false;
     }
     return true;
  }
}
class OrbParticle extends Particle{
  int startSize;
   OrbParticle(PVector startPos, float lifeDuration, color startClr, color endClr, float deathSize, int startRadius){
     super(startPos, lifeDuration, startClr, endClr, deathSize);
     startSize = startRadius;
   }
  boolean update(){
     lifetime = lifetime - 0.01;
     if (lifetime < 0){
       dead = true;
       return false;
     }
     float lerpAmt = map(lifetime, startLife, 0, 0, 1);
     color currentColor = lerpColor(startColor, endColor, lerpAmt);
     stroke(currentColor);
     fill(currentColor);
     float size = lerp(startSize, finalSize, lerpAmt);
     ellipse(position.x, position.y, size, size);
     return true;
  }

}


// a particle that produces a ring shape that grows and fades over its lifetime.
class RingParticle extends Particle{
  int ringSize;
   RingParticle(PVector startPos, float lifeDuration, color startClr, color endClr, float deathSize, int ringWeight){
     super(startPos, lifeDuration, startClr, endClr, deathSize);
     ringSize = ringWeight;
   }
    boolean update(){
     lifetime = lifetime - 0.01;
     if (lifetime < 0){
       dead = true;
       return false;
     }
     fill(0, 0, 0, 0);
     color newColor = color(map(lifetime, startLife, 0, red(startColor), red(endColor)), 
                            map(lifetime, startLife, 0, green(startColor), green(endColor)),
                            map(lifetime, startLife, 0, blue(startColor), blue(endColor)),
                            map(lifetime, startLife, 0, 100, 0)
                            ); 
     stroke(newColor);
     strokeWeight(ringSize);
     float newSize = map(lifetime, startLife, 0, 0, finalSize);
     ellipse(position.x, position.y, newSize, newSize);
     return true;
  }

}
