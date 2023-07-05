Tail[] tails = new Tail[30];

void setup() {
  size(640, 360);
  for (int i = 0; i < tails.length; i++) {
    tails[i] = new Tail(640, int(random(0, height)), int(random(5, 30)), 0.0);
  }
}

void draw() {
  background(190, 230, 255);
  for(int i = 0; i < tails.length; i++) {
    tails[i].update();
    tails[i].display();
  }
}
