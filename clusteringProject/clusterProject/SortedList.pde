class SortedList {
  private ArrayList<Float> list;
  public SortedList() {
    list = new ArrayList<Float>();
  }
  public ArrayList<Float> getList() {
    return list;
  }
  public void addSort(float x) {
    int pos = 0;
    for (float f : this.list) {
      if (Float.compare(x, f) >= 0) { // greater than
        this.list.add(pos, x);
      }
      pos++;
    }
  }
  public void printList() {
    for (float f : this.getList()) {
      System.out.println(f);
    }
  }
  //public float getVal(int n) {
  //  return list.get(n);
  //}
  
  public int getSize() {
    return list.size();
  }
}