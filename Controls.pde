/**
 * All the controls for the sketch
 * 
 * The controls are primarily for a MIDI Controller with the following layout
 * 
 * |--------------------------------------------|
 * |                                            |
 * |      c22  c21      p48  p49  p50  p51      |
 * |                                            |
 * |      ---  ---      p44  p45  p46  p47      |
 * |       -    -                               |
 * |      c24  c23      p40  p41  p42  p43      |
 * |       -    -                               |
 * |      ---  ---      p36  p37  p38  p39      |
 * |                                            |
 * |--------------------------------------------|
 * 
 * c22: Color scheme
 * c21: Bezier Amt
 * c24: Variation Change
 * c23: Zoom Level
 * 
 * p36 - p48 Make lines on the canvas. After two buttons are pressed, a new line will appear
 * 
 * An alternative keyboard layout with corresponding functionality
 * Every button has a hold function, that emulates turning the knob
 * 
 * |--------------------------------------------|
 * |                                            |
 * |      q-w  e-r       6    7    8    9       |
 * |                                            |
 * |      ---  ---       z    u    i    o       |
 * |       -    -                               |
 * |      a-s  d-f       h    j    k    l       |
 * |       -    -                               |
 * |      ---  ---       n    m    ,    .       |
 * |                                            |
 * |--------------------------------------------|
 * 
 * 
 * Additional keyboard controls: 
 * g - Take a screenshot
 * c - Clear
 * y - add dither shader
 * x - add barrel distortion shader
 * v - toggle lines
 * 
 */

/**
 * Globals for detecting if you hold a key
 */

boolean keyPressedA = false;
boolean keyPressedS = false;
boolean keyPressedE = false;
boolean keyPressedR = false;
boolean keyPressedD = false;
boolean keyPressedF = false;
boolean keyPressedQ = false;
boolean keyPressedW = false;

int holdDelay = 1000; // Delay in milliseconds before continuous key press action starts
int lastKeyPressTime = 0; // Time when the key was last pressed

// Adjust the rate of change for Variation Scrubber and Style
int variationScrubberRate = 70; // Rate of change for Variation Scrubber
int styleChangeRate = 500; // Delay in milliseconds between Style changes

int selectedDevice;

void connectToMIDI(String deviceName){

  MidiBus.list();
    String[] midiDevices = MidiBus.availableInputs(); 
    println(midiDevices);
    for (int i = 0; i < midiDevices.length; i++){
      print(midiDevices[i]);
      println(i);
      if (midiDevices[i].equals(deviceName)){
        println(midiDevices[i]);
        selectedDevice = i;
      }
    }
    println(selectedDevice);
    myBus = new MidiBus(this, selectedDevice, 0); 
}

void noteOn(int channel, int pitch, int velocity) {
  /** 
   * Lines
   */
  float x = (pitch-36)%4;
  float y = 3-(pitch-36)/4;
  EdgeMaker.setPoint(new PVector(x, y));
}

void noteOff(int channel, int pitch, int velocity) {

}

void controllerChange(int channel, int number, int value) {
  /** 
   * Zoom
   */
  if (number == 23) {
    constOffset = int(map(value, 0, 127, 0, 1000));
  }
  /** 
   * Variations
   */
  if (number == 24) {
    shapeVariationCtl = int(map(value, 0, 127, 0, EdgeMaker.foundCycles.size()));
  }
  /** 
   * Style
   */
  if (number == 22) {
    colorSelector = int(map(value, 0, 127, 0, Pastel.foreground.size()-1));
  }
  /** 
   * Bezier
   */
  if (number == 21) {
    bezierAmt = map(value, 0, 127, 0, 1);
  }

}

/** 
 * Keyboard binds
 */

void keyPressed(){
  int currentTime = millis();
  /** 
   * Lines
   */
  char[] codes = {'6', '7', '8', '9', 'z', 'u', 'i', 'o', 'h', 'j', 'k', 'l', 'n', 'm', ',', '.'};
  for (int i = 0; i < codes.length; i++){
      if (key == codes[i]){
        float x = i%4;
        float y = i/4;
        EdgeMaker.setPoint(new PVector(x, y));
    }
  }
  /** 
  * Variation Scrubber
  */
  if (key == 'a'){
    keyPressedA = true;
  } 

  if (key == 's' ) {
    keyPressedS = true;
  }

  /** 
  * Bezier
  */
  if (key == 'e'){
    bezierAmt = max(0.0, bezierAmt - 0.01); // Decrease bezierAmt by 0.01
    keyPressedE = true;
  }

  if (key == 'r'){
    bezierAmt = min(1.0, bezierAmt + 0.01); // Increase bezierAmt by 0.01
    keyPressedR = true;
  } 

  /** 
  * Zoom
  */

  if (key == 'd'){
    //constOffset = max(120, constOffset - 12); // Decrease constOffset by 10
    keyPressedD = true;
  }

  if (key == 'f'){
    //constOffset = min(1000, constOffset + 12); // Increase constOffset by 10
    keyPressedF = true;
  } 

  /** 
   * Style
   */
  if (key == 'q'){
    keyPressedQ = true;
  }

  if (key == 'w'){
    keyPressedW = true;
  } 

  /** 
   * Screenshot
   */
  if (key == 'g'){
    saveImage = true;
    record = true;
  } 

  /** 
   * Clear
   */
  if (key == 'c'){
    EdgeMaker.clear();
    LinesGraph.clear();
  } 

  /** 
   * Dither Shader
   */
  if (key == 'y'){
    if (dither == false){
      dither = true;
    }
    else {
      dither = false;
    }
  }
 
  /** 
   * Barrel Distortion Shader
   */ 
  if (key == 'x'){
    if (distort == false){
      distort = true;
    }
    else {
      distort = false;
    }
  }
 
  /** 
   * Toggle visibility of lines
   */ 
  if (key == 'v'){
    if (drawLinesBool == false){
      drawLinesBool = true;
    }
    else {
      drawLinesBool = false;
    }
  }
}

void keyReleased() {
  if (key == 'a') {
    keyPressedA = false;
  }
  if (key == 's') {
    keyPressedS = false;
  }
  if (key == 'e') {
    keyPressedE = false;
  }
  if (key == 'r') {
    keyPressedR = false;
  }
  if (key == 'd') {
    keyPressedD = false;
  }
  if (key == 'f') {
    keyPressedF = false;
  }
  if (key == 'q') {
    keyPressedQ = false;
  }
  if (key == 'w') {
    keyPressedW = false;
  }
}

void triggerHoldKeys() {
  if (keyPressedA) {
    if (millis() - lastKeyPressTime > variationScrubberRate) { // Delay for Variation
        shapeVariationCtl = max(0, shapeVariationCtl - 1);
        lastKeyPressTime = millis();
    }
  }
  if (keyPressedS) {
     if (millis() - lastKeyPressTime > variationScrubberRate) { // Delay for Variation
        shapeVariationCtl = min(EdgeMaker.foundCycles.size() - 1, shapeVariationCtl + 1);
        lastKeyPressTime = millis();
    }   
  }
  if (keyPressedE) {
    bezierAmt = max(0.0, bezierAmt - 0.01);
  }
  if (keyPressedR) {
    bezierAmt = min(1.0, bezierAmt + 0.01);
  }
  if (keyPressedD) {
    constOffset = max(20, constOffset - 12);
  }
  if (keyPressedF) {
    constOffset = min(width/2, constOffset + 12);
    println(constOffset);
  }
  if (keyPressedQ) {
    if (millis() - lastKeyPressTime > styleChangeRate) { // Delay for Style
      colorSelector = max(0, colorSelector - 1);
      lastKeyPressTime = millis();
    }
  }
  if (keyPressedW) {
    if (millis() - lastKeyPressTime > styleChangeRate) { // Delay for Style
      colorSelector = min(Pastel.background.size() - 1, colorSelector + 1);
      lastKeyPressTime = millis();
    }
  }
}