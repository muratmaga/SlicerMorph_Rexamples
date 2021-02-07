# This script is based on geomorph 3.3.2.
# First part shows how to reformat the SlicerMorph GPA output to the data shape geomorph expects 

source("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.fcsv.R")
source("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.json.R")

library(geomorph)

# we are using the output from the gorilla skull LMs data distributed by SlicerMorph
# 41 LMs and with scaling enabled option

# provide the path to the output folder created by SlicerMorph's gpa module
path.to.output="C:/temp/RemoteIO/Gorilla_Skull_LMs/2020-09-19_22_17_05/"

coords = read.csv(file=paste(path.to.output,"OutputData.csv", sep='/'))
SlicerMorph.PCs = read.table(file=paste(path.to.output,"pcScores.csv", sep='/'), sep = ",", header=T, row.names = 1)

# pull the metadata out of coords data frame and clean it
sample.name = coords[,1]
Csize= coords[,3]
PD = coords [,2]
coords = coords [,-c(1:3)]
rownames(coords) = sample.name

# identify number of landmarks
n.lm = length(colnames(coords)) / 3

# reformat the coords into 3D LM array and apply sample names
coords = arrayspecs(coords, p=n.lm, k=3 )
dimnames(coords) = list(1:n.lm, 
                          c("x","y","z"),
                          sample.name)

# construct a geomorph data frame withe data imported from SlicerMorph and 
# fit a model to SlicerMorph's GPA aligned coordinates and centroid sizes
gdf = geomorph.data.frame(size = Csize, coords = coords)
fit.slicermorph = procD.lm(coords~size, data = gdf)


# Second part of the script reads the raw LM coordinates directly into R/geomorph,
# aligns them with gpagen(), applies PCA, and builds the same allometric regression model 

# modify path variable to the correct location of Gorilla Skull landmarks datasets.
# this is typically one level above the output folder
fcsvs=paste0(path=paste(path.to.output,'../', sep="/"), sample.name, '.fcsv')
if (!all(file.exists(fcsvs))) print ("missing files, check path")

n=length(fcsvs)
LMs=array(dim=c(n.lm, 3, n))

for (i in 1:n) LMs[,,i] = read.markups.fcsv(fcsvs[i])


gpa <- gpagen(LMs)
pca  = gm.prcomp(gpa$coords)
geomorph.PCs = pca$x
gdf2 = geomorph.data.frame(size = gpa$Csize, coords = gpa$coords)
fit.rawcoords = procD.lm(coords~size, data = gdf2)


# due to arbitrary rotations, we cannot compare procrustes coordinates directly, 
# instead we look centroid sizes, procD, PC scores, and allometric regression model summary
# geomorph does not report each sample's procD to the consensus shape

pd = function(M, A) return(sqrt(sum(rowSums((M-A)^2))))
geomorph.PD = NULL
for (i in 1:n) geomorph.PD [i] = pd(gpa$consensus, gpa$coords[,,i])

#We can start to compare procrustes variables

par(mfrow=c(2,2))

# 1. Centroid Size
plot(gpa$Csize, Csize, 
     pch=20, ylab='SlicerMorph', 
     xlab = 'geomorph', main = "Centroid Size")
cor(gpa$Csize, Csize)

# 2. Procrustes Distance of sample to their respective mean
plot(geomorph.PD, PD, 
     pch=20, ylab='SlicerMorph', 
     xlab = 'geomorph', main = "Procrustes Distance")
cor(gpa$Csize, Csize)

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




