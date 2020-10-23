read.markups.json = function(file=NULL){
  if (!require(jsonlite)) {
        print("installing jsonlite")
        install.packages('jsonlite')
        library(jsonlite)
  }
  dat = fromJSON(file, flatten=T)
  n=length(dat$markups$controlPoints[[1]]$position)
  temp = array(dim = c(n, 3))
  for (i in 1:n) temp[i,] = dat$markups$controlPoints[[1]]$position[[i]]
  return(temp)
}