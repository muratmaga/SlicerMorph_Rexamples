# SlicerMorph_Rexamples
Some functions to import SlicerMorph data into R

* **read.markups.fcsv.R:** utility function to read a FCSV formatted markups file into R as a matrix. 
* **read.markups.json.R:** utility function to read a JSON formatted markups file into R as a matrix.
* **geomorph_regression.R:** an example of how to conduct allometric regression with SlicerMorph data. It also compares results SlicerMorph GPA results to the one derived from R/geomorph using the raw LM coordinates.  
* **log_parser.R:** Since ?/?/? SlicerMorph's GPA module outputs a log file that contains summary of settings used in the GPA analysis, including input/output folders, filenames, formats, number of landmarks, excluded (if any) landmarks, centroid size scaling, and the output files. This Rscript parses this log file and returns a named list with: 
  * $input.path = Unix style path to input folder with landmark files.
  * $output.path = Unix stype path to the output folder created by GPA
  * $files = files included in the analysis
  * $format = format of landmark files ("fcsv" or "mrk.json")
  * $no.LM = number of landmarks original
  * $skipped = If any landmark is omitted in GPA (TRUE/FALSE) 
  * $skippedLM = Indices of skipped LMs (created only if $skipped=TRUE)
  * $scale = are data scaled by centroid sizes (TRUE/FALSE)
  * $MeanShape = filename that contains mean shape coordinates calculated by GPA (csv format)
  * $eigenvalues = filename that contains eigenvalues as calculated by PCA in the SlicerMorph GPA (csv format)
  * $eigenvectors = filename that contains eigenvectors as calculated by PCA in the SlicerMorph GPA (csv format)
  * $OutputData = filename that contains procrustes distances, centroid sizes and procrustes aligned coordinates as calculated by the SlicerMorph GPA (csv format)
  * $pcScores = filename that contains individal PC scores of specimens as calculated by PCA in the SlicerMorph GPA (csv format)
  * $ID = list of specimen identifiers
  * $LM = 3D landmark array that contains the 3D raw coordinates as inputed to the SlicerMorph GPA module. 
  

Example for usage:

```
slicermorph.log = parser("C:/temp/RemoteIO/Gorilla_Skull_LMs/2021-02-14_20_31_08/analysis.log")
slicermorph.log
$input.path
[1] "C:/temp/RemoteIO/Gorilla_Skull_LMs"

$output.path
[1] "C:/temp/RemoteIO/Gorilla_Skull_LMs/2021-02-14_20_31_08"

$files
 [1] "USNM174715.fcsv" "USNM174722.fcsv" "USNM176209.fcsv" "USNM176211.fcsv" "USNM176216.fcsv" "USNM176217.fcsv" "USNM176219.fcsv" "USNM220060.fcsv"
 [9] "USNM220324.fcsv" "USNM252575.fcsv" "USNM252577.fcsv" "USNM252578.fcsv" "USNM252580.fcsv" "USNM297857.fcsv" "USNM582726.fcsv" "USNM590942.fcsv"
[17] "USNM590947.fcsv" "USNM590951.fcsv" "USNM590953.fcsv" "USNM590954.fcsv" "USNM599165.fcsv" "USNM599166.fcsv" "USNM599167.fcsv"

$format
[1] "fcsv"

$no.LM
[1] 41

$skipped
[1] TRUE

$skipped.LM
[1] "2" "5"

$scale
[1] TRUE

$MeanShape
[1] "MeanShape.csv"

$eigenvalues
[1] "eigenvalues.csv"

$eigenvectors
[1] "eigenvectors.csv"

$OutputData
[1] "OutputData.csv"

$pcScores
[1] "pcScores.csv"

$ID
 [1] "USNM174715" "USNM174722" "USNM176209" "USNM176211" "USNM176216" "USNM176217" "USNM176219" "USNM220060" "USNM220324" "USNM252575" "USNM252577" "USNM252578"
[13] "USNM252580" "USNM297857" "USNM582726" "USNM590942" "USNM590947" "USNM590951" "USNM590953" "USNM590954" "USNM599165" "USNM599166" "USNM599167"

$LM
, , USNM174715

         x       y        z
1  109.052 330.204 -145.974
3  110.219 302.200  -90.294
4  108.310 277.344 -104.794
6  105.322 247.262 -160.655
7  104.120 216.875 -161.930
8  115.219 248.361 -163.103
9   96.477 250.035 -161.909
10 124.845 228.813 -163.066
11  83.867 231.951 -164.245
12 123.799 247.726 -152.625
13  87.248 250.436 -152.417
14 135.077 242.119 -156.270
15  76.806 247.522 -157.415
16 147.073 241.854 -148.405
17  63.615 247.968 -149.114
18 109.204 317.471  -49.629
19 113.150 370.320  -81.992
20 114.585 396.356 -109.469
21 115.856 425.428 -114.843
22 146.768 308.070  -44.644
23  74.466 308.204  -44.069
24 167.416 305.503  -62.399
25  53.369 309.436  -64.076
26 121.927 317.355  -67.878
27  98.712 319.667  -68.433
28 135.290 335.572  -82.003
29  88.233 338.132  -81.677
30 189.805 319.435  -97.287
31  30.603 325.303  -97.325
32 177.433 348.702 -119.148
33  45.960 353.062 -118.888
34 145.356 360.558  -95.963
35  80.589 363.414  -94.897
36 133.703 389.407  -99.580
37  95.101 391.181  -99.629
38 132.915 422.538 -115.415
39  98.294 424.504 -114.410
40 149.204 398.656 -136.732
41  78.318 401.286 -135.298

, , USNM174722

         x       y        z
1  111.058 335.636 -137.448
3  109.344 304.891  -93.659
4  105.373 275.882 -109.091
6  103.508 246.133 -153.060...
```
