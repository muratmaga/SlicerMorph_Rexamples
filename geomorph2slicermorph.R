#use the sample data at https://github.com/SlicerMorph/Mouse_Models

library(SlicerMorphR)
setwd("/Users/amaga/Desktop/Mouse_Models/LMs/")
f=dir(patt='fcsv')
no.LM=51

lm=array(dim=c(no.LM, 3, length(f)))

for (i in 1:length(f)) lm[,,i] = read.markups.fcsv(f[i])

#geomorph
library(geomorph)

gpa = gpagen(lm)
pca = gm.prcomp(A=gpa$coords)

dir.create('geomorph_out')
setwd('geomorph_out')

#write the MeanShape.csv file
temp = cbind(paste("LM", 1:no.LM), gpa$consensus)
write.csv(file='MeanShape.csv', temp, row.names = FALSE, quote = FALSE)

#write pcScores.csv file
temp = pca$x
dimnames(temp) = list(f, paste("PC", 1:dim(temp)[2]))
write.table(file='pcScores.csv', temp, row.names = TRUE, sep=',', quote = FALSE)

#write the OutputData.csv file

pd <- function(M, A) sqrt(sum(rowSums((M-A)^2)))
PD = NULL
for (i in 1:length(f)) PD[i] <- pd(gpa$consensus, gpa$coords[,, i])
temp = cbind(PD, gpa$Csize, two.d.array(gpa$coords))

tt=NULL
for (i in 1:no.LM) tt=c(tt, paste0("LM ", rep(i,3), c("_X", "_Y", "_Z")))
header=c("Sample_name","proc_dist","centeroid", tt)
file='OutputData.csv'
writeLines(con=file, paste(header, collapse=','))
for (i in 1:nrow(temp)) cat(file=file, paste(f[i], paste(temp[i,], collapse=','), sep=","), sep="\n", append=TRUE)

#write eigenvalues.csv file 
temp = cbind(paste("PC", 1:dim(pca$x)[2]), as.vector(pca$d))
file="eigenvalues.csv"
#writeLines(con=file, "")
for (i in 1:nrow(temp)) cat(file=file, paste(temp[i,], collapse=','), sep="\n", append=TRUE )

#write eigenvector.csv file
temp = t(pca$rotation)
file="eigenvector.csv"
cat(file=file, paste(c("", paste("PC", 1:dim(temp)[1])), collapse=","), sep="\n")
t1=gsub('.', "_", colnames(temp), fixed=TRUE)

for (i in 1:nrow(temp)) cat(file=file, paste(t1[i], paste(temp[i,], collapse=','), sep=','), sep="\n", append=TRUE)

#write analysis.log
header=c("Date=2023-09-24", 
"Time=20:23:30", 
"InputPath=NULL", 
"OutputPath=NULL", 
"LM_format=.fcsv",
"NumberLM=",
"ExcludedLM=",
"Scale=True",
"MeanShape=MeanShape.csv",
"eigenvalues=eigenvalues.csv",
"eigenvectors=eigenvectors.csv",
"OutputData=OutputData.csv",
"pcScores=pcScores.csv",
"SemiLandmarks=")
file="analysis.log"

for (i in 1:length(header)) cat(file=file, paste(header[i]), sep="\n", append=TRUE)


