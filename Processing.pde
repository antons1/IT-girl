import processing.serial.*;                  // Serial connection
import ddf.minim.*;                          // Sound

Serial port;                                 // Serial port to read infoID from
Minim minim;                                 // Sound library
PImage images[] = new PImage[22];            // Images to show with info (index corresponds with iid
AudioPlayer players[] = new AudioPlayer[10]; // Audio to play
AudioPlayer player;                          // Current audio being played
final int wSize = 1280;                      // Window width
final int hSize = 1024;                      // Window height
int infoId = -1;                             // infoID
int prevId;                                  // Previous ID
int curTime = 0;                             // The current time
int prevTime = 0;                            // The time a tag was last read
int interval = 18000;                        // The time an info windows is shown
boolean waitingForAnswer = false;            // Whether we are waiting for an answer
int lastAnswer = -1;                         // Last given answer
int lastAnswerTime = 0;                      // When answerstate changed last
int showAnswerTime = 10000;                   // How long an answer is shown

String header;
String body;
String yesHeader;
String noHeader;
int toId;

void setup()
{
  size(wSize, hSize);                        // Creates the window
  setupPort();                               // Sets up the COM-port for listening
  setupSound();                              // Sets up the audio player
  images[0] = loadImage("0Scan.jpg");        // Images
  images[1] = loadImage("101Media.png");
  images[2] = loadImage("103Media.jpg");
  images[3] = loadImage("104Media.jpg");
  images[4] = loadImage("201Mennesker.jpg");
  images[5] = loadImage("203Mennesker.jpg");
  images[6] = loadImage("204Mennesker.jpg");
  images[7] = loadImage("301Matte.jpg");
  images[8] = loadImage("303Matte.jpg");
  images[9] = loadImage("304Matte.jpg");
  images[10] = loadImage("401Helsesektoren.jpg");
  images[11] = loadImage("403Helsesektoren.jpg");
  images[12] = loadImage("404Helsesektoren.jpg");
  images[13] = loadImage("501Gutter.jpg");
  images[14] = loadImage("503Gutter.jpg");
  images[15] = loadImage("504Gutter.jpg");
  images[16] = loadImage("601Mobiler.jpg");
  images[17] = loadImage("603Mobiler.jpg");
  images[18] = loadImage("604Mobiler.jpg");
  images[19] = loadImage("701PC.jpg");
  images[20] = loadImage("703PC.jpg");
  images[21] = loadImage("704PC.jpg");
  
  players[0] = null;
  players[1] = null;
  players[2] = null;
  players[3] = null;
  players[4] = null;
  players[5] = null;
  players[6] = null;
  players[7] = null;
  players[8] = null;
  players[9] = null;
}

void draw()
{
  curTime = millis();
  
  // RFID-iid: nn
  // Sub-iid: nn0nn
  
  if(infoId != prevId)
  {
    prevTime = millis();
    prevId = infoId;
      
  }
  
  switch(infoId)
  {
    default:
    case 0:
    header = "Scan et kort";
    body = "Som vist på bildet";
    writeInfo(header, body, images[0]);
    break;
    
    case 1:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Trengs informatikere i NRK?";
    body = "";
    writeInfo(header, body, images[1]);
    infoId = 101;
    break;
    
    case 101:
    yesHeader = "Det stemmer!";
    noHeader = "Jo, det gjør det!";
    body = "Informatikere lager for eksempel yr.no";
    toId = 102;
    writeAnswer(yesHeader, noHeader, body, toId, images[1]);
    break;
    
    case 102:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Er det kun grafiske designere som jobber med nettsider?";
    body = "";
    writeInfo(header, body, images[2]);
    infoId = 103;
    break;
    
    case 103:
    yesHeader = "Feil!";
    noHeader = "Riktig!";
    body = "Som oftest er det informatikere som programmerer nettstedet, og bestemmer hvordan det skal se ut,\ngrafiske designere lager bare grafikken.";
    toId = 104;
    writeAnswer(yesHeader, noHeader, body, toId, images[2]);
    break;
    
    case 104:
    header = "\"Jeg vil jobbe med media\"";
    body = "Det er ikke bare fotografer, journalister og grafiske designere som jobber med media. Nettsider " +
           "og applikasjoner til smarttelefoner og nettbrett må også lages og opprettholdes.\n" +
           "Eksempel: i NRK er det flere informatikere som jobber med blant annet å utvikle web-TV.";
    writeInfo(header, body, images[3]);
    break;
    
    case 2:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Jobber informatikere alltid alene?";
    body = "";
    writeInfo(header, body, images[4]);
    infoId = 201;
    break;
    
    case 201:
    yesHeader = "Feil!";
    noHeader = "Riktig!";
    body = "Informatikere jobber som oftest i utviklingsteam med andre mennesker.";
    toId = 202;
    writeAnswer(yesHeader, noHeader, body, toId, images[4]);
    break;
    
    case 202:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Er informatikk viktig for morgendagens eldreomsorg?";
    body = "";
    writeInfo(header, body, images[5]);
    infoId = 203;
    break;
    
    case 203:
    yesHeader = "Det stemmer!";
    noHeader = "Jo, det er det!";
    body = "Informatikk brukes allerede i mange hjelpemidler, og vil bli enda viktigere i fremtiden.";
    toId = 204;
    writeAnswer(yesHeader, noHeader, body, toId, images[5]);
    break;
    
    case 204:
    header = "\"Jeg vil jobbe med mennesker\"";
    body = "For å utvikle gode IT-løsninger er det viktig å være i kontakt med de som skal bruke produktet. " +
           "Samarbeid med andre personer er en viktig del av hverdagen til en informatiker, og mange " +
           "jobber i team.  Når man jobber med å utvikle teknologiske løsninger, når man ut til svært mange. " +
           "Bare tenk hvor mange som kan bli reddet av en god hjertestarter!";
    writeInfo(header, body, images[6]);
    break;
    
    case 3:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Er matte et obligatorisk opptakskrav for alle informatikkstudier?";
    body = "";
    writeInfo(header, body, images[7]);
    infoId = 301;
    break;
    
    case 301:
    yesHeader = "Feil!";
    noHeader = "Riktig!";
    body = "Det er kun to av de fire informatikklinjene på UiO som krever matte.";
    toId = 302;
    writeAnswer(yesHeader, noHeader, body, toId, images[7]);
    break;
    
    case 302:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Er matte en del av informatikkstudiet?";
    body = "";
    writeInfo(header, body, images[8]);
    infoId = 303;
    break;
    
    case 303:
    yesHeader = "Ikke nødvendigvis!";
    noHeader = "Kanskje!";
    body = "Noen av linjene har matte som en obligatorisk del av undervisningen.";
    toId = 304;
    writeAnswer(yesHeader, noHeader, body, toId, images[8]);
    break;
    
    case 304:
    header = "\"Man må være god i matte for å studere informatikk\"";
    body = "Av UiOs fire IT-linjer er det kun to som krever matematikk: \"nanoelektronikk og robotikk\" og \"programmering " +
           "og nettverk\". \"Design, bruk og interaksjon\" og \"språk og kommunikasjon\" har ikke matte som krav fra vgs eller matte som et " +
           "obligatorisk fag. Det er ikke slik at de linjene som krever at du har hatt matte forutsetter at du har toppkarakterer. " +
           "Ønsker man å gå på en linje som krever matte, men frykter at det skal bli vanskelig er det viktig å huske på at det er " +
           "tilbud om hjelp underveis, både fra forelesere og eldre studenter.";
    writeInfo(header, body, images[9]);
    break;
    
    case 4:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Kan informatikere jobbe i helsesektoren?";
    body = "";
    writeInfo(header, body, images[10]);
    infoId = 401;
    break;
    
    case 401:
    yesHeader = "Riktig!";
    noHeader = "Feil!";
    body = "Innen helsesektoren jobbe informatikere jobber særlig med pasientjournalsystemer, og utvikling av hjelpemidler for både personale og syke.";
    toId = 402;
    writeAnswer(yesHeader, noHeader, body, toId, images[10]);
    break;
    
    case 402:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Trenger MR-maskiner programmering?";
    body = "";
    writeInfo(header, body, images[11]);
    infoId = 403;
    break;
    
    case 403:
    yesHeader = "Stemmer!";
    noHeader = "Joda!";
    body = "MR-maskiner må ha programvare for å fungere som de skal.";
    toId = 404;
    writeAnswer(yesHeader, noHeader, body, toId, images[11]);
    break;
    
    case 404:
    header = "Helse";
    body = "Det finnes mange IT-jobber innen helsesektoren. Du kan enten være en del av institusjonens IT-avdeling, eller du kan " +
           "være knyttet opp mot mange ulike prosjekter.\n\n" +
           "Eksempler på dette er\n" +
           "-  Utvikling av journalsystemer\n" +
           "-  Utvikling av hjertestartere, diabetespumper, EKG-maskiner osv.\n" +
           "-  Utvikling av IT-systemer for å drifte apoteker, sykehusavdelinger, legekontorer osv.\n";
    writeInfo(header, body, images[12]);
    break;
    
    case 5:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Er det stort sett gutter som studerer informatikk?";
    body = "";
    writeInfo(header, body, images[13]);
    infoId = 501;
    break;
    
    case 501:
    yesHeader = "Ja, det stemmer!";
    noHeader = "Jo, dessverre!";
    body = "Nå er det ca 20% jenter på IFI, men du kan være med å gjøre andelen større!";
    toId = 502;
    writeAnswer(yesHeader, noHeader, body, toId, images[13]);
    break;
    
    case 502:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Er det kø på jentedoen på IFI?";
    body = "";
    writeInfo(header, body, images[14]);
    infoId = 503;
    break;
    
    case 503:
    yesHeader = "Meget sjelden!";
    noHeader = "Så godt som aldri!";
    body = "Jentedoene på IFI er alltid rene, og nesten aldri opptatt.";
    toId = 504;
    writeAnswer(yesHeader, noHeader, body, toId, images[14]);
    break;
    
    case 504:
    header = "\"Bare gutter studerer informatikk\"";
    body = "Det stemmer at det er få jenter som studerer informatikk. På institutt for informatikk på UiO er det totalt 20% " +
           "jenter hvis man tar med alle linjer og trinn. Men dette vil ikke si at det er et studie som passer bedre for gutter " +
           "enn for jenter.  Det er også linjer som har større jenteandel enn dette, f.eks design, bruk og interaksjon.";
    writeInfo(header, body, images[15]);
    break;
    
    case 6:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Designer informatikere telefoner?";
    body = "";
    writeInfo(header, body, images[16]);
    infoId = 601;
    break;
    
    case 601:
    yesHeader = "Det kan de gjøre!";
    noHeader = "Man trenger ikke gjøre det, men...";
    body = "Interaksjonsdesignere kan jobbe med å utforme telefoner og andre dingser.";
    toId = 602;
    writeAnswer(yesHeader, noHeader, body, toId, images[16]);
    break;
    
    case 602:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Kan informatikere lage apper?";
    body = "";
    writeInfo(header, body, images[17]);
    infoId = 603;
    break;
    
    case 603:
    yesHeader = "Jepp!";
    noHeader = "Joda!";
    body = "Informatikere kan både designe, teste og lage apper.";
    toId = 604;
    writeAnswer(yesHeader, noHeader, body, toId, images[17]);
    break;
    
    case 604:
    header = "IT og smarttelefoner";
    body = "Man kan jobbe i en konsulentbedrift og bli leid inn av andre selskaper som ønsker å utvikle en app, eller man kan" +
           "jobbe i en IT-avdeling i en bedrift, og jobbe med å utvikle apper internt.";
    writeInfo(header, body, images[18]);
    break;
    
    case 7:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Gjør det noe at jeg ikke kan bygge en datamaskin?";
    body = "";
    writeInfo(header, body, images[19]);
    infoId = 701;
    break;
    
    case 701:
    yesHeader = "Neida!";
    noHeader = "Nei, det stemmer!";
    body = "Informatikere trenger ikke nødvendigvis bygge datamaskiner, det du trenger lærer du.";
    toId = 702;
    writeAnswer(yesHeader, noHeader, body, toId, images[19]);
    break;
    
    case 702:
    waitingForAnswer = true;
    lastAnswerTime = millis();
    header = "Vet du hva en CPU er?";
    body = "";
    writeInfo(header, body, images[20]);
    infoId = 703;
    break;
    
    case 703:
    yesHeader = "Så bra!";
    noHeader = "Det gjør ikke noe!";
    body = "Det er ikke nødvendig å kunne for å studere informatikk!";
    toId = 704;
    writeAnswer(yesHeader, noHeader, body, toId, images[20]);
    break;
    
    case 704:
    header = "\"Jeg må kunne mye om datamaskiner for å studere informatikk\"";
    body = "Det er ingen som forventer at du skal kunne mye om hvordan datamaskinen er bygget " +
           "opp for å starte på et informatikkstudie. Informatikkstudier handler også mest om hvordan " +
           "man kan lage programmer, databaser osv og ikke så mye om elektronikken bak.";
    writeInfo(header, body, images[21]);
    break;
    
  }
  
  if((prevTime+interval) <= curTime)
  {
    infoId = -1;
  }
}

// Diverse funksjoner
void setupPort()
{
  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  port.bufferUntil(',');
}

void setupSound()
{
  minim = new Minim(this);
}

void writeAnswer(String yesHeader, String noHeader, String ansBody, int toId, PImage img)
{
  if(lastAnswer >= 0)
  {
    if(lastAnswer == 0)
    {
      header = yesHeader;
    }
    else if(lastAnswer == 1)
    {
      header = noHeader;
    }
    body = ansBody;
    
    lastAnswer = -1;
    writeInfo(header, body, img);
  }
  
  if((lastAnswerTime+showAnswerTime) <= curTime)
  {
    infoId = toId;
  }
}

void writeInfo(String header, String body, PImage image)
{
  clear();
  background(212, 255, 220);
  
  int headerSize = 42;
  int headerWidth = 1000;
  int headerHeight = 170;
  int headerPosX = (width-headerWidth)/2;
  int headerPosY = 20;
  
  int bodySize = 20;
  int bodyWidth = 475;
  int bodyHeight = 800;
  int bodyMargin = 25;
  int bodyPosX = (width-(bodyWidth*2)-(bodyMargin*2))/2;
  int bodyPosY = 190;
  
  int imageWidth = 475;
  int imageMargin = 25;
  int imagePosX = bodyPosX+imageWidth+imageMargin;
  int imagePosY = 190;
  
  if(body == "")
  {
    imageWidth = 500;
    imagePosX = (width-imageWidth)/2;
  }
  
  textAlign(LEFT);
  if(body == "")
  {
    textAlign(CENTER);
  }
  textSize(headerSize);
  fill(143, 30, 86);
  text(header, headerPosX, headerPosY, headerWidth, headerHeight);
  
  textAlign(LEFT);
  textSize(bodySize);
  fill(61, 0, 4);
  text(body, bodyPosX, bodyPosY, bodyWidth, bodyHeight);
  image.resize(imageWidth, 0);
  image(image, imagePosX, imagePosY);
} // End writeInfo(String, String, Image)

void writeInfo(String header, String body)
{
  writeInfo(header, body, null);
  
} // End writeInfo(String, String)

void serialEvent(Serial port)
{
  String input = port.readStringUntil(',');
  
    if(input.substring(0,4).equals("IID:"))
    {
      input = input.replaceFirst("IID:", "");
      input = input.replaceFirst(",", "");
      infoId = int(input);
      lastAnswer = -1;
      waitingForAnswer = false;
      if(player != null)
      {
        player.pause();
        player.rewind();
        player = null;
      }
    }
    else if(input.substring(0,4).equals("ANS:"))
    {
      input = input.replaceFirst("ANS:", "");
      input = input.replaceFirst(",", "");
      if(waitingForAnswer)
      {
        lastAnswerTime = millis();
      }
      
      if(input.substring(0).equals("YES"))
      {
        lastAnswer = 0;
        waitingForAnswer = false;
      }
      else if(input.substring(0).equals("NO"))
      {
        lastAnswer = 1;
        waitingForAnswer = false;
      }
     
      println();
      port.clear();
    }
}
