float[][] getFFTSpectrums(String filename) {
  float[][] spectrums;
  
  AudioSample audio = minim.loadSample(filename);
  //int channelNumber = (panSide == "left" ? AudioSample.LEFT : AudioSample.RIGHT);
  
  float[] samples_left = audio.getChannel(AudioSample.LEFT); // get samples from left
  float[] samples_right = audio.getChannel(AudioSample.RIGHT); // get samples from right
  
  int totalSamples = samples_left.length;
  
  if(samples_left.length == samples_right.length) println("the sides have same amount of samples");
  
  float[] samples = new float[totalSamples];
  for(int i = 0; i < totalSamples; i++) {
    samples[i] = samples_left[i] + samples_right[i];
  }
  
  //*****************************//
  int specSize = fft.specSize();
  int stepSize = fftSize / 2;
  int totalFrames = (totalSamples / stepSize) + 1;
  spectrums = new float[totalFrames][specSize];
  //*****************************//
  
  println("totalSamples: " + totalSamples);
  println("totalFrames: " + totalFrames);
  println("specSize: " + specSize);
  
  int frameStartId = 0;
  int frameId = 0;
  while(frameStartId < totalSamples) {
    float[] fftsamples = new float[fftSize];
    
    int frameSize = min(totalSamples - frameStartId, fftSize);
    
    System.arraycopy(samples, frameStartId, fftsamples, 0, frameSize);
    if(frameSize < fftSize) {
      java.util.Arrays.fill(fftsamples, frameSize, fftsamples.length, 0.0);
    }    
    
    fft.forward(fftsamples);
    
    for(int i = 0; i < specSize; i++) {
      spectrums[frameId][i] = fft.getBand(i);
    }
    
    frameStartId += stepSize;
    frameId++;
  }
  
  return spectrums;
}