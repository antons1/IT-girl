#include <SoftwareSerial.h>              //for serial communication on any digital pins.

//RFID Konfigurasjon
const int RFID_TX_Pin = 2;               // the TX pin that the RDIF Sensor is attached to
String Parsed_Tag_ID;                    // Tag after it has been parsed
String Stored_Tag_ID;                    // Stored tag
char c;                                  // Each character that is read
SoftwareSerial RFID(RFID_TX_Pin , 255);  // RX port : 2 -- TX port : 255 (do not need any TX port)
                                         
// Figure IDs
const int NO_OF_FIGS = 8;                       // The number of figures
String figIds[NO_OF_FIGS] = {"",                // ID-forskyvning
                             "3D0063BBCF2A",    // Gul 0006536143 - "Jeg vil jobbe med media"
                             "3D00A90AA13F",    // Rød 011078305 - "Jeg vil jobbe med mennesker"
                             "3D0048E41786",    // Blå 0004776983 - "Man må være god i matte for å studere informatikk"
                             "3C00CC4704B3",    // Blå 001338752 - Kors
                             "3D00A7852C33",    // Rød 0010978604 - "Bare gutter studerer informatikk"
                             "3D004BF8E26C",    // Blå 0004978914 - Iphone
                             "3D0064CE3FA8"};   // Gul 0006606399 - "Jeg må kunne mye om datamaskiner for å studere informatikk"
                             
// Auxhilary equipment
const int YESBTN = 5;           // The yes button
const int NOBTN = 6;            // The no button
int prevAnswerTime = 0;         // Last time an answer was printed to serial
const int ANSWERPAUSE = 1000;   // Time before a new answer will be sent
const int LIGHT = 4;            // Port that light is connected to
const int SOUND = 3;            // Port that speaker is connected to
int feedbackTime = 250;         // Time that light and speaker is on after tag is scanned
int soundHz = 1000;             // Tone frequency
int curTime = 0;                // Current time (stored in loop with millis)
int prevTime = 0;               // Previous time (stored when tag is read
int tagRead = 0;                // Stores whether a tag has been read
                                // 0 - No tag read
                                // 1 - Tag read
                                // 2 - Feedback on

// Functions
boolean CheckSum_Tag_ID(String Tag_ID) {
  boolean res = false;
  unsigned int b1,b2,b3,b4,b5,checksum;
 
  //Convert Tag_ID String into array of chars in order to use sscanf  
  char charBuf[13];
  Tag_ID.toCharArray(charBuf, 13); 
  sscanf(charBuf , "%2x%2x%2x%2x%2x%2x", &b1, &b2, &b3, &b4, &b5, &checksum);
 
  //Check Tag ID
  if ( (b1 ^ b2 ^ b3 ^ b4 ^ b5) == checksum ) {
    return true;
  } else {
    return false;
  } 
}

void readTag()
{
  Stored_Tag_ID="";
  
  //Read the RFID tag
  
  RFID.listen();                                                   //Enables the selected software serial port to listen. 
   
  if (RFID.isListening())                                          //Tests to see if requested software serial port is actively listening.
  {  
    while(RFID.available() > 0)                                    //Read characters while there are characters to read.
    { 
      c = RFID.read();                                             //Stores the next character in c
      Parsed_Tag_ID += c;                                          //Store the char into the Parsed_Tag_ID string
      if(Parsed_Tag_ID.length() == 14)                             //If a full tag has been read (14 characters)
      {
        if((Parsed_Tag_ID[0]==2) && (Parsed_Tag_ID[13]==3))        // Check that we got a tag (start byte is 2, end byte is 3)
        {
          Parsed_Tag_ID = Parsed_Tag_ID.substring(1,13);           // Remove start and end byte
          if(CheckSum_Tag_ID(Parsed_Tag_ID) == true)               // Validate the Parsed Tag Id
          { 
            Stored_Tag_ID=Parsed_Tag_ID;                           // Save the tag
          } // ENDIF
          
        } // ENDIF
        Parsed_Tag_ID="";
        
      } // ENDIF
    
    } // ENDWHILE
  
  } // ENDIF
  
} // End readTag

int getInfoId(String tId)
{
  for(int i = 0; i < NO_OF_FIGS; i++)
  {
    if(figIds[i] == tId){
      return i;
    }
  }
  return -1;
}
 
// Setup
void setup()  
{  
  //Setup serial
  Serial.begin(9600);
 
  //Setup RFID serial
  RFID.begin(9600);  
  
  pinMode(LIGHT, OUTPUT);
  pinMode(SOUND, OUTPUT);
  pinMode(YESBTN, INPUT);
  pinMode(NOBTN, INPUT);
}

// Loop
void loop(){
  // Store the current time
  curTime = millis();
  
  // Read the tag if any is available
  readTag();
  
  // Print buttons to serial if they are pressed
  
  
    if(digitalRead(YESBTN) == HIGH)
    {
      Serial.print("ANS:");
      Serial.print("YES");
      Serial.print(",");
      prevAnswerTime = millis();
    } // ENDIF
    
    if(digitalRead(NOBTN) == HIGH)
    {
      Serial.print("ANS:");
      Serial.print("NO");
      Serial.print(",");
      prevAnswerTime = millis();
    } // ENDIF
    
  
  
  // Convert tag to info ID
  int iid = getInfoId(Stored_Tag_ID);
  
  //Print the info ID to serial, with a comma as interrupting character
  if ( Stored_Tag_ID!="" ){
    Serial.print("IID:");
    Serial.print(iid);
    Serial.print(",");
    tagRead = 1; // Tell the program that a tag has been read
  } // ENDIF
  
  // Check if a tag was read
  if(tagRead == 1)
  {
    // Then turn on the light and sound
    tagRead = 2; // Tell the program that feedback is on
    prevTime = millis();
    digitalWrite(LIGHT, HIGH);
    tone(SOUND, soundHz);
  }
  
  // Check if feedback has been turned on long enough
  if(tagRead == 2 && (prevTime+feedbackTime) <= curTime)
  {
    // Turn feedback off
    tagRead = 0; // Tell the program that tag reading is finished
    digitalWrite(LIGHT, LOW);
    noTone(SOUND);
  }
}

