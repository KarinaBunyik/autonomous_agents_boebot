// VISIBILITY_SLIZES_1_SONAR
// Scan sourounding with one sonar and keep track of the
// direction of the readings. Later bundle them together into
// three main visibility slizes (as in task 1)
//////////// Constants  ////////////////////////////////////////
const double scanPeriod = 2000;      //The temporal length of a sweep
const int sweepCenter = 96;          //middle position of arm
const int sweepAmplitude = 60;       //sweepangle from centre
const int sonarPin = 6;
const double pi = 3.14159265358979;

////////////  Motors  /////////////////////////////////////////////////////
#include <Servo.h>                           // Include servo library
Servo servoSweep;

////////////  Variables  /////////////////////////////////////////////////////
long readingFromAngle[2*sweepAmplitude+1] = {0}; //"+1" if floor(140.0)
int currState = 1;
int iteration = 0;
double rightRead;            // slice value right
double centreRead;           // ...centre...
double leftRead;             // ...right...
long sonarReading = 0;

void setup(){                                // Built-in initialization block
  pinMode(7, INPUT);                         // Set right sensor pin to input
  pinMode(5, INPUT);                         // Set left sensor pin to input 
  pinMode(4, OUTPUT); 
  
  servoSweep.attach(11);    
  Serial.begin(9600);
}  
 
void loop(){
  delay(1000);
  double sonarDecay = 1;
  int angleOffset = -500;
  
  sonarReading = (1-sonarDecay)*sonarReading + sonarDecay*readSonar(sonarPin);

  double angle = sweepCenter +
                     sweepAmplitude*asin(sin(double(2*pi*iteration)/12))*2/pi;
  iteration = iteration + 1;

  servoSweep.write(digitalRead(7) ? angle : sweepCenter);
  
  int angleOut = floor(angle)+sweepAmplitude-sweepCenter;
  readingFromAngle[angleOut] = sonarReading;
  
  Serial.print(angleOut);
  Serial.print(" ");
  Serial.println(sonarReading);  
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


