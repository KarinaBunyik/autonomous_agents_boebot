// VISIBILITY_SLIZES_2_SONARS
// Scan sourounding with two sonars and keep track of the
// direction of the readings. The main goal is to separate
// low obstacles as cylinders from taller ones, such as walls.
//////////// Constants  ////////////////////////////////////////
const double scanPeriod = 1000;      //The temporal length of a sweep
const int sweepCenter = 96;          //middle position of arm
const int sweepAmplitude = 60;       //sweepangle from centre
const int lowPin  = 5;
const int highPin = 6;
const double pi = 3.14159265358979;

////////////  Motors  /////////////////////////////////////////////////////
#include <Servo.h>                           // Include servo library
Servo servoSweep;

////////////  Variables  /////////////////////////////////////////////////////
long lowReadings[2*sweepAmplitude+1] = {0}; //"+1" if floor(140.0)
long highReadings[2*sweepAmplitude+1] = {0}; //"+1" if floor(140.0)
int currState = 1;
long lowValue  = 0;
long highValue = 0;

void setup(){                                // Built-in initialization block
  pinMode(7, INPUT);                         // Centering button
  
  servoSweep.attach(11);    
  Serial.begin(9600);
}  
 
void loop(){
  delay(10);
  double sonarDecay = 1;
  int angleOffset = -600; //-500
  
  highValue = (1-sonarDecay)*highValue + 
                 sonarDecay*readSonar(highPin);
  //if(highValue > 150){
  //  highValue = 300;
  //}
  
  delay(10);
  lowValue = (1-sonarDecay)*lowValue + 
                 sonarDecay*readSonar(lowPin);
  //if(lowValue > 150){
  //  lowValue = 300;
  //}
                 
  delay(10);
  double angleSet = sweepCenter +
                     sweepAmplitude*asin(sin(double(2*pi*millis())/(scanPeriod)))*2/pi;
  
  double angleReal = sweepCenter + 
                     sweepAmplitude*asin(sin(double(2*pi*millis() + angleOffset)/(scanPeriod)))*2/pi;
  servoSweep.write(digitalRead(7) ? angleSet : sweepCenter);
  
  int angle = floor(angleReal)+sweepAmplitude-sweepCenter;
  lowReadings[angle] = lowValue;
  highReadings[angle] = highValue;
  
  Serial.print(angle);
  Serial.print(" ");
  Serial.print(lowValue); 
  Serial.print(" ");
  Serial.println(highValue);  
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


