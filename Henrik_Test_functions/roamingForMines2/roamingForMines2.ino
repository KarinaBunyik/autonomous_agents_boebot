// Robotics with the BOE Shield - RoamingWithWhiskers
// Go forward.  Back up and turn if whiskers indicate BOE Shield bot bumped
// into something.
//////////// Parameters  //////////////////////////////////////////////////
const int speedZero=1500;           //servo speed for zero
const int speedMax=200;             //The servo number for max
const double armPeriod = 1000;
const int speedLeftIsMax=1;        //if left is higher, set to 1, else -1
const int minePin=A3;
const int maxAngle = 80;            //Range of movement
const int armCenter = 90;           //middle position of arm
const int noOfSlices = 3;           //Mustn't be changed from 3
const double pi = 3.14159265358979;
//dt=1;//miliseconds
///////////////////////////////////////////////////////////////////////////
#include <Servo.h>                           // Include servo library
 
Servo servoLeft;                             // Declare left and right servos
Servo servoRight;
Servo servoArm;
double visibilitySlices[] = {0, 0, 0};
double sliceCoverage = (2*maxAngle)/noOfSlices;
double sliceDecay = 0.5;
int currState = 0;
unsigned long time;
unsigned long dt;
unsigned long startTime;
int mineSensor;
int minePrevSensor;
unsigned long timer(boolean set = false);
double rightRead;            // slice value right
double centreRead;           // ...centre...
double leftRead;             // ...right...
double treshold = 0.4;       // How large a slice value must be not to be ignored

void setup(){                                 // Built-in initialization block
  pinMode(7, INPUT);                         // Set right sensor pin to input
  pinMode(5, INPUT);                         // Set left sensor pin to input 
  
  servoArm.attach(11);    
  servoLeft.attach(13);                      // Attach left signal to pin 13
  servoRight.attach(12);                     // Attach right signal to pin 12
  Serial.begin(9600); 
}  
 
void loop(){
  delay(10);
  //debugWrite(currState);
  //Serial.print("state = ");                     // Display "A3 = "
  //Serial.println(currState);                    // Display measured A3 volts
  dt=millis()-time;
  time = millis();
  

  int irArm = 1 - irDetect(2, 3, 38000);       // Check for objects on left

  //Serial.print("irArm = ");
  //Serial.println(irArm);
  
  double angle = armCenter + maxAngle*sin(double(2*pi*millis())/(armPeriod));
  servoArm.write(angle);
  

  if ((angle > maxAngle + armCenter - sliceCoverage ) && (angle <= maxAngle + armCenter)){
    // Right slice
    visibilitySlices[0] = sliceDecay*double(irArm) + (1-sliceDecay)*visibilitySlices[0];
  }
  else if ((angle > maxAngle + armCenter - 2*sliceCoverage ) && (angle <= maxAngle + armCenter - sliceCoverage )){
    // Middle slice
    visibilitySlices[1] = sliceDecay*double(irArm) + (1-sliceDecay)*visibilitySlices[1];
  }
  else if ((angle > armCenter - maxAngle) && (angle <= maxAngle + armCenter - sliceCoverage )){
    // Left slice
    visibilitySlices[2] = sliceDecay*double(irArm) + (1-sliceDecay)*visibilitySlices[2];
  }
  else{
  }
  
  //Serial.println(currState);
  //Start of statemachine
  
  switch (currState){
      case 0:
        //Some init that we may need to redo here
        // for now, keep empty
        
        rightRead = visibilitySlices[0];
        centreRead = visibilitySlices[1];
        leftRead = visibilitySlices[2];
        
        if(rightRead < treshold){
           rightRead = 0; 
        }
        if(centreRead < treshold){
           centreRead = 0; 
        }
        if(leftRead < treshold) {
           leftRead = 0; 
        }
        
        Serial.print(centreRead);
        Serial.print("  ");
        Serial.print(centreRead);
        Serial.print("  ");
        Serial.println(rightRead);
        
        rightWheel((1+treshold-centreRead)*(1-1.5*rightRead));
        leftWheel((1+treshold-centreRead)*(1-1.5*leftRead));
        break;
      case 1:
        forward();
        currState=2;
        break;
      case 2: //idle state
          if ((visibilitySlices[0] <= 0.1) && (visibilitySlices[2] <= 0.1)){        // If both sensors have input
            //Serial.println("both");
            backward();
            timer(true);
            currState=3;
          }else if (visibilitySlices[0] <= 0.1){                        // If only left whisker contact
            //Serial.println("left");
            turnRight();
            //timer(true);
            currState=5;
          }else if (visibilitySlices[2] <= 0.1){                       // If only right whisker contact
            //Serial.println("right");
            turnLeft();
            //timer(true);
            currState=5;
          }else if (mineSens()){
            //Serial.println("MINE!!!");
            tone(4, 3000, 1000);
            backward();
            timer(true);
            currState=3;
          }
          break;
       case 3:
         if (timer() > 500){     // If both sensors have no input
           timer(true);
           turnLeft();
           currState=4;
         }
         break;  
      case 4:
         if (timer() > 400){     // If both sensors have no input
           currState=1;
         }
         break;  
      case 5:
         if ((visibilitySlices[0] >= 0.9) && (visibilitySlices[2] >= 0.9)){     // If both sensors have no input
           currState=1;
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

void forward(){
  leftWheel(1);
  rightWheel(1);
}

void turnLeft(){
  leftWheel(-1);
  rightWheel(1);
}

void turnRight(){
  leftWheel(1);
  rightWheel(-1);                            
}

void backward(){
  leftWheel(-1);
  rightWheel(-1);
}


//If arg1 is true, the timer will be reset. else, return time in ms since last reset
              
unsigned long timer(boolean set){
  if (set) {
    startTime=time;
    return 0;
  }else{
    return time-startTime;
  }
}

int irDetect(int irLedPin, int irReceiverPin, long frequency){
  tone(irLedPin, frequency, 8);              
  delay(1);                                  
  int ir = digitalRead(irReceiverPin);       
  delay(1);                                  
  return ir;                                 
}

boolean mineSens(){
  mineSensor=analogRead(minePin);
  if (minePrevSensor - mineSensor > 10){
    minePrevSensor=mineSensor;
    return true;
  }else{
    minePrevSensor=mineSensor;
    return false;
  }
}


