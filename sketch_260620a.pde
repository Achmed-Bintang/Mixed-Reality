import processing.video.*;
import java.util.ArrayList;

Capture cam;
PImage prevFrame;

float handX = 0;
float handY = 0;

PVector[] points;
int currentPoint = 0;

void setup() {

  size(1280, 720);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("Kamera tidak ditemukan");
    exit();
  }

  cam = new Capture(this, cameras[0]);
  cam.start();

  points = new PVector[6];

  // Bentuk angka 5
  points[0] = new PVector(250, 120);
  points[1] = new PVector(650, 120);

  points[2] = new PVector(250, 300);

  points[3] = new PVector(650, 300);

  points[4] = new PVector(650, 500);

  points[5] = new PVector(250, 500);

  textAlign(CENTER);
}

void draw() {

  if (cam.available()) {
    cam.read();
  }

  image(cam, 0, 0, width, height);

  detectMotion();

  drawNumberFive();

  drawPoints();

  drawHandMarker();

  checkCollision();

  fill(255);
  textSize(28);

  if (currentPoint < points.length) {
    text(
      "Sentuhkan tangan ke titik kuning",
      width/2,
      50
      );
  }

  if (currentPoint >= points.length) {

    fill(0, 255, 0);

    textSize(60);

    text(
      "ANGKA 5 BERHASIL DIBENTUK",
      width/2,
      height - 50
      );
  }
}

void detectMotion() {

  if (prevFrame == null) {

    prevFrame = cam.get();
    return;
  }

  cam.loadPixels();
  prevFrame.loadPixels();

  float totalX = 0;
  float totalY = 0;

  int count = 0;

  for (int y=0; y<cam.height; y+=4) {

    for (int x=0; x<cam.width; x+=4) {

      int loc = x + y * cam.width;

      color current = cam.pixels[loc];
      color previous = prevFrame.pixels[loc];

      float diff =
        abs(red(current)-red(previous))
        + abs(green(current)-green(previous))
        + abs(blue(current)-blue(previous));

      if (diff > 60) {

        totalX += x;
        totalY += y;

        count++;
      }
    }
  }

  if (count > 50) {

    handX = map(
      totalX/count,
      0,
      cam.width,
      0,
      width
      );

    handY = map(
      totalY/count,
      0,
      cam.height,
      0,
      height
      );
  }

  prevFrame = cam.get();
}

void drawHandMarker() {

  fill(0, 255, 0);

  stroke(255);
  strokeWeight(3);

  ellipse(
    handX,
    handY,
    40,
    40
    );
}

void drawPoints() {

  for (int i=0; i<points.length; i++) {

    if (i == currentPoint) {

      fill(255, 255, 0); // target aktif

    } else {

      fill(255, 0, 0);
    }

    noStroke();

    ellipse(
      points[i].x,
      points[i].y,
      30,
      30
      );
  }
}

void checkCollision() {

  if (currentPoint >= points.length)
    return;

  float d = dist(
    handX,
    handY,
    points[currentPoint].x,
    points[currentPoint].y
    );

  if (d < 50) {

    currentPoint++;

    delay(200);
  }
}

void drawNumberFive() {

  stroke(0, 255, 255);
  strokeWeight(8);

  // Garis atas
  if (currentPoint > 1) {

    line(
      points[0].x,
      points[0].y,

      points[1].x,
      points[1].y
      );
  }

  // Garis kiri
  if (currentPoint > 2) {

    line(
      points[0].x,
      points[0].y,

      points[2].x,
      points[2].y
      );
  }

  // Garis tengah
  if (currentPoint > 3) {

    line(
      points[2].x,
      points[2].y,

      points[3].x,
      points[3].y
      );
  }

  // Garis kanan bawah
  if (currentPoint > 4) {

    line(
      points[3].x,
      points[3].y,

      points[4].x,
      points[4].y
      );
  }

  // Garis bawah
  if (currentPoint > 5) {

    line(
      points[4].x,
      points[4].y,

      points[5].x,
      points[5].y
      );
  }
}
