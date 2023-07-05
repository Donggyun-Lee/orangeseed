class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;
  int sec;
  int id = 0;

  boolean taken = false;

  float distSq(float x1, float y1, float x2, float y2) {
    float d = (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1);
    return d;
  }

  ArrayList<PVector> points;


  Blob (float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;

    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
  }

  void show() {
    noStroke();
    fill(0, 20);
    ellipse((maxx - minx) * 0.5 + minx, (maxy - miny)* 0.5 + miny, 50, 50);
    textAlign(CENTER,CENTER);
    textSize(20);
    fill(255);
    text("id:" + id, minx + (maxx - minx) * 0.5, (maxy - miny)* 0.5 + miny);
  }

  void add(float x, float y) {
    points.add(new PVector(x, y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }

  void become(Blob other) {
    minx = other.minx;
    maxx = other.maxx;
    miny = other.miny;
    maxy = other.maxy;
  }

  float size() {
    return (maxx - minx) * (maxy - miny);
  }

  PVector getCenter() {
    float x = (maxx - minx) * 0.5 + minx;
    float y = (maxy - miny)* 0.5 + miny;
    return new PVector(x, y);
  }

  boolean isNear(float x, float y) {
    float cx = max(min(x, maxx), minx);
    float cy = max(min(y, maxy), miny);

    float d = distSq(cx, cy, x, y);

    if (d < distThreshold * distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}
