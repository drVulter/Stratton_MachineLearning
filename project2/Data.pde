

class Data {
  private Table dataset;
  
  private ArrayList<Point> points;
  private ArrayList<Point> trainingData;
  private ArrayList<Point> testingData;
  
  
  public Data(String str) {
    dataset = new Table(str); 
    points = new ArrayList<Point>();
    trainingData = new ArrayList<Point>();
    testingData = new ArrayList<Point>();
  }
  
  public ArrayList<Point> getTrainingData() {
    return trainingData;
  }
  public ArrayList<Point> getTestingData() {
    return testingData;
  }
  public void readData () {
    int l; // input label
    String str;
    float h, w; // input field values
    int rowCount = dataset.getRowCount() - 1;
    
    for (int i = 0; i < rowCount; i++) {
      l = dataset.getInt(i+1, 0);
      str = dataset.getString(i+1, 1);
      w = dataset.getFloat(i+1, 4);
      h = dataset.getFloat(i+1, 5);
      points.add(new Point(w, h, l, str));
      
    }
  }
  
  // sort points into training and testing data
  public void sortData() {
    int i = 0; // counter
    for (Point p : points) {
      if (i % 4 == 0) // Testing data
        testingData.add(p);
      else // training data
        trainingData.add(p);
      
      i++; // increase counter
    }
  }
  // performs k-NN algorithm with
  public void classify() {
    
    float distance;
    float min;
    
    for (Point testP : testingData) {
      min = Float.MAX_VALUE;
      for (Point trainP : trainingData) {
        distance = (testP.getX() - trainP.getX()) * (testP.getX() - trainP.getX()) + (testP.getY() - trainP.getY()) * (testP.getY() - trainP.getY());
        if (Float.compare(distance, min) < 0) { // Closer so this is nearest neighbor
          min = distance;
          testP.setPredictedLabel(trainP.getLabel());
        }
      }
    }
  }
}