import ddf.minim.*;
import ddf.minim.analysis.*;
//import ddf.minim.effects.*;
//import ddf.minim.signals.*;
import ddf.minim.spi.*;
//import ddf.minim.ugens.*;

Minim minim;

int fftSize = 512;
int mfccBankNumbers = 26;
int sampleRate = 44100;
String filename = "bach cello";
FFT fft;
int coefNums = 12;

int windowWidth = 4;

float pixelScale = 1.0;

float lowerFreq, upperFreq;
//float[][] fftSpectrums;
//float[][] melFilterbank;
//float[][] filterbankEnergies;
//float[][] MFCCs;

void setup() {
  size(800, 800);
  //background(255);
  minim = new Minim(this);
  fft = new FFT(fftSize, sampleRate);
  fft.window(FFT.HAMMING);
    
  //********************* raw materials for mel-scale **********************//
  lowerFreq = fft.indexToFreq(0);
  upperFreq = fft.indexToFreq(fft.specSize() - 1);
  println("Lower Frequency: " + lowerFreq + ", Upper Frequency: " + upperFreq);  
  
  float lowerMel = toMel(lowerFreq);
  float upperMel = toMel(upperFreq);
  println("Lower Mel: " + lowerMel + ", Upper Mel: " + upperMel);
  
  println("Mel Segments: --------------------");
  float[] a = getMelSegments(lowerMel, upperMel, mfccBankNumbers + 2);
  println(a);
  
  println("Frequency Segments: --------------");  
  float[] b = getFrequencySegments(a);
  println(b);
  
  println("FFT Bins: ------------------------");  
  int[] c = getfftBinNumbers(b);
  println(c);
  
  float[][] melFilterbank = getMelFilterbank(mfccBankNumbers, fft.specSize(), c);
  //*************************************************************************//
  
  float[][] fftSpectrums = getFFTSpectrums(filename + ".mp3"); // get the fft spectrum of each frame
  println(fftSpectrums.length);
  
  float[][] filterbankEnergies = getFilterbankEnergies(fftSpectrums, melFilterbank); // calculate the energy at each mel-filterbank, get the log value
  //println(filterbankEnergies[5000]);
  println(filterbankEnergies[1000]);
  
  float[][] MFCCs = DCT(filterbankEnergies); // conduct DCT to get the MFCCs for each frame
  //println(MFCCs.length);
  //println(MFCCs[5000]);
  //println(MFCCs[1000]);
  
  float[][] mfccDelta = Deltas(MFCCs);
  println("raw length: " + mfccDelta.length);
  
  ArrayList<float[]> mfccFinal = measureWindowDistances(mfccDelta, filename);
  writeCSharpNew(mfccFinal);
  
  visualize(filename + ".csv");
  println("finished");
}

void draw() {
}