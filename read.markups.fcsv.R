read.markups.fcsv = function (file=NULL) {
  temp = read.csv(file=file, skip = 2, header = T)
  return ( as.matrix (temp[, 2:4] ) )
}

