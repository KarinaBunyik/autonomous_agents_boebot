// IDENTIFY_CLOSEST_OBJECT
// - Scan left and right using 2 sonars.
// - One scan is to go from -50->50 or vice versa.
// - Identify and approximate center of the closest object.
// RETURN:  objectVector
//          r - Distance to closest object
//          a - Angle to closest object, Span=[-aMax,+aMax]
//          t - Type of object, 0:Cylinder, 1:Obstacle
//////////// Constants  ////////////////////////////////////////
const int scanIterations = 20;      //How many measurements to
                                     //take for each scan
                                     
const int angleCorrection = 90;      //Middle position of scanners

const int angleMax = 40;             //Maxangle from centre

const int distTol = 5;               //How many cm a reading may
                                     //differ while still be
                                     //regarded the same object.
const int highPin = 5;
const int lowPin  = 6;
const double pi = 3.14159265358979;

////////////  Motors  ////////////////////////////////////
#include <Servo.h>                   // Include servo library
Servo servoSweep;

////////////  Variables  /////////////////////////////////
int objectVector[3] = {350,0,0};
int minReadLow  = 350;                      //Min reading for sensor...
int minReadHigh = 350;                     //...current scan
int angleOneObject;                  // First side of object
int angleTwoObject;                  // Second side of object
boolean increasing = true;           // true:  -maxA -> +maxA
                                     // false: +maxA -> -maxA
int currState = 1;
int iteration = scanIterations/2;    // Iteration in current scan
int lowValue  = 350;                   // Current reading
int highValue = 350;                   // Current reading
double angleStep;

void setup(){                        // Built-in initialization 
                                     // block
  pinMode(7, INPUT);                 // Centering button
  
  servoSweep.attach(11);    
  Serial.begin(9600);
  
  angleStep = double(2*angleMax)/scanIterations;
}  
 
void loop(){
  
  double setAngle = iteration*angleStep - angleMax;
  
  servoSweep.write(digitalRead(7) ? 
                angleCorrection + setAngle : angleCorrection);
  delay(5);
  
  // Current readings
  highValue = readSonar(highPin);
  lowValue  = readSonar(lowPin);
  
  // Object begins
  if(lowValue < minReadLow) {
    minReadLow = lowValue;
    angleOneObject = setAngle;// Change later to find both sides
    
    if(lowValue < objectVector[0]) {
      objectVector[0] = lowValue;
      objectVector[1] = setAngle;
    }
  }


  // Updae angle state
  if(increasing) {
    iteration = iteration + 1;
  }
  else {
    iteration = iteration - 1;
  }

  Serial.print(setAngle);
  Serial.print(" ");
  Serial.print(lowValue); 
  Serial.print(" ");
  Serial.println(highValue);
  
  // Start new scan if end is reached
  if(iteration <= 0 || iteration >= scanIterations){
    //Serial.print(objectVector[0]);
    //Serial.print(" ");
    //Serial.println(objectVector[1]);
    
    increasing = !increasing;
    objectVector[0] = lowValue;
    objectVector[1] = angleOneObject;
    minReadLow  = 350;
    minReadHigh = 350;
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


