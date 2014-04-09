// ROAMING FOR MINES
// A basic behaviour for roming about, avoiding mines and
// walls, while giving a sound in case of a mine.
//////////// Constants  //////////////////////////////////////////////////
const int speedZero=1500;           //servo speed for zero
const int speedMax=100;             //The servo number for max
const double armPeriod = 1000;      //The time to finish an arm sweep
const int speedLeftIsMax = 1;        //if left is higher, set to 1, else -1
const int minePin = A3;
const int criticalReading = 7;//15;    //Below this reading mine is declared 
const int rotationTime = 1000;     // If a mine is critically close, rotate for this time
const int maxAngleSet = 70;            //Range of arm movement
const int armCenter = 90;           //middle position of arm
const double pi = 3.14159265358979;

////////////  Motors  /////////////////////////////////////////////////////
#include <Servo.h>                           // Include servo library
 
Servo servoLeft;                             // Declare left and right servos
Servo servoRight;
Servo servoArm;

////////////  Variables  /////////////////////////////////////////////////////
double visibilitySlices[] = {0, 0, 0};
double irReading = 0.0;
double irDecay = 1;
double sliceDecay = 0.4;
double sliceDecaySlow = 0.15;
int currState = 1;
unsigned long time;
unsigned long startTime;
int mineSensor;
int minePrevSensor;
double rightRead;            // slice value right
double centreRead;           // ...centre...
double leftRead;             // ...right...

void setup(){                                // Built-in initialization block
  pinMode(7, INPUT);                         // Set right sensor pin to input
  pinMode(5, INPUT);                         // Set left sensor pin to input 
  pinMode(4, OUTPUT); 
  
  servoArm.attach(11);    
  servoLeft.attach(13);                      // Attach left signal to pin 13
  servoRight.attach(12);                     // Attach right signal to pin 12
  Serial.begin(9600);
}  
 
void loop(){
  delay(1);
  irReading = (1 - irDecay)*irReading + irDecay*(1 - irDetect(2, 3, 38000)); // Check for obstacles with IR
  double readingArm = irReading;
  //Serial.println(irReading);
  
  mineSensor = analogRead(minePin);         // Is a mine spotted?
  if(mineSensor < criticalReading) {
    readingArm = 1;                                 // A mine is spotted
    tone(4,200,10);
  }

  Serial.println(mineSensor);
  
  double angleSet = armCenter + maxAngleSet*sin(double(2*pi*millis())/(armPeriod));
  double angleReal = armCenter + maxAngleSet*sin(double(2*pi*(millis()-100))/(armPeriod));

  servoArm.write(digitalRead(7) ? angleSet : armCenter);

  if (angleReal > 90 + 30) {
    // Left slice
    visibilitySlices[0] = sliceDecay*double(readingArm) + (1-sliceDecay)*visibilitySlices[0];
  }
  else if (angleReal < 90 - 30) {
    // Right slice
    visibilitySlices[2] = sliceDecay*double(readingArm) + (1-sliceDecay)*visibilitySlices[2];
  }
  else {
    // Middle slice
    if(readingArm == 1) {
      visibilitySlices[1] = sliceDecay*double(readingArm) + (1-sliceDecay)*visibilitySlices[1];
    }
    else {
      visibilitySlices[1] = sliceDecaySlow*double(readingArm) + (1-sliceDecaySlow)*visibilitySlices[1];
    }
  }
  
  rightRead = visibilitySlices[2];
  centreRead = visibilitySlices[1];
  leftRead = visibilitySlices[0];

/*
  Serial.print(leftRead);
  Serial.print("  ");
  Serial.print(centreRead);
  Serial.print("  ");
  Serial.println(rightRead);
*/
  
  switch (currState){
      case 1:

        if(centreRead < 0.5){//((mineSensor > criticalReading) || (centreRead < 0.5)){
          rightWheel(1-leftRead);
          leftWheel(1-rightRead);
          //rightWheel((1-centreRead)*(1-leftRead));
          //leftWheel((1-centreRead)*(1-rightRead));
        }
        else {
          currState = 2;
        }
        break;
        
      case 2:
      
        if(leftRead < rightRead){
          rightWheel(1);
          leftWheel(-1);
        }
        else {
          rightWheel(-1);
          leftWheel(1);
        }
        
        currState = 3;
        
      break;
      case 3:
        
        if(centreRead < 0.2){
          currState = 1;
        } 
      break;
    }     
    
}     

//Sets the spped, input is the speed and should be between -1 and 1
void leftWheel(double sp){ 
  servoLeft.writeMicroseconds(speedZero+(double(speedMax)*sp)*speedLeftIsMax);
}

void rightWheel(double sp){ 
  servoRight.writeMicroseconds(speedZero-double((speedMax)*sp)*speedLeftIsMax);
}

int irDetect(int irLedPin, int irReceiverPin, long frequency){
  tone(irLedPin, frequency, 8);              
  delay(1);                                  
  int ir = digitalRead(irReceiverPin);       
  delay(1);                                  
  return ir;                                 
}



