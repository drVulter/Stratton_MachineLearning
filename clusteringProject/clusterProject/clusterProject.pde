import java.util.Random;
import java.util.*;

Table dataset;

int rowCount;
float xMin = MAX_FLOAT;
float xMax = MIN_FLOAT;
float yMin = MAX_FLOAT;
float yMax = MIN_FLOAT;
boolean drawOnce = true;
color[] colorValues = { #8000ff, #FF0000, #FFFF00, #0000FF};
float Svalue;

// mediod lists for medoid clustering
ArrayList<DataObject> mediods;
ArrayList<DataObject> nonMediods;
Random rand = new Random();

int clusterType = 2; // type of algorithm desired



/* Input variables */
ArrayList<DataObject> dataList ;
int numCategories = 2;
ArrayList<CentroidObject> centroidList;
boolean objectMoved;


void readInput() {

  rowCount = dataset.getRowCount();
  dataList = new ArrayList<DataObject>();
  centroidList =  new ArrayList<CentroidObject>();

  //int socialSecurityNumber;
  float x;
  float y;
  for ( int i = 0; i < rowCount; i++ ) {
    if ( i == 0 ) continue;  // The header
    //socialSecurityNumber = dataset.getInt(i, 0);
    x = dataset.getFloat(i, 1);
    y = dataset.getFloat(i, 2);
    DataObject dataObject = new DataObject(x, y);
    dataList.add(dataObject);
  }
  applyScaleToDataObjects();
}

void applyScaleToDataObjects() {

  // x  -- distance,  y -- speed 



  findMinMax();
  // print("new" + xMin + "," + xMax + "," + yMin + "," + yMax);

  for ( DataObject d : dataList) {
    d.applyScale(xMin, xMax, yMin, yMax);
  }
}

void findMinMax() {

  // Iterate over the dataList and update the xMin and yMin variables


  //Find Mininum value
  for ( DataObject d : dataList) {
    if ( d.xPos < xMin ) {
      xMin = d.xPos;
    }
    if (d.xPos > xMax) {
      xMax = d.xPos;
    }

    if ( d.yPos < yMin ) {
      yMin = d.yPos;
    }

    if (d.yPos > yMax) {
      yMax = d.yPos;
    }
  }
}



float randomFunc(float xVal, float yVal) {

  // In this function given the boundary points xVal and yVal, return a randomized number inbetween 
  float randomVal = 0;
  // Implement here 

  return randomVal;
}

void applyClusteringAlgorithm(int type) {
  // Generate a random number of size numCategory starting points
  //HashSet<DataObject> mapObject; 
  for ( int i = 0; i < numCategories; i++ ) {
    // Randomly apply centroid coordinate between 0 and 1 for each feature
    CentroidObject c = new CentroidObject(rand.nextFloat(), rand.nextFloat(), i);
    centroidList.add(c);
  }
  //System.out.println("Test");
  // WE iterate over all the data objects for each centroid value marking the data object to the closest centroid
  objectMoved = true;

  while ( objectMoved == true ) {
    objectMoved = false;
    if (type == 0)
      calculateCentroidAvg();
    else if (type == 1)
      calculateMedians();
  }
}

void calculateCentroidAvg() {
  for ( DataObject d : dataList ) {
    // d.minDistance = MAX_FLOAT;
    // Calculate centroid avg.

    for ( CentroidObject c : centroidList) {

      // Calculate the distance from the centroid object to the data object element d
      // If the calculate distance is smaller , and the centroid id is different 
      // then change d.mindistance and centroid id to the centroid object id

      double value1 = c.xPoint - d.scaledX;
      double value2 = c.yPoint - d.scaledY;
      float dataToObjectDist = (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
      if (dataToObjectDist < d.minDistance) {
        d.minDistance = dataToObjectDist;
        if ( d.centroidId != c.centroidId) {
          d.centroidId = c.centroidId;

          objectMoved = true;
        }
      }

      if ( d.centroidId == c.centroidId) {
        c.xAccum += d.scaledX;
        c.yAccum += d.scaledY;
        c.count += 1;
      }
    }

    // Update centroids coordinates through mean
    for (CentroidObject c : centroidList ) {
      c.xPoint = c.xAccum / c.count;
      c.yPoint = c.yAccum / c.count;
    }
  }
}

void calculateMedians() {
  for ( DataObject d : dataList ) {
    for ( CentroidObject c : centroidList) {
      double value1 = c.xPoint - d.scaledX;
      double value2 = c.yPoint - d.scaledY;
      float dataToObjectDist = (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
      if (dataToObjectDist < d.minDistance) {
        d.minDistance = dataToObjectDist;
        if ( d.centroidId != c.centroidId) {
          d.centroidId = c.centroidId;
          objectMoved = true;
        }
      }
      
    }
  }
  // Now update centroids
  for (CentroidObject c : centroidList) {
    //SortedList sortedX = new SortedList();
    //SortedList sortedY = new SortedList();
    ArrayList<Float> xVals = new ArrayList<Float>();
    ArrayList<Float> yVals = new ArrayList<Float>();
    for (DataObject d : dataList) {
      if (d.centroidId == c.centroidId) { // match
        xVals.add(d.scaledX); // add x val
        yVals.add(d.scaledY); // add y value
      }
    }
    Collections.sort(xVals);
    Collections.sort(yVals);
    //sortedX.printList();
    // now for each centroid, update its x and y based on median x and y
    int pos = xVals.size() / 2;
    c.xPoint = xVals.get(pos);
    c.yPoint = yVals.get(pos);
  }
    
}

// This is more involved
void calculateMediod() {
  // Assume 2 mediods
  mediods = new ArrayList<DataObject>();
  int mediodOnePos = rand.nextInt(dataList.size());
  int mediodTwoPos = rand.nextInt(dataList.size());
  while (mediodOnePos == mediodTwoPos)
    mediodTwoPos = rand.nextInt(dataList.size());
    
  mediods.add(dataList.get(mediodOnePos));
  mediods.add(dataList.get(mediodTwoPos));
  // set up mediods
  int i = 0;
  for (DataObject m : mediods) {
    m.mediodId = i;
    m.isMediod = true;
    i++;
  }
  // make a new list of non mediod items
  nonMediods = new ArrayList<DataObject>();
  for (DataObject d : dataList) {
    if (!d.isMediod)
      nonMediods.add(d);
  }
  // Now we perform the heavy lifting, first define temp objects for comparison

  // calculate the initial cost
  //float cost = calculateSSE(mediods, nonMediods);
  float newCost; // will be computed in loop
  // determine initial clusters
  for (DataObject d : nonMediods){
          float minDistance = Float.MAX_VALUE;
          for (DataObject med : mediods) {
            float value1 = med.scaledX - d.scaledX;
            float value2 = med.scaledY - d.scaledY;
            float dataToObjectDist = (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
            if (dataToObjectDist < minDistance) {
              minDistance = dataToObjectDist;
              d.mediodId = med.mediodId;
            }
          }
  }
  boolean improved = true; // was the error improved
  while (improved) {
    int mediodCount = 0; // keep track of which mediod m is
    int minCostIndex = -1;
    for (DataObject m : mediods) {
      int dataCount = 0; // keep track of which point d is
      improved = false;
      float cost = calculateSSE(mediods, nonMediods);
      for (DataObject d : nonMediods) {
        ArrayList<DataObject> tempMediods = new ArrayList<DataObject>(); // new set of mediods
        tempMediods.add(m);
        tempMediods.add(d);
        newCost = calculateSSE(tempMediods, nonMediods);
        if (Float.compare(newCost, cost) < 0) { //  new cost is less
          cost = newCost;
          minCostIndex = dataCount;
          improved = true;
        }
        tempMediods.clear();
        dataCount++;
      }
      if (improved) {
        // SWAP!!!!!
        mediods.get((mediodCount + 1) % 2).isMediod = false;
        DataObject temp = mediods.get((mediodCount + 1) % 2);
        nonMediods.get(minCostIndex).isMediod = true;
        mediods.set((mediodCount + 1) % 2, nonMediods.get(minCostIndex));
        nonMediods.set(minCostIndex, temp);
        nonMediods.clear();
        for (DataObject point : dataList) {
          if (!point.isMediod)
          nonMediods.add(point);
        }
        // recluster
        for (DataObject d : nonMediods){
          float minDistance = Float.MAX_VALUE;
          for (DataObject med : mediods) {
            float value1 = med.scaledX - d.scaledX;
            float value2 = med.scaledY - d.scaledY;
            float dataToObjectDist = (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
            if (dataToObjectDist < minDistance) {
              minDistance = dataToObjectDist;
              d.mediodId = med.mediodId;
            }
          }
        }
      }
      mediodCount++;
    }
  }
}
float calculateSSE(ArrayList<DataObject> mediods, ArrayList<DataObject> nonMediods) {
  float SSE = 0;
  // first compute clusters
  ArrayList<ArrayList<DataObject>> clusters = new ArrayList<ArrayList<DataObject>>();
  ArrayList<DataObject> cluster1 = new ArrayList<DataObject>();
  ArrayList<DataObject> cluster2 = new ArrayList<DataObject>();
  clusters.add(cluster1);
  clusters.add(cluster2);
  cluster1.add(mediods.get(0));
  cluster2.add(mediods.get(1));
  for (DataObject d : dataList){
    for (DataObject m : mediods) {
      float value1 = m.scaledX - d.scaledX;
      float value2 = m.scaledY - d.scaledY;
      float dataToObjectDist = (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
      if (dataToObjectDist < d.minDistance) {
        d.minDistance = dataToObjectDist;
        d.tempMediodId = m.mediodId;
      }
    }
  }
  for (DataObject d : dataList) {
    if (!mediods.contains(d)) {
      if (d.tempMediodId == 0) {
        cluster1.add(d);
      } else {
        cluster2.add(d);
      }
    }
  }
  for (ArrayList<DataObject> c : clusters) {
    for (DataObject d : c) {
      SSE += Math.pow(distance(c.get(0), d), 2);
    }
  }
  /*
  for (DataObject m : mediods) {
    for (DataObject d : dataList) {
      if (d.mediodId == m.mediodId) { // in the same  cluster
        SSE += Math.pow(distance(m, d), 2);
      }
    }
  }
  */
  // return final SSE
  return SSE;  
}
// takes in list of medoids, and list of non-medoids
void drawMediods(ArrayList<DataObject> mediods, ArrayList<DataObject> nonMediods) {
  float bigR = 10.0;
  float smallR = 5.0;
  for (DataObject m : mediods) {
    fill(colorValues[m.mediodId]);
    ellipse(m.xPos, m.yPos, bigR, bigR);
  }
  for (DataObject d : nonMediods) {
    fill(colorValues[d.mediodId]);
    ellipse(d.xPos, d.yPos, smallR, smallR);
  }
}
float distance(DataObject d1, DataObject d2) {
  float value1 = d1.scaledX - d2.scaledX;
  float value2 = d1.scaledY - d2.scaledY;
  return (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
}
void setup() {

  size(1000, 1000);
  dataset = new Table("locations.tsv");  
  readInput();   /// Read input , scaled each of the data object features (distance,speed) between 0 and 1
  
  if (clusterType == 0) {
    System.out.println("Clustering data based on k-means");
    applyClusteringAlgorithm(clusterType);
  } else if (clusterType == 1) {
    System.out.println("Clustering data based on k-medians");
    applyClusteringAlgorithm(clusterType);
  } else {
    calculateMediod();
  }
  

  /* Show all the test points as circles */
}

void drawCluster() {

  println("Drawing once !");
  for ( DataObject d : dataList ) {
    // Here is where to draw

    //  Convert to map coordinates (distance,speed)
    //  Draw  X  or O to represent coordinates
    print(d.xPos + " " + d.yPos + " -- ");

    d.drawDataObject(d.xPos, d.yPos, 5);
  }
}

// We are calling this function for every swapped m  ( so D -M  calls to this function, D = dataList.size() M = number of mediods)
/*void calculateSSE() {
     // This function iterates over all the mediods and finds the SSE value
     // In this case we can identify data object that are a mediods
     // This is a nexted loop iterating over mediods and the inner loop iterates over the data object
     
     float temporarySvalue = 0;
     for ( DataObject m : dataList ) {
         if ( m.isMediod == false) continue; 
         for ( DataObject d : dataList ) {
           if (d.isMediod == true) {
                   // calculate the value || x(i) - Cm || ^ 2
                    double value1 = d.scaledX - m.scaledX;
                    double value2 = d.scaledY - m.scaledY;
                    temporarySvalue += (float) ((Math.pow(value1, 2.0)) +  Math.pow(value2, 2.0));
                   
             
           }
         }
       
     }
     
     if (temporarySvalue < Svalue) {
           // find the swapped dataObject and set it as a mediod.
           Svalue = temporarySvalue;
     }
  
  
  
}
*/
void drawCentroid() {
  print(" Draw centroid callback ! ");
  for ( CentroidObject centroidObjects : centroidList) {
    float xValue = centroidObjects.xPoint * (xMax - xMin) + xMin;
    float yValue = centroidObjects.yPoint * (yMax - yMin) + yMin;
    print(" x value " + xValue + " y value  " + yValue + "\n");
    centroidObjects.drawCentroid(xValue, yValue, 10);
  }
}


void draw() {

  // This is where the visualization is.
  if (clusterType < 2) {
    if (drawOnce == true) {
      drawCluster();
      drawCentroid();
      drawOnce = false;
    }
  } else {
    if (drawOnce == true) {
      drawMediods(mediods, nonMediods);
      drawOnce = false;
    }
  }
}