import processing.svg.*;
import themidibus.*; 
import java.util.*;

PShader barrelBlurChroma;
PShader dithering;
PImage noiseImage;

Edges EdgeMaker;
Graph LinesGraph;
Colorscheme Pastel;

MidiBus myBus;

boolean saveImage = false;
boolean record = false;
boolean distort = false;
boolean dither = false;
boolean drawLinesBool = true;

// Zooming
int constOffset = 200;
int mult;

// Color selector for Background und Foreground
int colorSelector = 0;
int shapeVariationCtl = 0;
float bezierAmt = 0.;

void setup() {
  size(1240, 1240, P2D);

  // Ramp up anti aliasing for smoother lines
  smooth(4);

  // Calculate initial distance between points so that the zoom coordinates are updated
  mult = (height-2*constOffset)/6;

  // Custom function in Controls.pde for connecting to a specifically named MIDI Controller
  connectToMIDI("Teensy MIDI");

  EdgeMaker = new Edges();
  LinesGraph = new Graph();
  Pastel = new Colorscheme();

  // Barrel Shader Presets
  barrelBlurChroma = loadShader("barrelBlurChroma.glsl");
  barrelBlurChroma.set("sketchSize", float(width), float(height));
  barrelBlurChroma.set("barrelPower", 0.4);

  // Dither Shader Presets
  noiseImage  = loadImage( "noise.png" );
  dithering = loadShader( "dithering.glsl" );
  dithering.set("sketchSize", float(width), float(height));
  dithering.set("noiseTexture", noiseImage);

}

void draw() {
  if (record) {
    beginRecord(SVG, "./pictures/frame-####.svg");
  }

  if (saveImage) {
    saveFrame("./pictures/frame-####.png");
    saveImage = false;
  }

  background(Pastel.background.get(colorSelector));

  // Calculate distance between points so that the zoom coordinates are updated
  mult = (height-2*constOffset)/6;

  // Enable holding keys for emulating knobs on keyboard 
  triggerHoldKeys();

  // Dial up the resolution for the beziers, change if it's too heavy for your machine
  bezierDetail(100);

  EdgeMaker.drawShape(Pastel.foreground.get(colorSelector));

  if (drawLinesBool){
    EdgeMaker.drawLines(color(15), 2);
  }

  if (record) {
    endRecord();
    record = false;
  }

  if (dither){
    filter(dithering);
  }

  if (distort){
    filter(barrelBlurChroma);
  }
}
