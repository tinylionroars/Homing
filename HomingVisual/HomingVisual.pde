/*Plans for main visuals
Concepts

A. Layering past over present

B. Showing motion

C. Using movement of partitions to switch projection
    (C.1) Allow for displaying multiple sketches?
    (C.2) More than 2 total sketches?
    (C.3) Have partitions connected to wearables? (with code, with strings)



Tech

1. Multiple cameras (A, B, C)

2. Multiple projectors (A, B, C)

3. Image difference (OpenCV)

4. Alphas? (A, B)

5. Convert motion to drawing? (B)

6. Marker Detection (OpenCV) (C)



Inspiration/Resources

a. Cadence Daniels' motion tracking Preamble: https://github.com/cadencedaniels/Interactive-Installations-DM-GY-9103-

b. OpenCV marker detection Processing example: https://github.com/atduskgreg/opencv-processing/tree/master/examples/MarkerDetection

c. OpenCV marker detection concepts: https://docs.opencv.org/3.1.0/d5/dae/tutorial_aruco_detection.html

d. Learning Processing by Daniel Shiffman motion sensor: https://github.com/shiffman/LearningProcessing/blob/master/chp16_video/example_16_14_MotionSensor/example_16_14_MotionSensor.pde

e. Learning Processing by Daniel Shiffman motion pixels: https://github.com/shiffman/LearningProcessing/blob/master/chp16_video/example_16_13_MotionPixels/example_16_13_MotionPixels.pde

f. How We Exist Here by me: https://github.com/tinylionroars/HowWeExistHere/blob/master/displaySaveFrame/displaySaveFrame.pde
*/

import processing.video.*;


Capture video;


//int fuck = 0; //For testing a particularly annoying bug

int maxImages = 10; // Total # of recorded images

int maxFile = 1000; //Total # of documented images



int imageIndex = 0; // Initial image to be recorded

int dispIndex = 0; //Initial image to be referenced

int fileIndex = 0; //Initial image to be saved



PImage[] images = new PImage[maxImages]; //Declaring an array of images

//Line below written by Hyacinth Nil
String[] fileNames = new String[maxFile]; //Declaring an array for images to document


void setup () {
    size(1920, 1080); 

  //Loading images into the array
  for (int i = 0; i < maxImages; i++) {
    images[i] = loadImage( "doc(" + i + ").jpg" );
    image(images[i], random(-width/2, width/2), random(-height/2, height/2));
  }
  
  //Loop below written by Hyacinth Nil, based on recommendation by Katherine Bennett
  //Creating an array of strings which will name documentation images
  for(int f = 0; f < fileNames.length; f++){
    fileNames[f] = "doc(" + f + ").jpg";
  }
  
}

void draw () {
  
  //DO A THING Make This code run every few minutes instead
  //Display random images, preferably with deference to more recently saved images (DONE?)
  //Creates a conditional which runs every 3 seconds
  if ((second() % 3) == 0) {
    //Reloads images in array to put newly captured images in projection rotation
    for (int i = 0; i < maxImages; i++) {
      images[i] = loadImage( "doc(" + i + ").jpg" );
    }
    tint(random(60, 255), random(60, 255), random(60, 255), random(150,240)); //Randomizes rgb tint & alpha
    image(images[dispIndex], random(-width/2, width/2), random(-height/2, height/2)); //Draws current display image to screen randomly
    delay(200); //Causes frame to run only 4 times during reference period
    dispIndex = (fileIndex - int(random(0, fileIndex)));
  }

  
  
  //DO A THING Establish a conditional that stops saving frames if motion idles, doesn't track static scene
  //DO A THING Make it save an image every few minutes instead of once per minute
    int fileCount = second() % 28; //Reference timer for taking new documentation images

    //Creates conditional which runs every reference time
    if ((fileCount % 28) == 0){
      saveFrame(fileNames[fileIndex]); //Saves current frame to output file
      fileIndex++; //Increases fileIndex every time conditional is called
      delay(1000); //Makes conditional run only once per reference time
    }
  
  //DO A THING all the motion tracking code lmao
  
}
