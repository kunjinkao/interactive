/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/87338*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float d;
float red;
float green;
float blue;
float factor;
float x, y;
float text_x, text_y = -5;

//stauts code to determine action
int status=0;
int red_offset;
int green_offset;

//radius of the mouse...will explain more later
int rad;

void setup() {
  frameRate(40);
//  colorMode(HSB, 255);
  size(1000,650);  
  background(0);
  
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("",57120);
  
  oscP5.plug(this,"update","/update"); //bind address to function
  oscP5.plug(this,"resume","/resume"); //bind address to function
  oscP5.plug(this,"pause","/pause"); //bind address to function
  oscP5.plug(this,"kill","/stop"); //bind address to function
  // smooth();
}

void draw() {
  switch (status) {
    case 0:
      println("resume");
      draw_glich();
      break;
    case 1:
      println("pause");
      showInstruction();
      break;
    case 2:
      println("stop");
      showError();
      break;
  }
}

void draw_glich() {
  println("draw glich.");
  loadPixels();
  //loop to go through every pixel, i=y value, j=x value
  for(int i=0;i<height;i++){
    for(int j=0;j<width;j++){
      
        
        //grabs pixel's current color
        color c = pixels[i*width+j];
        
        //the actual glitch! <<number and & 0xff mess 
        //with the binary code and completely destroy the colors
        //very fun to mess around with. dont be afraid to tweak!        
        red = c << red_offset & 0xff;
        green = c << green_offset & 0xaa;
        blue = c  & 0xff;
        
        //gets distance from mouse to pixel
        //the *.4 at the end changes the "saving" area of effect:
        //when the mouse is at rest and the colors dont change.
        //higher value = smaller area
        d =dist(x,y,j,i)*factor;
       
        //make the colors change depending on distance to mouse       
        //rad = radius of the innermost circle
        red += 50/d-rad;
        green += 50/d-rad;
        blue += 50/d-rad;
          
        //changes the pixel to the glitched pixel
        pixels[i*width+j]=color(red,green,blue);
       
    }
  }
  
   updatePixels();

}

void showError() {
  fill(0,255,0); 
  textSize(20); 
  textAlign(LEFT);
  text("Warning: System Error!", text_x, text_y);
  text_y += 25;
  if(text_y >= height) {
    text_x += 70;
    text_y = -5;
  }
}

void showInstruction() {
  background(0);
  fill(255);
  textSize(40);
  textAlign(CENTER);
  text("connect to wifi named 'kunjinkao' and ", width/2, height/2-35);
  text("open '192.168.1.100:8000' in your browser", width/2, height/2+35);
  noLoop();
}

void keyPressed() {
  if(key == 'p' || key == 'P') {
    pause();
  } else if (key == 'r' || key == 'R') {
    resume();
  } else if (key == 's' || key == 'S') {
    background(0);
    kill();
  }
}

public void update(float _x, float _y, float _z, float alpha, float beta, float gamma) {
  x = map(alpha, 0, 1, 0, width);
  y = map(beta, 0, 1, height, 0);
  rad = int(gamma + 1);
  red_offset = int(map(_x, 0, 1, 0, 7));
  green_offset = int(map(_y, 0, 1, 2, 0));
  factor = _z ;
  println("received data from sean.");
}

public void resume( ){
  status = 0;
  fill(0);
  rect(0,0,width,height);
  loop();
}

public void pause( ){
  status = 1;
}

public void kill(){
  status = 2;  
} 

void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.isPlugged()==false) { // not bind to a responder
    print(" addrpattern: "+theOscMessage.addrPattern());
    println(" typetag: "+theOscMessage.typetag());
  }
}
