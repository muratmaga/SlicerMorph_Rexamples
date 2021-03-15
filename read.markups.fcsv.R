read.markups.fcsv = function (file=NULL) {
  temp = read.csv(file=file, skip = 2, header = T)
  LM = array (data=as.matrix( temp[,2:4]),
              dim =c(nrow(temp), 3),
              dimnames=list(temp$label, c("X", "Y", "Z")))
  return(LM)
}
