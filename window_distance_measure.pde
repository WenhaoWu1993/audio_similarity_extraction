//ArrayList<float[]> measureWindowDistances(float[][] raw) {
//  ArrayList<float[]> windows = new ArrayList<float[]>();
  
//  int totalWindows = raw.length / windowWidth;
  
//  println("Number of windows: " + totalWindows);
//  //pixelScale = 800 / totalWindows;
  
//  Table table = new Table();
  
//  table.addColumn("frameId");
  
//  // -------------- loop through the "rows" (current windows) ----------------- //
//  for(int currentWindowId = 0; currentWindowId < totalWindows; currentWindowId++) {
//    float[] scores = new float[currentWindowId + 1];
    
//    // --------------------------------------- //
//    TableRow newRow = table.addRow();
//    newRow.setInt("frameId", currentWindowId);
//    table.addColumn(str(currentWindowId));
//    // --------------------------------------- //
    
//     // -------------- loop through the "columns" (compared windows) ----------------- //
//    for(int comparedWindowId = 0; comparedWindowId <= currentWindowId; comparedWindowId++) {      
//      float totalScore = 0;
      
//      // ---------------------- little frames inside the windows----------------------- //
//      for(int fi = 0; fi < windowWidth; fi++) {

//        int currentWindow_FrameId = currentWindowId * windowWidth + fi;
//        int comparedWindow_FrameId = comparedWindowId * windowWidth + fi;
                
//        totalScore += getCosineBetween(raw[currentWindow_FrameId], raw[comparedWindow_FrameId]);
//      }
//      // --------------------------- **************** --------------------------------- //
      
//      float score = totalScore / windowWidth;
//      scores[comparedWindowId] = score;
      
//      newRow.setFloat(str(comparedWindowId), scores[comparedWindowId]);
//    }
//    // -------------- ********************************************** ----------------- //
    
//    windows.add(scores);
    
//  }
  
  
//  saveTable(table, "data/" + filename + ".csv");
  
//  return windows;
//}

ArrayList<float[]> measureWindowDistances(float[][] raw, String beatFileName) {
  Table table = new Table();
  
  table.addColumn("beatId");

  ArrayList<float[]> windows = new ArrayList<float[]>();
  //int totalWindows = raw.length / windowWidth;
  Table beatsTable = loadTable(beatFileName + "Beats.csv", "header");
  
  int totalBeats = beatsTable.getRowCount();
  for(int i = 0; i < totalBeats; i++) {
    
    TableRow newRow = table.addRow();
    newRow.setInt("beatId", i);
    table.addColumn(str(i));
    
    //TableRow row = beatsTable.getRow(i);
    float[] scores = new float[i + 1];
    int frameId1 = beatsTable.getRow(i).getInt("frameId") * windowWidth;
    
    for(int j = 0; j <= i; j++) {
      int frameId2 = beatsTable.getRow(j).getInt("frameId") * windowWidth;
      float score = 0.0;
      
      for(int framex = 0; framex < windowWidth; framex++) {
        score += getCosineBetween(raw[frameId1 + framex], raw[frameId2 + framex]);
      }
      
      score /= windowWidth;
      scores[j] = score;
      newRow.setFloat(str(j), scores[j]);      
    }
    
    windows.add(scores);
    
  }
  
  saveTable(table, "data/" + filename + ".csv");

  println("size: " + windows.size());
  return windows;
}