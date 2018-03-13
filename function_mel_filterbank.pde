float[][] getMelFilterbank(int num, int size, int[] fftbinIndex) {
  float[][] bank = new float[num][size];
  
  for(int i = 0; i < num; i++) {
    float m1 = float(fftbinIndex[i]);
    float m2 = float(fftbinIndex[i + 1]);
    float m3 = float(fftbinIndex[i + 2]);
    
    for(int j = 0; j < size; j++) {
      float k = float(j);
      if(k < m1) {
        bank[i][j] = 0.0;
      }
      else if(k >= m1 && k < m2) {
        bank[i][j] = (j - m1) / (m2 - m1);
      }
      else if(k >= m2 && k < m3) {
        bank[i][j] = (m3 - j) / (m3 - m2);
      }
      else {
        bank[i][j] = 0;
      }
    }    
  }
    
  //stroke(0);
  //noFill();  
  //for(int i = 0; i < num; i++) {    
  //  for(int j = 0; j < size - 1; j++) {
  //    line(j, height - bank[i][j] * 100, j + 1, height - bank[i][j + 1] * 100);
  //  }
  //}
  
  return bank;
}

float[][] getFilterbankEnergies(float[][] spectrums, float[][] melfilters) {
  float[][] energies = new float[spectrums.length][melfilters.length];
  
  for(int frameId = 0; frameId < spectrums.length; frameId++) { //each frame
    
    for(int filterId = 0; filterId < melfilters.length; filterId++) {
      float energy = 0;
      for(int bandId = 0; bandId < melfilters[filterId].length; bandId++) {
        float powSpecEstimate = pow(spectrums[frameId][bandId], 2) / fftSize;
        energy += powSpecEstimate * melfilters[filterId][bandId];
      }
      if(energy == 0) energy = 0.0000001;
      //energy = log(energy);
      energies[frameId][filterId] = energy;
    }
    
  }
  //println(energies[10000]);
  return energies;
}

float[][] DCT(float[][] bankenergies) {
  float[][] _mfcc = new float[bankenergies.length][coefNums];
  
  //******** materials for DCT ********//
  float N = mfccBankNumbers;
  float scale = sqrt(2 / N);
  //******** materials for DCT ********//
  
  for(int frameId = 0; frameId < bankenergies.length; frameId++) {
    
    for(int l = 1; l <= coefNums; l++) { //only use the 2nd to 14th energies to calculate the MFCC
      int coefId = l - 1;
      float ml = bankenergies[frameId][l];
      int k = l;
      
      float Vk = scale * ml * cos(k * (l - 0.5) * PI / N);
      _mfcc[frameId][coefId] = Vk;
    }
    
  }
  
  return _mfcc;
}

float[][] Deltas(float[][] _mfcc) {
  float[][] mfccPlusDeltas = new float[_mfcc.length][coefNums * 2];
  int N = 2;
  
  for(int frameId = 0; frameId < _mfcc.length; frameId++) {
    for(int t = 0; t < _mfcc[frameId].length; t++) {
      
      float up = 0.0;
      float down = 0.0;
      for(int n = 1; n <= N; n++) {
        int front = t + n;
        int back = t - n;
        if(front > coefNums - 1) front = coefNums - 1;
        if(back < 0) back = 0;
        up += (n * (_mfcc[frameId][front] - _mfcc[frameId][back]));
        down += (n * n);
      }
      float dt = up / (2 * down);
      
      mfccPlusDeltas[frameId][t] = _mfcc[frameId][t];
      mfccPlusDeltas[frameId][t + coefNums] = dt;
    }
  }
  
  return mfccPlusDeltas;
}