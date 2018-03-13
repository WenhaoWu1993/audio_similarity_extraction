void visualize(String n) {
  Table table = loadTable(n);
  
  for(int row = 1; row < table.getRowCount(); row++) {
    float x = row - 1;
    for(int col = 1; col < table.getRowCount(); col++) {
      float y = height - (col - 1);
      float score;
      if(col <= row) {
        score = table.getFloat(row, col);
      }
      else {
        score = table.getFloat(col, row);
      }
      int c = int(map(score, -1.0, 1.0, 0, 255));
      stroke(c);
      line(x, y, x + 1, y);
    }
  }
  save("data/" + filename + ".png");
}