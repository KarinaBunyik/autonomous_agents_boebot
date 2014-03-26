// Code for controling and getting readings from the Detection Arm
//////////// Parameters  //////////////////////////////////////////////////
const int armCenter = 90;           //middle position of arm
const int maxAngle = 45;            //Range of movement
const int mineSensor = A3;
const int criticalReading = 20;       //Below this reading, mine is assumed
///////////////////////////////////////////////////////////////////////////
#include <Servo.h>                           // Include servo library
 
Servo servoArm;                             // Declare left and right servos

void setup(){                                // Built-in initialization block
  servoArm.attach(11);
  Serial.begin(9600);
}  
 
void loop(){
  double angle = armCenter + maxAngle*sin(double(millis())/300);
  servoArm.write(angle);
  delay(10);
  
  Serial.println(analogRead(mineSensor));
  if(mineSensor < criticalReading) {
    declareMine();
  }
}     

void declareMine() {
  tone(4, 1046, 500);
  delay(500);
  tone(4, 1245, 800);
  delay(800);
  
  for(int i=1;i<100;i++)
  {
    tone(4, 1175-i/2, 10);
    delay(10);
    tone(4, 1175+i/5, 10);
    delay(10);
  }
}

boolean mineSens(){
  return true;
}
