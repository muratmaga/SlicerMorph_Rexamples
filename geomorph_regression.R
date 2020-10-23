# This script uses the procD.lm() examples provided in geomorph 3.3.1.
# It shows how to reformats the SlicerMorph GPA output to the data shape geomorph expects 


source(url("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.fcsv.R"))
source(url("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.json.R"))

library(geomorph)

# provide the path to the output folder created by SlicerMorph's gpa module
# we are using the output from the mouse skull LMs data distributed by SlicerMorph
# using all 55 LMs and with scaling enabled option
# note that 4 samples have missing landmarks denoted as c(-1000, -1000, -1000)
# which would cause weird artifacts in the visualization, but does not impede with what we are testing

path.to.output="C:/temp/RemoteIO/mouse_skull_LMs/2020-09-11_21_34_31/"

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


#this part is now using the raw LM coordinates directly
#and comparing the model results fitted to them using geomorph's gpagen function
#to the results we obtained from GPA aligned coordinates

fcsvs=dir(patt='fcsv', path=paste(path.to.output,'../', sep="/"), full.names = T)
n=length(fcsvs)
LMs=array(dim=c(n.lm, 3, n))

for (i in 1:n) LMs[,,i] = read.markups.fcsv(fcsvs[i])

gpa <- gpagen(LMs)

#since we cannot compare things like procrustes aligned coordinates directly, lets look at centroid sizes

cor(gpa$Csize, Csize)

#now lets fit the same model from coordinates derived from gpagen 
gdf2 = geomorph.data.frame(size = gpa$Csize, coords = gpa$coords)
fit2 = procD.lm(coords~size, data = gdf)
summary(fit2)

#is identical results to the previous model
summary(fit)


