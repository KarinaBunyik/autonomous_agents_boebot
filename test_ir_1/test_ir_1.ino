'' 1 Test IR Object Detectors with PST.spin

'' Use IR LED and IR receiver to detect object presence.
'' Display results in Parallax Serial Terminal.                                                

OBJ

  system : "Propeller Board of Education"             ' System configuration
  freq   : "PropBOE Square Wave"                      ' Square wave signal generator
  ir     : "PropBOE IR Detect"                        ' IR object detection
  pst    : "Parallax Serial Terminal Plus"            ' Serial communication object
  time   : "Timing"                                   ' Delay and wait convenience methods
 
VAR

  byte objectL, objectR                               ' Variables to store results

PUB Go                                                ' Startup method

  system.Clock(80_000_000)                            ' System clock -> 80 MHz
  freq.Out(4, 1000, 3000)                             ' P4 sends 1 s, 3 kHz tone to speaker
 
  repeat                                              ' Main loop repeats indefinitely
    objectL := ir.Detect(13, 12)                      ' Check for left object
    objectR := ir.Detect(0, 1)                        ' Check for right object
    
    Display                                           ' Call display method (below)
    time.Pause(20)                                    ' Wait 20 ms before repeating   

PUB Display                                           ' Display method for IR detectors

  pst.Home                                            ' Send cursor home (top-left)         
  pst.Str(string("objectL = "))                       ' Display "objectL = "
  pst.Bin(objectL, 1)                                 ' Display objectL value
  pst.Str(string("  objectR = "))                     ' Display "objectL = "
  pst.Bin(objectR, 1)                                 ' Display objectL value
