//cf. http://processing.org/examples/simpleparticlesystem.html

ParticleSystem ps;

void setup() {
  noStroke();
  colorMode(HSB, 255);
  
  size(800,600);
  background(0);
  
  ps = new ParticleSystem(new PVector(0,0));
}

void draw() {
  background(0);
  ps.run();
}

void mouseReleased() {
  ps.setOrigin(new PVector(mouseX,mouseY));
  fireworksRandom(ps, 0.0, 1.2);
  fireworksRandom(ps, 1.2, 1.8);
  fireworksRandom(ps, 1.8, 2.1);
}

void fireworksRandom(ParticleSystem _ps, float randomStart, float randomEnd){
  int particleNum = 150;
  int i;
  
  float angle;
  float amp;
  
  float initH = 255.0 * random(0,1);
  float initS = 255.0 * random(0,1);
  
  for(i=0; i<particleNum; i++){
    angle = TWO_PI * random(-1,1);
    amp = random(randomStart,randomEnd);
    _ps.addParticle(amp*cos(angle),amp*sin(angle)-0.5, initH, initS);
  }
}

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float lifespanDecay = 0.8;
  float initialAcY = 0.015;
  float diameter = 5.0;
  
  float initH;
  float initS;
  
  Particle(PVector l, float x, float y, float h, float s) {
    acceleration = new PVector(0,initialAcY);
    velocity = new PVector(x,y);
    location = l.get();
    lifespan = 255.0;
    initH = h;
    initS = s;
  }

  void run() {
    update();
    display();
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= lifespanDecay;
  }

  void display() {
    float tmp;
    tmp = lifespan/255.0;
    tmp = tmp*tmp;
    float dia = tmp*diameter;
    fill(tmp*initH, initS, 255.0 ,tmp*255.0);
    ellipse(location.x,location.y, dia,dia);
  }
  
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;

  ParticleSystem(PVector location) {
    origin = location.get();
    particles = new ArrayList<Particle>();
  }
  
  void setOrigin(PVector location) {
    origin = location.get();
  }
  
  void addParticle(float x, float y, float h, float s) {
    particles.add(new Particle(origin, x, y, h, s));
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
