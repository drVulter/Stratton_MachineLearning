/*
Quinn Stratton
Prof. Lewis
Lewis University Machine Learning

Demonstrates use of k-NN algorithm for k = 1.
*/

Table dataset; // Table object from Table class

int rowCount;

color[] colorValues = {#000000, #FF0000, #FFFF00, #0000FF};

/* Input variables */
int[] labelInput;
String[] labelString;

float[] widthInput;
float[] heightInput;

// Training variables
int trainDataCount;
int[] labelTrain;
float[] widthTraining;
float[] heightTraining;
// Testing variables
int testDataCount;
int[] labelTest;
int[] predictedLabelTest;
float[] widthTest;
float[] heightTest;

// Prediction variables
int[] predictedTestType; 

// Sorts data from input arrays into arrays specifically for testing and training data
void sortData() { // pass in input arrays?
  int j = 0; // Counters
  int k = 0;
  testDataCount = (rowCount + (4 - (rowCount % 4))) / 4;
  trainDataCount = rowCount - testDataCount;
  // Testing values
  labelTest = new int[testDataCount];
  widthTest = new float[testDataCount];
  heightTest = new float[testDataCount];
  // Training Values
  labelTrain = new int[trainDataCount];
  widthTraining = new float[trainDataCount];
  heightTraining = new float[trainDataCount];
  // Fill Test data array
  for (int row = 0; row < rowCount; row++) {
    if ((row % 4) == 0) { // Test data
      labelTest[j] = labelInput[row];
      widthTest[j] = widthInput[row];
      heightTest[j] = heightInput[row]; 
      j++;
    } else {
      labelTrain[k] = labelInput[row];
      widthTraining[k] = widthInput[row];
      heightTraining[k] = heightInput[row];
      k++;
    }
  }
}

// Finds minumum Euclidean distance between each testing point and each training point.
// Assigns a predicted label to each test point based on which training point is closest.
void predictTestType() {
  predictedLabelTest = new int[testDataCount];
  double minDistance;
  double distance;
  for (int i = 0; i < testDataCount; i++) {
    minDistance = Double.MAX_VALUE;
    for (int j = 0; j < trainDataCount; j++) {
      distance = Math.sqrt(Math.pow((widthTest[i] - widthTraining[j]), 2) + Math.pow((heightTest[i] - heightTraining[j]), 2));
      if (Double.compare(distance, minDistance) < 0) { // closer, so make this nearest neghbor
        minDistance = distance; 
        predictedLabelTest[i] = labelTrain[j];
      }
    }
  }
}

// Returns the accuracy rate for the nearest neighbor algorithm.
double testAccuracy() {
  // Gather all the test data whose type is the correct type and divide that by total number of data points
  int numCorrect = 0;
  for (int i = 0; i < testDataCount; i++) {
    if (labelTest[i] == predictedLabelTest[i])
      numCorrect++;
  }
  return (double)numCorrect / (double)testDataCount;
  // return the result
}

// Reads data from csv file and puts it into different arrays for different values.
void readInput() {
  rowCount = dataset.getRowCount() - 1;
  labelInput = new int[rowCount];
  labelString = new String[rowCount];
  widthInput = new float[rowCount];
  heightInput = new float[rowCount];
  // First row contains labels, so start at 1!!!
  for (int row = 0; row < rowCount; row++) {
    labelInput[row] = dataset.getInt(row + 1, 0); // Access first element in row "labelId"
    labelString[row] = dataset.getString(row + 1, 1);
    widthInput[row] = dataset.getFloat(row + 1, 4);
    heightInput[row] = dataset.getFloat(row + 1,5);
  }
}

// Done once before visualization
void setup() { 
  size(700,700);
  dataset = new Table("fruit_data_with_colors.txt");
  readInput();
  sortData();
  // 
  predictTestType();
  // Display the accuracy
  System.out.println("Accuracy: " + testAccuracy());
  
}

// Draw training data points as circles
// Color is based on which class each point is in.
void drawTrainingData() {
  for (int i = 0; i < trainDataCount; i++) {
    if (labelTrain[i] == 1)
      fill(colorValues[0]);
    else if (labelTrain[i] == 2)
      fill(colorValues[1]);
    else if (labelTrain[i] == 3)
      fill(colorValues[2]);
    else
      fill(colorValues[3]);
      
    ellipse(widthTraining[i] * 50, heightTraining[i] * 50, 5, 5); 
  }
}

// Draw testing data as squares.
// Color is based on the PREDICTED class.
void drawTestData() {
  for (int i = 0; i < testDataCount; i++) {
    if (predictedLabelTest[i] == 1)
      fill(colorValues[0]);
    else if (predictedLabelTest[i] == 2)
      fill(colorValues[1]);
    else if (predictedLabelTest[i] == 3)
      fill(colorValues[2]);
    else
      fill(colorValues[3]);
    rect(widthTest[i] * 50, heightTest[i] * 50, 5, 5);
  }
  
}
// This is where visualization is
void draw() {
  // show all test points as circles
  drawTrainingData();
  drawTestData();
}  