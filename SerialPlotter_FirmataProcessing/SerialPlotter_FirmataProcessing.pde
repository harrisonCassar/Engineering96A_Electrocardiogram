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

int pinLED = 11;
int pinPOT = 0;
int potVal;
float x = 0.0;
float lastx = 0;
float lasty = -height/2;

void setup() {
  size(1200,800);

  // Prints out the available serial ports.
  println(Arduino.list());
  
  // Modify this line, by changing the "0" to the index of the serial
  // port corresponding to your Arduino board (as it appears in the list
  // printed by the line above).
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  
  // INSERT CODE //
  
  arduino.pinMode(pinLED,Arduino.OUTPUT);
  arduino.pinMode(pinPOT,Arduino.INPUT);
  
  arduino.digitalWrite(pinLED, Arduino.HIGH);
  
  background(255,127,127);
}

void draw() {
  translate(0,height);
  strokeWeight(2);
  
  potVal = arduino.analogRead(pinPOT);
  
  float mappedVal = map(potVal, 0,850,-1400,800+height);
  println(mappedVal);
  
  point(x,-mappedVal);
  
  line(lastx,lasty,x,-mappedVal);
  
  lastx=x;
  lasty=-mappedVal;
  
  x+=3;
  
  if (x >= width)
  {
    background(255,127,127);
    x = 0.0;
    lastx = 0.0;
  }
  
  // INSERT CODE //

}
