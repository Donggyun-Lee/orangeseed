import KinectPV2.*;

KinectPV2 kinect;
Bug bug;

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
  size(512, 424, P3D);
  //fullScreen(P3D);
  frameRate(15);
  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);
  kinect.init();
  img = kinect.getDepthImage();

  //get ladybug frames from data folder
  for (int i = 0; i < ladybug.length; i++) {
    ladybug[i] = loadImage(i + ".png");
  }
  bug = new Bug();
}

void draw() {
  background(255);
  img.loadPixels();
  int[] depth =  kinect.getRawDepthData();

  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();


  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {
      int offset  = x + y * img.width;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh ) {
        img.pixels[offset] = color(0);

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
        img.pixels[offset] = color(255);
      }
    }
  }

  img.updatePixels();
  image(img, 0, 0, 512, 424);


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
  if (blobs.size() >= 1) {
    stroke(0, 255, 0);
    strokeWeight(20);
    line(450, height/2, blobs.get(0).getCenter().x, blobs.get(0).getCenter().y);
  }

  for (int i = 0; i < blobs.size() -1; i++) {
    PVector p1 = blobs.get(i).getCenter();
    PVector p2 = blobs.get(i + 1).getCenter();
    stroke(0, 255, 0);
    strokeWeight(20);
    line(p1.x, p1.y, p2.x, p2.y);
  }

  //showing blobs location
  for (Blob b : blobs) {
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
}
