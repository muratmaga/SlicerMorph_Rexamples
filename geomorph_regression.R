# This script uses the examples provided in geomorph 3.3.1.
# It reformats the SlicerMorph GPA output to the data shape geomorph expects 


source(url("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.fcsv.R"))
source(url("https://raw.githubusercontent.com/muratmaga/SlicerMorph_Rexamples/main/read.markups.json.R"))

library(geomorph)

# provide the path to the output folder created by SlicerMorph's gpa module
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
