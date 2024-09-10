# Artificial vision system for traffic signs

This practical project aims to develop a set of algorithms that allow the identificationof objects in an inspection area. This system is able to target different traffic signals, identifying its relative position. 

| Brief Vision System                                                                    |
|----------------------------------------------------------------------------------|
| Implementation of techniques for image-enhancement:                              |
|         o  Noise reduction                                                           |
|         o  Contrast improvement                                                      |
|                                                                                  |
| Implementation of image analysis techniques to:                                  |
|         o  Determine the contour, area, and centroid of any object desired.          |              
|                                                                                  |
| Algorithm to distinguish all available signals:                                  |
|         o  Algorithm for separation of objects by type of color.                     |
|         o  Algorithm for separation of objects by shape.                             |
|                                                                                  |
| Image acquisition in real-time.                                                  |

- **Image Acquisition**: Image acquisition in real time.
- **Histogram Processing**: Histogram equalization (Grayscale Images, Color Images).
- **Color Transformation**: HSV, Hue, Saturation, Value application (RGB to HSV, HSV to RGB).
- **Measure Properties**: Area, centroid, blob bounding box, connected components.
- **Use of Structuring Elements**: Kernel.
- **Morphological operations**: Dilation, Erosion, Opening, Closing.
- **Thresholds**: Manual and automatic thresholds (Niblack).
- **Filter**: Filtering image (Convolution matrix; Low-pass Filters, High-pass Filters).
- **Mask**: Application of yellow, red, and blue masks.
- **Shape Detection**: Circle, Triangles, Rectangles, Squares


# Image Processing for Traffic Signs

## 1. Image Acquisition

- **Real-Time Image Acquisition**:
  - The camera captures images in real-time in this case laptop webcam, which are displayed and processed frame by frame in MATLAB. Continuous acquisition allows each frame to be individually analyzed and processed to detect traffic signs.

- **Image Capture Function**:
  - The capture function activates the camera and starts capturing frames, displaying the live video in a graphical window in MATLAB. At each time interval, the image is sent to the processing function. A timer is set to ensure the capture function runs at regular intervals.


## 2. Image Preprocessing

- **Noise Reduction**:
  - Preprocessing removes unwanted visual interferences, such as noise caused by lighting variations or small imperfections in the environment. Techniques such as smoothing filters or morphological operations help clean the image before segmentation.

- **Artifact Reduction**:
  - Undesirable artifacts, such as small and disconnected objects, are eliminated to ensure the analysis focuses only on relevant regions of the image.

- **Contrast Adjustment (Histogram Equalization)**:
  - Histogram equalization is a method that adjusts the image’s contrast by redistributing pixel intensities to make dark areas more visible. This is done especially in the HSV color space (hue, saturation, and value).

- **Applying Equalization to HSV Channels**:
  - First, the image is converted from RGB to HSV. Then, the saturation (S) and value (V) channels of the image are individually equalized, improving contrast without affecting the hue (H). This allows objects of interest in specific colors (like traffic signs) to stand out better.

- **Restoring the Image**:
  - After histogram equalization, the adjusted HSV channels are converted back to RGB, creating an image with enhanced contrast. This facilitates processing and color segmentation in later stages.

## 3. Filtering

- **Color Filters**:
  - Traffic signs are identified based on their predominant color (yellow, blue, or red). Binary masks are created by applying a color filter that isolates areas of the image that match these specific colors.

- **Creating Binary Masks**:
  - **Region Isolation**: The binary mask (e.g., yellowMask) is created to isolate regions of the image corresponding to the yellow color. This is done by applying a threshold in the HSV space, separating pixels within the desired color range.
  - **Morphological Operations**:
    - **Morphological Closing**: A morphological closing filter is applied to eliminate small gaps or breaks in the segmented regions, connecting fragmented parts of the sign.
    - **Hole Filling**: After closing, internal holes or empty areas in the masks are filled to improve the continuity and robustness of detection.

- **Connected Component Analysis**:
  - After applying the color filter and creating the binary mask, the connected components algorithm identifies continuous areas of connected pixels belonging to the same color region.
  - **Selecting the Largest Component**: Among the connected components, the largest one in terms of area is selected as the traffic sign to be processed. Smaller components, such as noise, are discarded.
  - **Creating the Final Binary Image**: The largest component is converted into a new binary image, where the pixels of interest (the sign region) are highlighted, and the rest are ignored.

- **Applying Filters to Different Colors**:
  - The filtering process described above is repeated for the three traffic sign colors:
    - **Yellow**: The binary mask isolates yellow regions and applies morphological operations and connected components.
    - **Blue**: The same process is repeated with a blue color filter.
    - **Red**: The red mask isolates regions of red traffic signs.

## 4. Image Segmentation

- **Binary Masks for Segmentation**:
  - Binary masks isolate regions of interest in the image. They convert the color image into a two-level (binary) representation, where the pixels belonging to the filtered color are white (1), and the others are black (0).

- **Thresholding**:
  - Manual thresholding is applied to convert the grayscale image into a binary image, setting a cut-off value that separates light and dark pixels. This is essential for identifying areas where the objects of interest are located, especially in images with lighting variations.
  - **Grayscale Conversion**: The image is first converted to grayscale, allowing for finer control when applying the threshold.
  - **Applying the Threshold**: A manual threshold value is chosen, and pixels above this threshold become white (1), while those below become black (0).

- **Binary Value Inversion**:
  - For certain analyses, the binary image is inverted, turning black pixels into white and vice versa. This helps in identifying objects and eliminating unwanted areas.

## 5. Image Analysis

- **Regionprops (Property Extraction)**:
  - The regionprops function extracts various geometric properties from the segmented objects in the image, such as:
    - **Area**: Calculates the total number of pixels occupied by the object.
    - **Centroid**: Determines the central position of the object, essential for locating the traffic sign.
    - **Major and Minor Axes**: Measures the length of the major and minor axes of the region, used to calculate the aspect ratio and identify the shape of the object.
    - **Circularity**: Circularity measures how round the region is by comparing the object’s area to its perimeter. A high circularity (close to 1) indicates the object is a circle.

- **Bounding Box**:
  - The BoundingBox is the smallest rectangular box that can contain the object. It is used to define the boundaries of the detected area and compare its shape with expected traffic sign properties.

- **Connected Component Analysis**:
  - This algorithm identifies groups of connected pixels in the image, which are treated as distinct objects. Connected component analysis helps isolate the traffic sign from the background and identify objects based on size.

## 6. Shape Recognition

- **Geometric Shape Detection**:
  - After segmentation, the next step is to identify the sign’s shape. The geometric shapes detected include:
    - **Circles**: Detected by high circularity and symmetry.
    - **Triangles**: Identified by the ratio between their axes and the fill of their BoundingBox.
    - **Squares and Rectangles**: Differentiated based on the ratio between their axes (width-to-height ratio).
    - **Pentagons**: Classified as the “remaining shape” for objects that do not fit into the other regular shapes.

- **Classification by Circularity and Axes**:
  - The ratio between the major and minor axes, as well as circularity, are used as criteria to classify the object. For example, a circularity close to 1 identifies the object as a circle, while a high ratio between the major and minor axes may indicate a rectangle.

## 7. Object Counting

- **Object Counting Function**:
  - This function counts the number of internal objects present in the sign, such as numbers or additional figures. Signs like "No turning right" or "Speed limit 50 km/h" contain multiple objects, and counting helps differentiate them.

- **Noise Removal**:
  - Small objects with an area of less than 100 pixels are considered noise and removed. After this removal, the final count of objects present in the processed sign is performed.

