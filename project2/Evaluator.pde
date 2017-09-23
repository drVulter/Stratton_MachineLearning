// Assumes 4 categories
class Evaluator {
  private ArrayList<Point> data;
  private final int NUM_CATEGORIES = 4;
  
  public Evaluator(ArrayList<Point> points) {
    data = points;
    
  }
  // Computes Macro average, assumes 4 categories
  public float macroAverage() {
    int num1, num2, num3, num4; // Number of True positives in each category
    num1 = num2 = num3 = num4 = 0;
    int size1, size2, size3, size4; // Total number of points in each category
    size1 = size2 = size3 = size4 = 0;
    // Go through all testing points and adjust the size of each category, and the number of TP for that category
    for (Point p : data) {
      if (p.getLabel() == 1) {
        size1++;
        if (p.isCorrect())
          num1++;
      } else if (p.getLabel() == 2) {
        size2++;
        if (p.isCorrect())
          num2++;
      } else if (p.getLabel() == 3) {
        size3++;
        if (p.isCorrect())
          num3++;
      } else  {
        size4++;
        if (p.isCorrect())
          num4++;
      }
    }
    // Calculate and return Macro Average
    return ((float)num1 / (float)size1 + (float)num2 / (float)size2 + (float)num3 / (float)size3 + (float)num4 / (float)size4) / (float)NUM_CATEGORIES;
    
  }
  
  public float microAverage() {
    int numCorrect = 0;
    for (Point p : data) {
      if (p.isCorrect())
        numCorrect++;
    }
    return (float)numCorrect / (float)data.size();
  }
}