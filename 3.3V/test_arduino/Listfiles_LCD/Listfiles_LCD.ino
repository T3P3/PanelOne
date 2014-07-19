/*
  Listfiles
 
 This example shows how print out the files in a 
 directory on a SD card 
 	
 The circuit:
 * SD card attached to SPI bus as follows:
 ** MOSI - pin 11
 ** MISO - pin 12
 ** CLK - pin 13
 ** CS - pin 77

 created   Nov 2010
 by David A. Mellis
 modified 9 Apr 2012
 by Tom Igoe
 modified 2 Feb 2014
 by Scott Fitzgerald
 
 This example code is in the public domain.

 */
#include <SPI.h>
#include <SD.h>
#include <LiquidCrystal.h>

File root;
// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(67, 23, 19, 18, 17, 16); //RS,E,D4,D5,D6,D7

void setup()
{
  lcd.begin(20, 4);
  lcd.print("Reading Files...");
  delay(2000); //delay or else the message will not be displayed

  if (!SD.begin(77)) {
    lcd.clear();
    lcd.print("initialization");
    lcd.setCursor(0,1);
    lcd.print("failed!");
    return;
  }
    lcd.clear();
    lcd.print("initialization done");
  delay(2000); //delay or else the message will not be displayed
    lcd.clear();
    lcd.print("listing 4 files");
    delay(2000); //delay or else the message will not be displayed
    root = SD.open("/");
    lcd.clear();
  printDirectory(root, 0);

}

void loop()
{
  // nothing happens after setup finishes.
}

void printDirectory(File dir, int numTabs) {
  int row=0;
   while(true) {
     if(row>3) return;
     lcd.setCursor(0,row);
     File entry =  dir.openNextFile();
     if (! entry) {
       // no more files
       break;
     }
     for (uint8_t i=0; i<numTabs; i++) {
       lcd.print(' ');
     }
     lcd.print(entry.name());
     if (entry.isDirectory()) {
       lcd.print("/");
       printDirectory(entry, numTabs+1);
       row++;
     } else {
       // files have sizes, directories do not
       lcd.print("  ");
       lcd.print(entry.size(), DEC);
       row++;
     }
     entry.close();
   }
}



