class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;
  //int time = 0;
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
    //fill(255, 100);
    //rectMode(CORNERS);
    //rect(minx, miny, maxx, maxy);
    fill(255);
    ellipse((maxx - minx) * 0.5 + minx, (maxy - miny)* 0.5 + miny, 100, 100);
    //for (PVector v : points) {
    //  stroke(255, 0, 0);
    //  point(v.x, v.y);
    //}
    textAlign(CENTER,CENTER);
    textSize(20);
    fill(0);
    text("id:" + id, minx + (maxx - minx) * 0.5, (maxy - miny)* 0.5 + miny);
    //text("time:" + time, minx + (maxx - minx) * 0.5, (maxy - miny)* 0.5 + miny + 20);
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

  //void update() {
  //  sec++;
  //  if (sec > 60) {
  //    time += 1;
  //    sec = 0;
  //  }
  //}

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
    //float d = 100000;
    //for (PVector v : points) {
    //  float tempD = distSq(x, y, v.x, v.y);
    //  if (tempD < d) {
    //    d = tempD;
    //}
    //}

    if (d < distThreshold * distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}
