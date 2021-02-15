parser = function(file=NULL){
  source ("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.fcsv.R")
  source ("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.json.R")
  cut=function(x) return(strsplit(x,"=")[[1]][2])
  temp = unlist(lapply(X=readLines(file), FUN=cut))
  log = list()
  
  log$input.path = temp[3]
  log$output.path = temp[4]
  log$files = unlist(strsplit(temp[5],','))
  log$format = temp[6]
  log$no.LM = as.numeric(temp[7])
  if (is.na(temp[8])) log$skipped=FALSE else {
    log$skipped=TRUE
    log$skipped.LM=unlist(strsplit(temp[8],","))
  }
   
  if (as.logical(temp[9])) log$scale=TRUE else log$scale=FALSE
  log$MeanShape=temp[10]
  log$eigenvalues=temp[11]
  log$eigenvectors=temp[12]
  log$OutputData=temp[13]
  log$pcScores=temp[14]
  log$ID=gsub(pattern = paste0(".", log$format), "", fixed=T, log$files )
  
  if (!log$skipped) {
    log$LM = array(dim =c (log$no.LM, 3, length(log$files)), 
                   dimnames = list(1:log$no.LM, c("x", "y", "z"), log$ID))
    if (log$format!="mrk.json") 
      for (i in 1:length(log$files)) log$LM[,,i] = read.markups.fcsv(paste(log$input.path,log$files[i],sep = "/")) else 
        log$LM[,,i] = read.markups.json(paste(log$input.path,log$files[i],sep = "/"))
  } else {
    log$LM = array(dim = c(log$no.LM - length(log$skipped.LM), 3, length(log$files)), 
                   dimnames = list((1:log$no.LM)[-as.numeric(log$skipped.LM)], c("x", "y", "z"), log$ID))
    
    if (log$format!="mrk.json") 
      for (i in 1:length(log$files)) log$LM[,,i] = read.markups.fcsv(paste(log$input.path,log$files[i],sep = "/"))[-c(as.numeric(log$skipped.LM) ), ] else 
        for (i in 1:length(log$files)) log$LM[,,i] = read.markups.json(paste(log$input.path,log$files[i],sep = "/"))[-c(as.numeric(log$skipped.LM) ), ]  
    
  }
  
  
  return(log)
  
}
