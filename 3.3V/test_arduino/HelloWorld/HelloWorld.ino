/*
  LiquidCrystal Library - Hello World

 Demonstrates the use a 16x2 LCD display.  The LiquidCrystal
 library works with all LCD displays that are compatible with the
 Hitachi HD44780 driver. There are many of them out there, and you
 can usually tell them by the 16-pin interface.

 This sketch prints "Hello World!" to the LCD
 and shows the time.

  The circuit (modified by Tony@think3dprint3d for the Duet):
                            Arduino pin number  Duet Pin Name  Expansion header pin
 * LCD RS pin to digital pin D67                 PB16          (32)
  * LCD Enable pin to digital D23                PA14          (10)
 * LCD D4 pin to digital pin D19                 PA10 RXD0     (14)
 * LCD D5 pin to digital pin D18                 PA11 TXD0     (13)
 * LCD D6 pin to digital pin D17                 PA12 RXD1     (12)
 * LCD D7 pin to digital pin D16                 PA13 TXD1     (11)
 * LCD R/W pin to ground
 * 10K resistor:
 * ends to +5V and ground
 * wiper to LCD VO pin (pin 3)
 
 
 Library originally added 18 Apr 2008
 by David A. Mellis
 library modified 5 Jul 2009
 by Limor Fried (http://www.ladyada.net)
 example added 9 Jul 2009
 by Tom Igoe
 modified 22 Nov 2010
 by Tom Igoe

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/LiquidCrystal
 */

// include the library code:
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(67, 23, 19, 18, 17, 16); //RS,E,D4,D5,D6,D7

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(20, 4);
  // Print a message to the LCD.
  lcd.print("hello, world!");
}

void loop() {
    lcd.setCursor(0, 1);
  // print the number of seconds since reset:
  lcd.print(millis()/1000);
}

