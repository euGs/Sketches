/**
Instructions:

The x-position of your mouse in the processing window determines the noise threshold.
MaxWordsRecordable is the maximum number of words the processing sketch will record
in one session.

**/

import ddf.minim.*;
 
Minim minim;
AudioInput in;
ddf.minim.AudioRecorder recorder;
float noiseThreshold;
int numberOfWordsRecorded, MaxWordsRecordable;
 
void setup()
{
  size(512, 200, P3D);
 
  minim = new Minim(this);
 
  in = minim.getLineIn();
  noiseThreshold = 0;
  numberOfWordsRecorded = 0;
  MaxWordsRecordable = 10;
    
  textFont(createFont("Arial", 12));
}
 
void draw()
{
  background(0); 
  stroke(255);

  setWaveColor();
  drawWaveform();
  detectWords();
  text(numberOfWordsRecorded, 10, 10);
}

void setWaveColor()
{
  if (recorder != null && recorder.isRecording()) {
    stroke(255, 0, 0);
  } else {
    if (in.left.level() > noiseThreshold){
      stroke(255);
    } else {
      stroke(50);
    }
  }
}

void drawWaveform()
{
  // the values returned by left.get() and right.get() will be between -1 and 1,
  // so we need to scale them up to see the waveform
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line(i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50);
    line(i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50);
  }
}

void detectWords()
{
  if (
    (recorder == null || !recorder.isRecording()) 
    && in.left.level() > noiseThreshold 
    && numberOfWordsRecorded < MaxWordsRecordable) {
    // If word has just started.
    recorder = minim.createRecorder(in, "word" + (new java.util.Date()).getTime() + ".wav");
    recorder.beginRecord();
  } else if (
    (recorder != null && recorder.isRecording()) 
    && in.left.level() <= noiseThreshold) {
    // If word has just finished.
    recorder.endRecord();
    recorder.save();
    recorder = null;
    numberOfWordsRecorded++;
  }
}

void mouseMoved()
{
  noiseThreshold = mouseX * .001;
  println("Noise threshold: " + noiseThreshold);
}
