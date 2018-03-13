int filterSize = 3;
void writeCSharpNew(ArrayList<float[]> data) {
  PrintWriter output;
  output = createWriter("SimilarityData.cs");
  
  output.println("using System.Collections;");
  output.println("using System.Collections.Generic;");
  output.println("using UnityEngine;" + '\n');
  
  output.println("public class SimilarityData {");
  
  output.println("public static int[,] TopsAndLeasts = new int[,] {");
  int totalBeats = data.get(data.size() - 1).length;
  for(int beatId = 0; beatId < data.size(); beatId++) {
    float[] rawList = data.get(beatId);
    
    //create a pair of (value, index)
    float[][] pair = new float[totalBeats][2];
    for(int i = 0; i < totalBeats; i++) {
      if(i < rawList.length) {
        pair[i][0] = rawList[i];
      } else {
        pair[i][0] = data.get(i)[beatId];
      }
      pair[i][1] = i;
    }
    // ---------------------------------- //
    java.util.Arrays.sort(pair, new java.util.Comparator<float[]>() {
      public int compare(float[] a, float[] b) {
        return Float.compare(a[0], b[0]);
      }
    });
    
    /*
      first 5: 0 - 4, most similar to fifth similar
      last 5: 5 - 9, least similar to fifth least similar
    */
    //top 5
    output.print("{");
    for(int i = pair.length - 2; i >= pair.length - filterSize - 1; i--) {
      output.print((int)pair[i][1] + ", ");
    }
    //least 5
    for(int i = 0; i < filterSize; i++) {
      output.print((int)pair[i][1]);
      if(i < filterSize - 1) {
        output.print(", ");
      } else {
        output.print("}");
      }
    }
    
    if(beatId < totalBeats - 1) {
      output.println(",");
    } else {
      output.print('\n');
      output.println("};");
    }
  }
  
  output.print('\n');
  
  output.println("public static List<float[]> similarityData = new List<float[]> {");
  
  for(int i = 0; i < data.size(); i++) {
    output.print("new float[] {");
    
    int count = 0;
    
    int arrayLength = data.get(i).length;
    for(int j = 0; j < arrayLength; j++) {
      float val = data.get(i)[j];
      output.print(val + "f");
      if(j < (arrayLength - 1)) {
        output.print(", ");
      }
      int c = j / 10;
      if(c != count) {
        output.print('\n');
        count = c;
      }
    }
    
    String a = (i < (data.size() - 1)) ? "}," : "}";
    output.println(a);
  }
  
  output.println("};");
  //output.print('\n');  
  
  
  
  output.print("}");
  
  output.flush();
  output.close();
}

void writeCSharp(ArrayList<float[]> data) {
  PrintWriter output;
  output = createWriter("SimilarityData.cs");

  output.println("using System.Collections;");
  output.println("using System.Collections.Generic;");
  output.println("using UnityEngine;" + '\n');
  output.println("public class SimilarityData {");
  
  output.println("public static List<float[]> similarityData = new List<float[]> {");
  
  for(int i = 0; i < data.size(); i++) {
    output.print("new float[] {");
    
    int count = 0;
    
    int arrayLength = data.get(i).length;
    for(int j = 0; j < arrayLength; j++) {
      float val = data.get(i)[j];
      output.print(val + "f");
      if(j < (arrayLength - 1)) {
        output.print(", ");
      }
      int c = j / 10;
      if(c != count) {
        output.print('\n');
        count = c;
      }
    }
    
    String a = (i < (data.size() - 1)) ? "}," : "}";
    output.println(a);
  }
  
  output.println("};");
  output.print('\n');
  
  //find the extreme values
  output.println("public static int[,] minAndMax = new int[,] {");
  for(int i = 0; i < data.size(); i++) {
    
    float max = 0.0f;
    float min = 1.0f;
    int maxId = 0;
    int minId = 0;
    float[] arrayNow = data.get(i);
    int arrayLength = arrayNow.length;
    for(int j = 0; j < data.size(); j++) {
      
      float val;
      if(j < arrayLength) {
        val = arrayNow[j];
      } else {
        val = data.get(j)[i];
      }
      
      if(val >= max && j != i) {
        max = val;
        maxId = j;
      }      
      if(val <= min) {
        min = val;
        minId = j;
      }      
    }
    
    output.print("{" + minId + ", " + maxId + "}");
    if(i < (data.size() - 1)) {
      output.println(",");
    } else {
      output.print('\n');
    }
    
  }
  output.println("};");
  output.println("}");
  
  output.flush();
  output.close();
}