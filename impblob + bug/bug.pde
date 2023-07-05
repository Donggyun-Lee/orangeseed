class Bug {
  PVector curP;
  int id = 0;

  Bug() {
    curP = new PVector(width, height/2);
  }

  void update() {
    if (id > blobs.size() - 1) {
      curP = new PVector(450, height/2);
      id = 0;
    }
    if (blobs.size() > 0) {
      PVector c = blobs.get(id).getCenter();
      PVector dir = PVector.sub(c, curP);
      float d = dist(c.x, c.y, curP.x, curP.y);
      if (d > 5) {
        dir.normalize();
        dir.mult(3);
        curP.add(dir);
      } else if (d < 5 && d > 0) {
        curP = new PVector(c.x, c.y);
      } else if (d == 0) {
        if (id < blobs.size() - 1) {
          id ++;
        } else if (id == blobs.size() - 1) {
          curP = new PVector(450, height/2);
          id = 0;
        }
      }
    }
  }

  void display() {
    noStroke();
    fill(255, 0, 0);
    imageMode(CENTER);
    image(ladybug[index], curP.x, curP.y - 20, 60, 45);
    index ++;
  }
}
