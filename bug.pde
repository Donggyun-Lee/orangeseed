class Bug {
  PVector curP;
  int id = 0;

  Bug() {
    curP = new PVector(0, width/2);
  }

  void update() {
    if (circles.size() > 0) {
      PVector c = circles.get(id);
      PVector dir = PVector.sub(c, curP);
      float d = dist(c.x, c.y, curP.x, curP.y);
      if (d > 5) {
        dir.normalize();
        dir.mult(1);
        curP.add(dir);
      } else if (d < 5 && d > 0) {
        curP = c;
      } else if (c == curP) {
        id += 1;
      }
    }
  }

  void display() {
    noStroke();
    fill(255, 0, 0);
    ellipse(curP.x, curP.y, 20, 20);
  }
}
