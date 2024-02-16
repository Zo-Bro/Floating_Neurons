// Copyright Zoey Schlemper, Feb 16th 2024
/*
A VFX based on that cool neuron network effect you see on crypto websites all the time.
*/

PointCloud pCloud;
LineJumper lineJump;

Line[] activeLines;
Particle[] activeParticles;

color baseColor = color(60, 0, 120); // color of entire sim based on this.
boolean includePlayer = true; // allow mouse control of one neuron.
int maxLineDistance = 200;
void setup() {
  size(2000, 1200);
  pCloud = new PointCloud(width, height, 200, maxLineDistance, baseColor, includePlayer);
  lineJump = new LineJumper(10.0, 1.5, maxLineDistance);
  activeParticles = new Particle[0];
  activeLines = new Line[0];
}

void draw() {
  background(28, 0, 20);
  delay(10);
  pCloud.update();
  
  Particle newParticle = lineJump.update(pCloud.points, pCloud.activeLines);
  if (newParticle.dead == false){
     activeParticles = (Particle[])append(activeParticles, newParticle); 
  }
  activeParticles = simParticles(activeParticles);
  
}

// Simulate the given list of particles, and then remove any which die after this frame.
Particle[] simParticles(Particle[] activeParticles){
    // SIM PARTICLES
    // note which should be removed.
    int[] particlesToKill = new int[0];
    for (int p = 0; p < activeParticles.length; p = p + 1){
      Particle particle = activeParticles[p];
      particle.update();
      if (particle.dead == true) {
          particlesToKill = append(particlesToKill, p);
      }
    }
    // Remove all dead particles.
    Particle[] tempParticleArr = new Particle[0];
    // for each existing particle
    for (int l = 0; l < activeParticles.length; l = l+1){
      boolean skip = false;
      // compare it against each of the particles to kill
      for (int k = 0; k < particlesToKill.length; k = k+1){
        int deadIndex = particlesToKill[k];
        // if a known deadIndex matches the index of a particle we are tracking, note that it should be skipped, then break out of the for loop.
        if (l == deadIndex){
          //This index should be skipped.
          skip = true;
          break;
        }
      }
      // after checking it against all dead indexes, only keep it if we didn't try to skip it.
      if (skip == false){
        tempParticleArr = (Particle[])append(tempParticleArr, activeParticles[l]);
      }
    }
    //println("Particles: ", activeParticles.length);
    return tempParticleArr;
}
