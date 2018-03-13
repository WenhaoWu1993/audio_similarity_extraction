float toMel(float freq) {
  float mel;
  mel = 1125 * log(1 + (freq / 700));
  return mel;
}

float toFrequency(float mel) {
  float freq;
  freq = 700 * (exp(mel / 1125) - 1);
  return freq;
}

float[] getMelSegments(float lower, float upper, int segs) {
  float[] segments = new float[segs];  
  for(int i = 0; i < segments.length; i++) {
    segments[i] = lower + i * (upper - lower) / (segs - 1);
  }  
  return segments;
}

float[] getFrequencySegments(float[] melseg) {
  float[] seg = new float[melseg.length];
  
  for(int i = 0; i < seg.length; i++) {
    seg[i] = toFrequency(melseg[i]);
  }
  
  return seg;
}

int[] getfftBinNumbers(float[] freqseg) {
  int[] bins = new int[freqseg.length];
  
  for(int i = 0; i < bins.length; i++) {
    bins[i] = floor((fftSize + 1) * freqseg[i] / sampleRate);
  }
  
  return bins;
}