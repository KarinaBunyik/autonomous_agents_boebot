/*
 * Move robot forward
 */

#include <Servo.h>                           // Include servo library
 
Servo servoRight;                            // Declare right servo
Servo servoLeft;                             // Declare left servo
 
void setup()                                 // Built in initialization block
{
  servoRight.attach(12);                     // Attach right signal to pin 12
  servoLeft.attach(13);                      // Attach right signal to pin 13

  servoRight.writeMicroseconds(1300);        // Right wheel forward
  servoLeft.writeMicroseconds(1700);         // Left wheel forward

  Serial.begin(9600);                        // Set data rate to 9600 bps
}  
 
void loop()                                  // Main loop auto-repeats
{
  Serial.print("A3 = ");                     // Display "A3 = "
  Serial.print(volts(A3));                    // Display measured A3 volts
  Serial.println(" volts");                  // Display " volts" & newline
  delay(10);                               // Delay for 1 second
  
  if(volts(A3) < 0.04)
  {
    servoRight.writeMicroseconds(1500);        // Stop
    servoLeft.writeMicroseconds(1500);         // Stop
  }
}
                                             
float volts(int adPin)                       // Measures volts at adPin
{                                            // Returns floating point voltage
 return float(analogRead(adPin)) * 5.0 / 1024.0;
}    
