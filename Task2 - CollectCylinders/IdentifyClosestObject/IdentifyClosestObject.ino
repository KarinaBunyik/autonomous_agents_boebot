// IDENTIFY_CLOSEST_OBJECT
// - Scan left and right using 2 sonars.
// - One scan is to go from -50->50 or vice versa.
// - Identify and approximate center of the closest object.
// RETURN:  2 object vectors (one high, one low)
//          r - Distance to closest object
//          a - Angle to closest object, Span=[-aMax,+aMax]
//////////// Constants  ////////////////////////////////////////
const int nScanSteps = 20;          //How many measurements to
                                     //take for each scan
                                     
const int angleCorrection = 90;      //Middle position of scanners

const int angleMax = 40;             //Maxangle from centre

const int distTol = 5;               //How many cm a reading may
                                     //differ while still be
                                     //regarded the same object.
const int s1_pin = 6;                // Low Sensor
const int s2_pin = 5;                // High Sensor
const double pi = 3.14159265358979;

////////////  Motors  ////////////////////////////////////
#include <Servo.h>                   // Include servo library
Servo servoScan;

////////////  Variables  /////////////////////////////////
int s1_objectVector[2] = {400,0};
int s2_objectVector[2] = {400,0};

int s1_tmpMin = 400;              //Min reading for sensor...
int s2_tmpMin = 400;              //...current scan

int s1_objSide1;                  // First side of object
int s1_objSide2;                  // Second side of object
int s2_objSide1;
int s2_objSide2;

double angleStep;
boolean increasing = true;           // true:  -maxA -> +maxA
                                     // false: +maxA -> -maxA
int iteration = nScanSteps/2;    // Iteration in current scan
int s1_reading = 400;                 // Current reading
int s2_reading = 400;
int s1_old  = 400;                 // remember old minimum.
int s2_old  = 400;

void setup(){                        // Built-in initialization 
                                     // block
  pinMode(7, INPUT);                 // Centering button
  
  servoScan.attach(11);    
  Serial.begin(9600);
  
  angleStep = double(2*angleMax)/nScanSteps;
}  
 
void loop(){
  
  double setAngle = iteration*angleStep - angleMax;
  
  servoScan.write(digitalRead(7) ? 
                angleCorrection + setAngle : angleCorrection);
  
  // Current readings
  delay(10);
  s2_reading = readSonar(s2_pin);
  delay(10);
  s1_reading  = readSonar(s1_pin);
  
  
  //------------ SCANNER 1 ------------\\
  // Object begins
  if(s1_reading < s1_tmpMin - distTol) {
    // Define new minima, first side found
    s1_tmpMin = s1_reading;
    s1_objSide1 = setAngle;
    s1_objSide2 = setAngle;
    
    if(s1_reading < s1_objectVector[0] - distTol) {
      // Closest thing spotted, imedietly update vector
      s1_old = s1_objectVector[0];
      s1_objectVector[0] = s1_reading;
      s1_objectVector[1] = setAngle;
    }
  }
  else if(s1_reading < s1_objectVector[0] - distTol &&
          s1_reading < s1_old - distTol) {
    // Still at closest object ever
    s1_objSide2 = setAngle;
    s1_objectVector[1] = int((s1_objSide1 + s1_objSide2)/2);
  }
  else if(s1_reading < s1_tmpMin + distTol) {
    // Still at closest object this round
    s1_objSide2 = setAngle;
  }

  //------------ SCANNER 2 ------------\\
  // Object begins
  if(s2_reading < s2_tmpMin - distTol) {
    // Define new minima, first side found
    s2_tmpMin = s2_reading;
    s2_objSide1 = setAngle;
    s2_objSide2 = setAngle;
    
    if(s2_reading < s2_objectVector[0] - distTol) {
      // Closest thing spotted, imedietly update vector
      s2_old = s2_objectVector[0];
      s2_objectVector[0] = s2_reading;
      s2_objectVector[1] = setAngle;
    }
  }
  else if(s2_reading < s2_objectVector[0] - distTol &&
          s2_reading < s2_old - distTol) {
    // Still at closest object ever
    s2_objSide2 = setAngle;
    s2_objectVector[1] = int((s2_objSide1 + s2_objSide2)/2);
  }
  else if(s2_reading < s2_tmpMin + distTol) {
    // Still at closest object this round
    s2_objSide2 = setAngle;
  }

  //------------ End Scanners ------------\\
  
  // Updae angle state
  if(increasing) {
    iteration = iteration + 1;
  }
  else {
    iteration = iteration - 1;
  }

  Serial.print(int(setAngle + angleMax + 1));
  Serial.print(" ");
  Serial.print(s1_reading); 
  Serial.print(" ");
  Serial.print(s2_reading);
  Serial.print(" ");
  Serial.print(s1_objectVector[0]);
  Serial.print(" ");
  Serial.print(s1_objectVector[1]);
  Serial.print(" ");
  Serial.print(s2_objectVector[0]);
  Serial.print(" ");
  Serial.println(s2_objectVector[1]);
  
  // Start new scan if end is reached
  if(iteration <= 0 || iteration >= nScanSteps){
    
    increasing = !increasing;
    s1_objectVector[0] = s1_tmpMin;
    s2_objectVector[0] = s2_tmpMin;
    s1_objectVector[1] = int((s1_objSide1 + s1_objSide2)/2);
    s2_objectVector[1] = int((s2_objSide1 + s2_objSide2)/2);
    
    int tmp = s1_objSide1;
    s1_objSide1 = s1_objSide2;
    s1_objSide2 = tmp;
    
    tmp = s2_objSide1;
    s2_objSide1 = s2_objSide2;
    s2_objSide2 = tmp;
    
    s1_tmpMin  = 400;
    s2_tmpMin  = 400;
    // Reset things for new scan
  }    
// End of loop, but code is keept for the moment...
}     

long readSonar(int pin) {
  // establish variables for duration of the ping,
  // and the distance result in inches and centimeters:
  long duration, cm;
  
  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pin, OUTPUT);
  digitalWrite(pin, LOW);
  delayMicroseconds(2);
  digitalWrite(pin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pin, INPUT);
  duration = pulseIn(pin, HIGH);

  // convert the time into a distance
  cm = microsecondsToCentimeters(duration);
  
  return cm;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}


