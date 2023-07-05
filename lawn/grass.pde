class Tail {
  int x;
  int y;
  int u;
  float a;
  float inc = 0.0;



  Tail(int x_, int y_, int units, float angle) {
    x = x_;
    y = y_;
    u = units;
    a = angle;
  }

  void update() {
    inc += 0.01;
  }
  
  
  void display() {
    float angle = sin(inc)/50.0 + sin(inc*0.2)/50.0;

    stroke(0,180, 30);
    pushMatrix();
    translate(x, y);
    for (int i = u; i > 0; i--) {
      strokeWeight(i);
      line(0, 0, -8, 0);
      translate(-8, 0);
      rotate(angle);
    }
    popMatrix();
  }
}
