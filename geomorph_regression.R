# This script uses the procD.lm() examples provided in geomorph 3.3.1.
# It shows how to reformat the SlicerMorph GPA output to the data shape geomorph expects 


source(url("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.fcsv.R"))
source(url("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.json.R"))

library(geomorph)

# we are using the output from the gorilla skull LMs data distributed by SlicerMorph
# 41 LMs and with scaling enabled option

# provide the path to the output folder created by SlicerMorph's gpa module
path.to.output="C:/temp/RemoteIO/Gorilla_Skull_LMs/2020-09-19_22_17_05/"

coords = read.csv(file=paste(path.to.output,"OutputData.csv", sep='/'))
M = as.matrix(read.csv(file=paste(path.to.output,"MeanShape.csv", sep = "/")) [ ,-1])

# pull the metadata out of coords data frame.
sample.name = coords[,1]
Csize= coords[,3]
PD = coords [,2]
coords = coords [,-c(1:3)]

# identify number of landmarks
n.lm = length(colnames(coords)) / 3

# reformat the coords into 3D LM array.
coords = arrayspecs(coords, p=n.lm, k=3 )

# fit geomorph model directly to coordinates aligned by SlicerMorph's GPA
gdf = geomorph.data.frame(size = Csize, coords = coords)
fit = procD.lm(coords~size, data = gdf)
summary(fit)

# some visualization in R

rat.plot <- plot(fit, type = "regression", 
                 predictor = gdf$size, reg.type = "RegScore", 
                 pch = 21, bg = "yellow") 

preds <- shape.predictor(fit$GM$fitted, x = rat.plot$RegScore, 
                         predmin = min(rat.plot$RegScore), 
                         predmax = max(rat.plot$RegScore))

plotRefToTarget(M, preds$predmin, mag=2)
plotRefToTarget(M, preds$predmax, mag=2)


# this part uses the raw LM coordinates directly in geomorph, 
# compares the model fitted to them using geomorph's gpagen function
# to the model results above

fcsvs=dir(patt='fcsv', path=paste(path.to.output,'../', sep="/"), full.names = T)
n=length(fcsvs)
LMs=array(dim=c(n.lm, 3, n))

for (i in 1:n) LMs[,,i] = read.markups.fcsv(fcsvs[i])

gpa <- gpagen(LMs)

# We cannot compare things like procrustes aligned coordinates or mean shape directly due to arbitrary rotations
# let's look at correlation on centroid sizes

cor(gpa$Csize, Csize)

# now lets fit the same model from coordinates derived from gpagen 
gdf2 = geomorph.data.frame(size = gpa$Csize, coords = gpa$coords)
fit2 = procD.lm(coords~size, data = gdf)
summary(fit2)

# which is identical results -within machine precision- to the previous model
summary(fit)


