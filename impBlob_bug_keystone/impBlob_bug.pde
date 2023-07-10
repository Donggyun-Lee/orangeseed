import deadpixel.keystone.*;
import KinectPV2.*;

KinectPV2 kinect;
Bug bug;
Keystone ks;
CornerPinSurface surface;

PGraphics offscreen;

//bug have 9 frames and frame number is  counted by index value
PImage[] ladybug = new PImage[9];
int index = 0;

int blobCounter = 0;

float minThresh = 0;
float maxThresh = 1700;
//float maxThresh = 550;

PImage img;
float distThreshold = 5;
float s = 4000;

ArrayList<Blob> blobs =new ArrayList<Blob>();
//line node position arraylist
ArrayList<PVector> pos = new ArrayList<PVector>();
void setup() {
  //size(512, 424, P3D);
  fullScreen(P3D);
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(400, 300, 20);
  offscreen = createGraphics(400, 300, P3D);

  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.init();
  img = kinect.getDepth256Image();

  //get ladybug frames from data folder
  for (int i = 0; i < ladybug.length; i++) {
    ladybug[i] = loadImage(i + ".png");
  }
  bug = new Bug();
}

//void keyPressed() {
//  if (key == 'a') {
//    distThreshold++;
//    print(distThreshold);
//  } else if (key == 'z') {
//    distThreshold--;
//    print(distThreshold);
//  } else if (key == 's') {
//    maxThresh += 100;
//    print(maxThresh);
//  } else if (key == 'x') {
//    maxThresh -= 10;
//    print(maxThresh);
//  } else if (key == 'd') {
//    minThresh += 10;
//    print(minThresh);
//  } else if (key == 'c') {
//    minThresh -= 10;
//    print(minThresh);
//  } else if (key == 'f') {
//    s += 100;
//    print(s);
//  } else if (key == 'v') {
//    s -= 100;
//    print(s);
//  }
//}

void draw() {
  PVector surfaceMouse = surface.getTransformedMouse();
  offscreen.beginDraw();
  offscreen.background(255);
  offscreen.fill(0, 255, 0);
  offscreen.ellipse(surfaceMouse.x, surfaceMouse.y, 75, 75);


  img.loadPixels();
  int[] depth =  kinect.getRawDepthData();

  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();


  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      int offset  = x + y * img.width;
      int d = depth[offset];

      // put && xy to make lline thine && y > 100 && y < 324
      if (d > minThresh && d < maxThresh ) {
        img.pixels[offset] = color(255, 0, 150);

        boolean found = false;
        for (Blob b : currentBlobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            //line node Position
            pos.add(new PVector(x, y));
            found = true;
            break;
          }
        }

        if (! found) {
          Blob b = new Blob(x, y);
          currentBlobs.add(b);
        }
      } else {
        img.pixels[offset] = color(0);
      }
    }
  }

  img.updatePixels();
  image(img, 0, 0);


  for (int i = currentBlobs.size() -1; i >= 0; i--) {
    if (currentBlobs.get(i).size() < s) {
      currentBlobs.remove(i);
    }
  }

  if (blobs.isEmpty() && currentBlobs.size() > 0) {
    for (Blob b : currentBlobs) {
      b.id = blobCounter;
      blobs.add(b);
      blobCounter++;
    }
  } else if (blobs.size() <= currentBlobs.size()) {
    for (Blob b : blobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob cb : currentBlobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();

        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !cb.taken) {
          recordD = d;
          matched = cb;
        }
      }
      matched.taken = true;
      b.become(matched);
    }

    for (Blob b : currentBlobs) {
      if (!b.taken) {
        b.id = blobCounter;
        blobs.add(b);
        blobCounter++;
      }
    }
  } else if (blobs.size() > currentBlobs.size()) {
    for (Blob b : blobs) {
      b.taken = false;
    }

    for (Blob cb : currentBlobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob b : blobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();

        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !b.taken) {
          recordD = d;
          matched = b;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.become(cb);
      }
    }
    for (int i = blobs.size() - 1; i >= 0; i--) {
      Blob b = blobs.get(i);
      if (!b.taken) {
        blobs.remove(i);
      }
    }
  }

  for (int i = 0; i < blobs.size() -1; i++) {
    PVector p1 = blobs.get(i).getCenter();
    PVector p2 = blobs.get(i + 1).getCenter();
    stroke(0, 255, 0);
    strokeWeight(10);
    line(p1.x, p1.y, p2.x, p2.y);
  }

  for (Blob b : blobs) {
    //b.update();
    b.show();
  }

  //to update bugs location
  bug.update();
  bug.display();
  if (index < 8) {
    index++;
  } else {
    index = 0;
  }


  offscreen.endDraw();

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);

  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  }
}


//for (int i = 0; i < pos.size()-1; i++) {
//  PVector p1 = pos.get(i);
//  PVector p2 = pos.get(i + 1);
//  if (i > 0) {
//    stroke(255);
//    line(p1.x, p1.y, p2.x, p2.y);
//  }
//}
