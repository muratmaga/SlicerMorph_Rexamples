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
  


