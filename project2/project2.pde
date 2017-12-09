/*
Quinn Stratton
Prof. Lewis
Lewis University Machine Learning

Demonstrates use of k-NN algorithm for k = 1.

Calculates Macro and Micro Averages for Precision
*/

import java.util.ArrayList;

 
Evaluator eval;
Data data;

color[] colorValues = {#000000, #FF0000, #FFFF00, #0000FF};
    
void setup() {
  size(700,700);
  data = new Data("fruit_data_with_colors.txt");
  data.readData();
  data.sortData();
  data.classify();
  
  eval = new Evaluator(data.getTestingData());
  
  // Display Macro and Micro Avg.
  System.out.println("Micro Avg: " + eval.microAverage());
  System.out.println("Macro Avg: " + eval.macroAverage());
}

void drawTrainingData(ArrayList<Point> set) {
  for (Point p : set) {
    // Choose the color
    if (p.getLabel() == 1)
      fill(colorValues[0]);
    else if (p.getLabel() == 2)
      fill(colorValues[1]);
    else if (p.getLabel() == 3)
      fill(colorValues[2]);
    else 
      fill(colorValues[3]);
    
    // Draw the point
    ellipse(p.getX()*50, p.getY()*50, 5, 5);
  }
}
void drawTestingData(ArrayList<Point> set) {
  for (Point p : set) {
    if (p.getPredictedLabel() == 1)
      fill(colorValues[0]);
    else if (p.getPredictedLabel() == 2)
      fill(colorValues[1]);
    else if (p.getPredictedLabel() == 3)
      fill(colorValues[2]);
    else 
      fill(colorValues[3]);
    
    rect(p.getX()*50, p.getY()*50, 5, 5);
  }
  
}


void draw() {
  drawTrainingData(data.getTrainingData());
  drawTestingData(data.getTestingData());
}
 