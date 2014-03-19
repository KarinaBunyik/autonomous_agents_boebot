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
  delay(10000);                               // ...for 3 seconds
 
  servoRight.writeMicroseconds(1500);        // Stop
  servoLeft.writeMicroseconds(1500);         // Stop

}  
 
void loop()                                  // Main loop auto-repeats
{                                            // Empty, nothing needs repeating
}
