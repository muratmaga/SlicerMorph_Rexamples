# This script is based on geomorph 3.3.2.

library(geomorph)

# in this example we are using the output from the gorilla skull LMs data distributed by SlicerMorph
# first use the parser convenience function to pull all the files and analytical settings

source("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/log_parser.R")


# point to the location of the analysis.log file that was saved by SlicerMorph's GPA module
# either via coding the path
# SM.log.file="C:/Users/amaga/Desktop/2021-02-23_09_51_23/analysis.log"

# or interactively 
SM.log.file = file.choose()
SM.log = parser(SM.log.file)


#SM.log file contains pointers to all relevant data files.
head(SM.log)

SM.output = read.csv(file=paste(SM.log$output.path, 
                                SM.log$OutputData, 
                                sep="/"))
                                
SlicerMorph.PCs = read.table(file=paste(SM.log$output.path, 
                                        SM.log$pcScores, 
                                        sep="/"), 
                              sep = ",", header=T, row.names = 1)

# pull the metadata out of coords data frame and clean it
#PD = SM.output [,2]
# check the number of landmarks used in the analysis

if (!SM.log$skipped) no.LM=SM.log$no.LM else no.LM = SM.log$no.LM - length(SM.log$skipped.LM)

# reformat the coords into 3D LM array and apply sample names


Coords = arrayspecs(SM.output[,-c(1:3)], 
                    p=no.LM, 
                    k=3 )

dimnames(Coords) = list(1:no.LM, 
                        c("x","y","z"),
                        SM.log$ID)

# construct a geomorph data frame withe data imported from SlicerMorph and 
# fit a model to SlicerMorph's GPA aligned coordinates and centroid sizes
gdf = geomorph.data.frame(Size = SM.output$centeroid, Coords = Coords)
fit.slicermorph = procD.lm(Coords~Size, data = gdf)


# Second part of the script uses the raw LM coordinates directly into R/geomorph,
# aligns them with gpagen(), applies PCA, and builds the same allometric regression model 
# and then compares it to the results obtained above. 

gpa <- gpagen(SM.log$LM)
pca  = gm.prcomp(gpa$coords)
geomorph.PCs = pca$x
gdf2 = geomorph.data.frame(size = gpa$Csize, coords = gpa$coords)
fit.rawcoords = procD.lm(coords~size, data = gdf2)

# due to arbitrary rotations, we cannot compare procrustes coordinates directly, 
# instead we look centroid sizes, procD, PC scores, and allometric regression model summary
# geomorph does not report each sample's procD to the consensus shape

pd = function(M, A) return(sqrt(sum(rowSums((M-A)^2))))
geomorph.PD = NULL
for (i in 1:length(SM.log$files)) geomorph.PD [i] = pd(gpa$consensus, gpa$coords[,,i])

#We can start to compare procrustes variables

par(mfrow=c(2,2))

# 1. Centroid Size
plot(gpa$Csize, SM.output$centeroid, 
     pch=20, ylab='SlicerMorph', 
     xlab = 'geomorph', main = "Centroid Size")
cor(gpa$Csize, SM.output$centeroid)

# 2. Procrustes Distance of sample to their respective mean
plot(geomorph.PD, SM.output[,2], 
     pch=20, ylab='SlicerMorph', 
     xlab = 'geomorph', main = "Procrustes Distance")
cor(geomorph.PD, SM.output[,2])

# 3. We only plot the first two PCs but correlations reported up to 10
# Keep in mind that PCA signs are arbitrary. 

plot(geomorph.PCs[,1], SlicerMorph.PCs[,1], 
     pch=20, ylab='SlicerMorph', 
     xlab = 'geomorph', main = "PC1 scores")

plot(geomorph.PCs[,2], SlicerMorph.PCs[,2], 
     pch=20, ylab='SlicerMorph', 
     xlab = 'geomorph', main = "PC2 scores")

for (i in 1:10) print (cor (SlicerMorph.PCs[,i], 
                            geomorph.PCs[,i]))

# Compare allometric regression models from SLicerMorph aligned coordinates
# to the one that used raw coordinates and gpa alignment from geomorph
summary(fit.slicermorph)

summary(fit.rawcoords)




