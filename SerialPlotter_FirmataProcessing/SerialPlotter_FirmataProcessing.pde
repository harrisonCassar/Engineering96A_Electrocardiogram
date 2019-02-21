/*
arduino_input

Demonstrates the reading of digital and analog pins of an Arduino board
running the StandardFirmata firmware.

To use:
* Using the Arduino software, upload the StandardFirmata example (located
  in Examples > Firmata > StandardFirmata) to your Arduino board.
* Run this sketch and look at the list of serial ports printed in the
  message area below. Note the index of the port corresponding to your
  Arduino board (the numbering starts at 0).  (Unless your Arduino board
  happens to be at index 0 in the list, the sketch probably won't work.
  Stop it and proceed with the instructions.)
* Modify the "arduino = new Arduino(...)" line below, changing the number
  in Arduino.list()[0] to the number corresponding to the serial port of
  your Arduino board.  Alternatively, you can replace Arduino.list()[0]
  with the name of the serial port, in double quotes, e.g. "COM5" on Windows
  or "/dev/tty.usbmodem621" on Mac.
* Run this sketch. The squares show the values of the digital inputs (HIGH
  pins are filled, LOW pins are not). The circles show the values of the
  analog inputs (the bigger the circle, the higher the reading on the
  corresponding analog input pin). The pins are laid out as if the Arduino
  were held with the logo upright (i.e. pin 13 is at the upper left). Note
  that the readings from unconnected pins will fluctuate randomly. 
  
For more information, see: http://playground.arduino.cc/Interfacing/Processing
*/

import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

// INSERT CODE //


int pinRAW = 0;
int rawVal;
float x = 0.0;
float lastx = 0;
float lasty = -height/2;

float[] arr = {0,0,0,0,0};
int index = 0;

int THRESH = 170;

float bpm = 0;

boolean haveBeat = false;

float lastBeatTime;
float timeDifference;

void setup() {
  size(1200,800);

  // Prints out the available serial ports.
  println(Arduino.list());
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  // INSERT CODE //
  
  arduino.pinMode(pinRAW,Arduino.INPUT);
  
  background(0,0,0);
  
}

void draw() {
  smooth();
  strokeWeight(3);
  stroke(0,255,0);
  
  //translate(width/2,3*height/4);
  
  translate(0,height);
  
  for (int i=0; i<61; i++) {
    float x = 0.025 * (-pow(i,2) + 40*i + 1200)*sin((PI*i)/180);
    float y = -0.025 * (-pow(i,2) + 40*i + 1200)*cos((PI*i)/180);
    
    x += width - width/30;
    
    y += -height + height/16;
    
    point(x,y); // use these to place your little hearts
    
    x-=(2)*(width-width/30);
    
    point(-x,y); // use these to place your little hearts
  }
  
  strokeWeight(1);
  stroke(150);
  
  //line(0,-height/2,width,-height/2);
  
  fill(0,255,0);
  textSize(32);
  text("BPM",width - width/16,-height + height/10);
  
  strokeWeight(2);
  stroke(0,255,0);
  
  rawVal = arduino.analogRead(pinRAW);
  
  float mappedVal = map(rawVal, 0,850,-1400,800+height);
  //println(mappedVal);
   
  arr[index] = mappedVal;
  
  int lastindex = index-1;
  if (lastindex < 0)
  {
    lastindex = 4;
  }
  int lastlastindex = lastindex-1;
  if (lastlastindex < 0)
  {
    lastlastindex = 4;
  }
  
  //MIGHT NEED TO USE LASTLAST INDEX TOO
  //if (arr[index] - arr[lastindex] < THRESH)
  if ((lasty+mappedVal)*(lasty+mappedVal) > THRESH*THRESH)
  {
    //println("Hello");
    if (haveBeat)
    {
      print("updating bpm: ");
      timeDifference = millis() - lastBeatTime;
      
      timeDifference /= 1000;
      timeDifference /= 60;
      
      bpm = 1/timeDifference;
      println(bpm);
      
      lastBeatTime = millis();
    }
    else
    { 
      haveBeat = true;
      lastBeatTime = millis();
    }
  }
  
  index++;
  
  if (index == 5)
  {
    index = 0;
  }
  
  point(x,-mappedVal);
  //point(x, -height/3);
  
  line(lastx,lasty,x,-mappedVal);
  
  lastx=x;
  lasty=-mappedVal;
  
  int digits = 0;
  int bpmCopy = round(bpm);
  
  do
  {
    bpmCopy /= 10;
    digits++;
  }while (bpmCopy != 0);
  
  //===================================
  strokeWeight(1);
  stroke(150);
  fill(0,255,0);
  textSize(70);
  
  if (digits == 3)
  {
    text(str(round(bpm)),width - width/8,-height + height/5);
  }
  else if (digits == 2)
  {
    text(str(round(bpm)),width - width/12,-height + height/5);
  }
  else if (digits <= 1)
  {
    text(str(round(bpm)),width - width/20,-height + height/5);
  }
  //====================================
  
  x+=3;
  
  if (x >= width)
  {
    background(0,0,0);
    x = 0.0;
    lastx = 0.0;
  }
  

}
