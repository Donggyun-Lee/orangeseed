import fisica.*;

FWorld world;
int r = 40;
int g = 40;
int b = 40;
int rx = 60;
int ry = 2;
int sx = 82;
int sy = 22;
int cr = 20;
boolean dr = true;
boolean dg = false;
boolean db = false;

void setup() {
  fullScreen();
  Fisica.init(this);
  world = new FWorld();
}

void draw() {
  background(204, 199, 176);
  color c = color(r, g, b);


  if (mousePressed) {
    if (mouseButton == LEFT) {
      FCircle c1 = new FCircle(cr);
      c1.setNoFill();
      c1.setNoStroke();
      c1.setPosition(mouseX, mouseY);
      c1.setStatic(true);
      world.add(c1);

      FCircle c2 = new FCircle(cr);
      c2.setNoFill();
      c2.setNoStroke();
      c2.setPosition(mouseX, mouseY);
      c2.setGrabbable(true);
      world.add(c2);

      FDistanceJoint spring = new FDistanceJoint(c1, c2);
      spring.setFrequency(0.9);
      spring.setDamping(0.9);
      spring.setLength(30);
      spring.setNoFill();
      spring.setDrawable(true);
      spring.setStrokeWeight(cr);
      spring.setStroke(r, g, b, 205);
      world.add(spring);
    }
  }

  world.step();
  world.draw();
  fill(255);
  rect(rx, ry, sx, sy);
  textSize(20);
  fill(r, 0, 0);
  text("Red" + r, 60, 20);
  fill(0, g, 0);
  text("Green" + g, 60, 40);
  fill(0, 0, b);
  text("Blue" + b, 60, 60);
  fill(c);
  stroke(255);
  ellipse(30, 35, 50, 50);
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    if (dr == true) {
      dg = true;
      dr = false;
      ry += 20;
    } else if (dg == true) {
      db = true;
      dg = false;
      ry += 20;
    } else if (db == true) {
      dr = true;
      db = false;
      ry -= 40;
    }
  }
}



void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (dr == true) {
    r += e;
  } else if (dg == true) {
    g += e;
  } else if (db == true) {
    b += e;
  }
}
