// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com

// Example 16-13: Simple motion detection

import processing.video.*;
import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;



//Serial myPort;  // Create object from Serial class
//int val;      // Data received from the serial port

//Arduino arduino;

Capture video;

PImage prev;

int maxMot = 20; //Total number of frames to be saved at one time

PImage[] motion = new PImage [maxMot]; //

int maxPast = 100; //Total # of recorded images
int pastIndex = 0; // Initial image to be displayed

PImage[] past = new PImage[maxPast]; //Declaring an array of images

int maxFile = 100; //Total # of documented images
int fileIndex = 0; //Initial image to be saved

//Line below written by Hyacinth Nil
String[] fileNames = new String[maxFile]; //Declaring an array for images to document


// How different must a pixel be to be a "motion" pixel
float threshold = 50;

void setup() {
  size(1280, 720);
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + cameras[i]);
    }
  }
  
  video = new Capture(this, cameras[0]); //works at 10fps cameras[4] but not 30fps cameras [0] on my laptop
  video.start();

  //myPort = new Serial(this, "COM7", 9600);
  //arduino = new Arduino(this, "COM7(Arduino/Genuino Mega or Mega 2560)", 9600);
  //arduino.pinMode(4, Arduino.INPUT);

  prev = createImage(width, height, RGB);

  /*
  for (int m = 0; m < maxMot; m++) {
    motion[m] = createImage(video.width, video.height, RGB);
  }
  */


  //Loading images into the array
  for (int i = 0; i < maxPast; i++) {
    past[i] = loadImage( "doc(" + i + ").jpg" );
    image(past[i], random(-width/2, width/2), random(-height/2, height/2));
  }

  //frameRate(10);
  
  //Loop below written by Hyacinth Nil, based on recommendation by Katherine Bennett
  //Creating an array of strings which will name documentation images
  for(int f = 0; f < fileNames.length; f++){
    fileNames[f] = "data/doc(" + f + ").jpg";
  }
  
}

void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  //motion[0].copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height); // Before we read the new frame, we always save the previous frame for comparison!
  //motion[0].updatePixels();  // Read image from the camera
  video.read();
  prev.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prev.updatePixels();
}

void draw() {
  /* CODE FOR GSR
   if ( myPort.available() > 0) {  // If data is available,
   val = myPort.read();         // read it and store it in val
   }
   float alpha = map(val, 0, 1000, 0, 100);
   int(alpha);
   */
  /*DO A THING Make the frame compare loop
   Maybe create a new PImage array of maxMot + 1 for current video frame or + 2 for now
   */

  loadPixels();
  video.loadPixels();
  prev.loadPixels();
  
  /*
  for (int m = 1; m < maxMot; m++) {
    if (m < maxMot - 1) {
      motion[m + 1] = motion[m];
    }
    motion[m] = motion[m - 1];
  }
  for (int m = 0; m < maxMot; m++) {
    motion[m].loadPixels();
  }
  */
  
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {

      int loc = x + y*video.width;            // what is the 1D pixel location
      color now = pixels[loc];                //what is the current frame color
      color current = video.pixels[loc];      //what is the current color
      color previous = prev.pixels[loc];      //what is the previous color
      
      //compare colors (previous vs. current)
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

      //How different are the colors?
      //If the color at that pixel has changed, then there is motion at that pixel.
      
      //toggle to capture current video frame or to run motion sketch
      if (mousePressed == true) { //arduino.digitalRead(4) == Arduino.LOW || 
        pixels[loc] = color(r1, g1, b1);
      } else {
        if (diff > threshold) { 
          // If motion, display current frame
          pixels[loc] = color(r3, g3, b3, 20);
        } else {
          // If not, display last frame
          pixels[loc] = color(r1, g1, b1, 2);
        }
      }
    }
  }
  updatePixels();

  if ((second() % 15) == 0) {
    //Reloads images in array to put newly captured images in projection rotation
    for (int c = 0; c < maxPast; c++) {
      past[c] = loadImage( "doc(" + c + ").jpg" );
    }
    int pastCount = pastIndex++ % maxPast;
    tint(random(60, 255), random(60, 255), random(60, 255), random(150, 240)); //Randomizes rgb tint & alpha
    image(past[pastCount], random(-width/2, width/2), random(-height/2, height/2)); //Draws current display image to screen randomly
    //delay(200); //Causes frame to run only 4 times during reference period
    delay(1000);
  }
  
  if ((second() % 21) == 0) {
    saveFrame(fileNames[fileIndex]); //Saves current frame to output file
    fileIndex++; //Increases fileIndex every time conditional is called
    /*
    println("fuck is " + fuck); //Prints if conditional is met
    fuck++; //Increases fuck every time conditional is called
    */
    delay(1000); //Makes conditional run only once per reference time
  }
  //DO A THING establish  a timer for past images to return
}
