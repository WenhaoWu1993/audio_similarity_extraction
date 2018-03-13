float getCosineBetween(float[] vectorA, float[] vectorB) {
  float cosine;
  
  float dotProduct = getDotProductOf(vectorA, vectorB);
  float modeA = getModeOf(vectorA);
  float modeB = getModeOf(vectorB);
  
  if(modeA * modeB == 0) {
    if(modeA + modeB == 0) cosine = 1;
    else cosine = 0;
  }
  else {
    cosine = dotProduct / (modeA * modeB);
  }
  
  return cosine;
}

float getDotProductOf(float[] vectorA, float[] vectorB) {
  float product = 0;
  
  for(int i = 0; i < vectorA.length; i++) {
    product += vectorA[i] * vectorB[i];
  }
  
  return product;
}

float getModeOf(float[] vector) {
  float mode;  
  float sum = 0;
  
  for(int i = 0; i < vector.length; i++) {
    sum += sq(vector[i]);
  }
  
  mode = sqrt(sum);
  
  return mode;
}