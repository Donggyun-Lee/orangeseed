Bug bug;
ArrayList<PVector> circles= new ArrayList<PVector>();



void setup() {
  size(500, 500);
  bug = new Bug();
}

void draw() {
  background(255);
  for (int i = 0; i < circles.size(); i++ ) {
    PVector circle = circles.get(i);
    fill(0);
    ellipse(circle.x, circle.y, 30, 30);
  }
  bug.update();
  bug.display();
  
}

void mousePressed() {
  fill(0);
  circles.add(new PVector(mouseX, mouseY));
}
