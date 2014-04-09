/*
 * Make a scary sound
 */

void setup()                                 // Built-in initialization block
{
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
 
void loop()                                  // Main loop auto-repeats
{                             
}    
