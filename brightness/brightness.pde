import java.util.Arrays;
import java.util.Random;

PImage source;
PImage destination;

void setup() {
  String inputFileName = "example.jpg"; // change me!
  source = loadImage(inputFileName);
  destination = createImage(source.width, source.height, RGB);
  size(4032, 3024); // change me!
  
  source.loadPixels();
  destination.loadPixels();
  
  int w = source.width;
  int h = source.height;
  int loc;
    
  // for each column
  for(int j = 0; j < w; j++) {
    // get pixels in column
    color[] col = new color[h];
    for(int i = 0; i < h; i++) {
      loc = (w * i) + j;
      col[i] = source.pixels[loc];
    }
    
    // sort column on brightness
    pixelSort(col);
    
    // rebuild
    for(int i = 0; i < h; i++) {
      loc = (w * i) + j;
      destination.pixels[loc] = col[i];
    }
    
    System.out.println("sorting column: " + (j + 1) + " / " + w);
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
void pixelSort(color a[]) {  
  color[] t = new color[a.length];
  pixelSortHelper(0, a.length-1, t, a);
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