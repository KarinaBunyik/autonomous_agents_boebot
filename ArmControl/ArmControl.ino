// Code for controling and getting readings from the Detection Arm
//////////// Parameters  //////////////////////////////////////////////////
const int armCenter = 90;           //middle position of arm
const int maxAngle = 60;            //Range of movement
const int mineSensor = A3;
const int criticalReading = 20;       //Below this reading, mine is assumed
///////////////////////////////////////////////////////////////////////////
#include <Servo.h>                           // Include servo library
 
Servo servoArm;                              // Declare left and right servos

void setup(){                                // Built-in initialization block
  servoArm.attach(11);
  pinMode(7, INPUT);                         // Set right sensor pin to input
  pinMode(5, INPUT);                         // Set left sensor pin to input
  Serial.begin(9600);
}  
 
void loop(){
  int irLeft = 1-irDetect(9, 10, 38000);       // Check for objects on left
  int irRight = 1-irDetect(2, 3, 38000);       // Check for objects on right
  Serial.print(irLeft);
  Serial.println(irRight);
 
  double angle = armCenter + maxAngle*sin(double(millis())/1000);
  servoArm.write(angle);
  delay(10);
  
  //Serial.println(analogRead(mineSensor));
  //if(mineSensor < criticalReading) {
  //  declareMine();
  //}
}     

void declareMine() {
  tone(4, 1046, 500);
  delay(500);
//  tone(4, 1245, 800);
//  delay(800);
//  
//  for(int i=1;i<100;i++)
//  {
//    tone(4, 1175-i/2, 10);
//    delay(10);
//    tone(4, 1175+i/5, 10);
//    delay(10);
//  }
}

boolean mineSens(){
  return true;
}

int irDetect(int irLedPin, int irReceiverPin, long frequency)
{
  tone(irLedPin, frequency, 8);              
  delay(1);                                  
  int ir = digitalRead(irReceiverPin);       
  delay(1);                                  
  return ir;                                 
}
