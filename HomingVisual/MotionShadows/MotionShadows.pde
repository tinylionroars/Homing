// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-13: Simple motion detection

import processing.video.*;

Capture video;

int maxPast = 100; //Total # of recorded images

int maxMot = 20; //Total number of frames to be saved at one time

int pastIndex = 0; // Initial image to be recorded

// How different must a pixel be to be a "motion" pixel
float threshold = 50;

PImage[] past = new PImage[maxPast]; //Declaring an array of images

PImage[] motion = new PImage [maxMot]; //

void setup() {
  size(640, 480);
  video = new Capture(this, width, height, 30);
  video.start();
  
  for (int m = 0; m < maxMot; m++) {
    motion[m] = createImage(video.width, video.height, RGB);
  }
  
  //Loading images into the array
  for (int i = 0; i < maxPast; i++) {
    past[i] = loadImage( "doc(" + i + ").jpg" );
    image(past[i], random(-width/2, width/2), random(-height/2, height/2));
  }
  
  frameRate(10);
}

void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  motion[0].copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); // Before we read the new frame, we always save the previous frame for comparison!
  motion[0].updatePixels();  // Read image from the camera
  video.read();
}

void draw() {

  /*DO A THING Make the frame compare loop
      Maybe create a new PImage array of maxMot + 1 for current video frame or + 2 for now
  */ 
  loadPixels();
  video.loadPixels();
  for (int m = 1; m < maxMot; m++) {
    if (m < maxMot - 1) {
      motion[m + 1] = motion[m];
    }
    motion[m] = motion[m - 1];
  }
  for (int m = 0; m < maxMot; m++) {
    motion[m].loadPixels();
  }
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {

      int loc = x + y*video.width;            // Step 1, what is the 1D pixel location
      color now = pixels[loc];
      color current = video.pixels[loc];      // Step 2, what is the current color
      color previous = motion[0].pixels[loc]; // Step 3, what is the previous color

      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float r3 = red(now);
      float g3 = green(now);
      float b3 = blue(now);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // Step 5, How different are the colors?
      // If the color at that pixel has changed, then there is motion at that pixel.
      if (diff > threshold) { 
        // If motion, display current frame
        pixels[loc] = color(r3,g3,b3,20);
      } else {
        // If not, display last frame
        pixels[loc] = color(r1,g1,b1,1);
      }
    }
  }
  updatePixels();
  
  if ((second() % 37) == 0) {
    //Reloads images in array to put newly captured images in projection rotation
    for (int c = 0; c < maxPast; c++) {
      past[c] = loadImage( "doc(" + c + ").jpg" );
    }
    int pastCount = pastIndex++ % maxPast;
    tint(random(60, 255), random(60, 255), random(60, 255), random(150,240)); //Randomizes rgb tint & alpha
    image(past[pastCount], random(-width/2, width/2), random(-height/2, height/2)); //Draws current display image to screen randomly
    //delay(200); //Causes frame to run only 4 times during reference period
    delay(1000);
  }
  //DO A THING establish  a timer for past images to return
}