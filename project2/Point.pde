class Point {

  private float x; // width
  private float y; // height
  private int label; // Designates the class
  private int predictedLabel; // Label redicted by k-NN
  private String labelString; // Designates the class

  public Point (float w, float h, int l, String str) {
    x = w;
    y = h;
    label = l;
    predictedLabel = l; // Initialize to correct
    labelString = str;
  }
  
  public String getlabelString() {
    return labelString;
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public int getLabel() {
    return label;
  }
  public int getPredictedLabel() {
    return predictedLabel;
  }
  public void setPredictedLabel(int l) {
    predictedLabel = l;
  }
  
  public boolean isCorrect() {
    return (label == predictedLabel); // If equal -> true, else -> false
  }
}