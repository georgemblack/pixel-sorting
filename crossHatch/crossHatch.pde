import java.util.Arrays;
import java.util.Random;

PImage source;
PImage destination;

void setup() {
  String inputFileName = "example.jpg"; // change me!
  source = loadImage(inputFileName);
  destination = createImage(source.width, source.height, RGB);
  
  source.loadPixels();
  destination.loadPixels();
  
  Random rand = new Random();
  int loc, mid, range, start, end;
  int w = source.width;
  int h = source.height;
  
  // for each column
  for(int j = 0; j < w; j++) {
    // get pixels in column
    color[] col = new color[h];
    for(int i = 0; i < h; i++) {
      loc = (w * i) + j;
      col[i] = source.pixels[loc];
    }
    
    // select range of pixels within column
    mid = rand.nextInt(h);
    range = rand.nextInt(h/4);
    start = mid - range;
    end = mid + range;
    if(start < 0) start = 0;
    if(end >= h) end = h - 1;
    
    // sort on brightness
    pixelSort(col, start, end);
    
    // rebuild
    for(int i = 0; i < h; i++) {
      loc = (w * i) + j;
      destination.pixels[loc] = col[i];
    }
    System.out.println("sorting segment:\t" + (j + 1) + " / " + (w + h));
  }
  
  // for each row
  for(int i = 0; i < h; i++) {
    // get pixels in row
    color[] row = new color[w];
    for(int j = 0; j < w; j++) {
      loc = (w * i) + j;
      row[j] = destination.pixels[loc];
    }
    
    // select range of pixels within row
    mid = rand.nextInt(w);
    range = rand.nextInt(w/4);
    start = mid - range;
    end = mid + range;
    if(start < 0) start = 0;
    if(end >= w) end = w - 1;
    
    // sort on brightness
    pixelSort(row, start, end);
    
    // rebuild
    for(int j = 0; j < w; j++) {
      loc = (w * i) + j;
      destination.pixels[loc] = row[j];
    }
    System.out.println("sorting segment:\t" + (i + w + 1) + " / " + (w + h));
  }
  
  destination.updatePixels();
  destination.save(inputFileName + "-output.tif");
  System.out.println("image saved!");
}

void draw() {
  //image(destination,0,0);
}

// a basic mergesort implementation
// sorts pixels in given array based on brightness
void pixelSort(color a[], int start, int end) {  
  color[] t = new color[a.length];
  pixelSortHelper(start, end, t, a);
}

void pixelSortHelper(int low, int high, color[] t, color[] a) {
  if(low < high) {
    int mid = low + (high - low) / 2;
    pixelSortHelper(low, mid, t, a);
    pixelSortHelper(mid + 1, high, t, a);
    for(int i = low; i <= high; i++) {
      t[i] = a[i];
    }
    int i = low, j = mid + 1, k = low;
    while(i <= mid && j <= high) {
      if(brightness(t[i]) > brightness(t[j])) {
        a[k] = t[i];
        i++;
      } else {
        a[k] = t[j];
        j++;
      }
      k++;
    }
    while(i <= mid) {
      a[k] = t[i];
      k++;
      i++;
    }
  }
}