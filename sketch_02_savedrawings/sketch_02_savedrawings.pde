PImage selector;
int sx = 0;
int sy = 0;

String videoPrefix = "handPlant";
int totalFrames = 16;
PImage videoFrame;

String drawingPrefix = "animation-";
PImage drawing;

int currentFrame = 0;
boolean showVideo = true;
boolean showColors = true;

color brushColor = 0;
int brushWeight = 10;

PGraphics d;  // Drawing layer

void setup() {
  size(720, 480);
  selector = loadImage("palatte.png");
  d = createGraphics(width, height);
  loadFrame();
  loadDrawing();
}

void draw() {
  background(153);
  if (showVideo) {
    image(videoFrame, 0, 0, width, height);
  }
  d.beginDraw();
  d.stroke(brushColor);
  d.strokeWeight(brushWeight);
  if (mousePressed) {
    d.line(mouseX, mouseY, pmouseX, pmouseY);
  }
  d.endDraw();
  image(d, 0, 0, width, height);
  if (showColors) {
    image(selector, sx, sy);
  }
}

void keyPressed() {
  if (key == ' ' ) {
    showVideo = !showVideo;
  }
  if (key == 'c') {
    showColors = !showColors;
  }
  if (key == 'b') { brushColor = color(0, 0, 0);  }
  if (key == 'o') { brushColor = color(218, 163, 76);  }
  if (key == 'v') { brushColor = color(106, 57, 146);  }
  if (key == 'p') { brushColor = color(192, 67, 109);  }
  if (key == 'i') { brushColor = color(61, 85, 146);  }
  if (key == '[') { brushWeight--;  println(brushWeight); }
  if (key == ']') { brushWeight++;  println(brushWeight); }
  if (key == 'x') { d.clear(); }
  
  if (key == CODED) {
    if (keyCode == LEFT) {  // Left arrow key
      saveAnimationFrame();
      currentFrame--;
      if (currentFrame < 0) {
        currentFrame = totalFrames - 1;
     
      }
      loadFrame();
      loadDrawing();
    } else if (keyCode == RIGHT) {  // Right arrow key
      saveAnimationFrame();
      currentFrame++;
      if (currentFrame >= totalFrames) {
        currentFrame = 0;
      }
      loadFrame();
      loadDrawing();
    } else if (keyCode == SHIFT) {
      noFill(); stroke(0,255,0); ellipse(mouseX,mouseY,50,50); eraseFunction();
    }
  }
}

void saveAnimationFrame() {
  d.save(drawingPrefix + nf(currentFrame, 4) + ".png");
  // Clear the drawing layer
  d.beginDraw();
  d.clear();
  d.endDraw();
}

void loadFrame() {
  String filename = videoPrefix + nf(currentFrame, 2) + ".png";
  videoFrame = loadImage(filename);
  println(currentFrame + " / " + (totalFrames-1));
}

void loadDrawing() {
  try {
    String filename = drawingPrefix + nf(currentFrame, 4) + ".png";
    drawing = loadImage(filename);
    d.beginDraw();
    d.image(drawing, 0, 0, width, height);
    d.endDraw();
  } 
  catch (Exception e) {
    println("Computer says 'No!' " + e);
  }
}

void mousePressed() {
  if (overSelector()) {
    brushColor = selector.get(mouseX-sx, mouseY-sy);
  }
}

boolean overSelector() {
  if (!showColors) {
    return false;
  }
  if (mouseX > sx && mouseX < sx+selector.width && 
      mouseY > sy && mouseY < sy+selector.height) {
    return true;
  } else {
    return false;
  }
}

void eraseFunction() {
  log(1);
  color c = color(0,0);
  d.beginDraw();
  d.loadPixels();
  for (int x=0; x<d.width; x++) {
    for (int y=0; y<d.height; y++ ) {
      float distance = dist(x,y,mouseX,mouseY);
      if (distance <= 25) {
        int loc = x + y*d.width;
        d.pixels[loc] = c;
      }
    }
  }
  d.updatePixels();
  d.endDraw();
}
