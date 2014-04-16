// The robot returns the sonar readings
//////////// Constants  //////////////////////////////////////////////////
const int speedZero=1500;               //servo speed for zero
const int speedMax=200;                 //The servo number for max
const int speedLeftIsMax = 1;           //if left is higher, set to 1, else -1
const int rotationIterations = 20;     //time to rotate left and then back
const int pingPin = 7;
const double pi = 3.14159265358979;

////////////  Motors  /////////////////////////////////////////////////////
#include <Servo.h>                           // Include servo library
 
Servo servoLeft;                             // Declare left and right servos
Servo servoRight;

////////////  Variables  /////////////////////////////////////////////////////
int sonarReading = 0;
int currState = 0;
int iteration = 0;

void setup(){                                // Built-in initialization block
  pinMode(7, INPUT);                         // Set right sensor pin to input
  pinMode(5, INPUT);                         // Set left sensor pin to input 
  pinMode(4, OUTPUT); 
  
  servoLeft.attach(13);                      // Attach left signal to pin 13
  servoRight.attach(12);                     // Attach right signal to pin 12
  Serial.begin(9600);
}

void loop()
{
  // establish variables for duration of the ping,
  // and the distance result in inches and centimeters:
  long duration, cm;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  cm = microsecondsToCentimeters(duration);
 
  Serial.println(cm);
 
  delay(100);

}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
   
//Sets the spped, input is the speed and should be between -1 and 1
void leftWheel(double sp){ 
  servoLeft.writeMicroseconds(speedZero+(double(speedMax)*sp)*speedLeftIsMax);
}

void rightWheel(double sp){ 
  servoRight.writeMicroseconds(speedZero-double((speedMax)*sp)*speedLeftIsMax);
}
