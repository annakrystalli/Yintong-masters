#Set up
rm(list = ls())
require(randomForest)


an.ID="Final/"
an.IDCV<-"model assess NC CV"
data="mod "
model="rf_i"
cv.no=5
thresh="PredPrev=Obs"
pr.time="night"

names.spp<-c("chel","cfin", "metrilu", "centrot", "tem")



varnames<-c("year", "time",
            "month",  "T.m", "Sed.m", 
            "Sedf.m",  "Ch.m", "fdens.m", 
            "fdist.m",  "fside.m",  "fdens.c.m", 
            "fdist.c.m",  "fside.c.m", 
            "bath", "NAO", "wNAO")


#.......FUNCTIONS_________________________________________________________________________________________________________________________

selectX<-function(X, varnames){X[,which(names(X) %in% varnames)]}


predictRfor<-function(input.folder="~/Documents/SATELLITE/monthly/PROCESSED/", 
                      output.folder = "~/Documents/PROJECTS/Yintong/data/",
                      an.ID=NULL,
                      spp=spp,
                      files=NULL, v=varnames,
                      pr.time){

  dir.create(output.folder, showWarnings=F)
  
load(file=paste("~/Documents/TRAINING DATA/Models/randomForest/", an.ID,"forests/",spp,"/OCforest.Rdata", sep=""))
load(file=paste("~/Documents/TRAINING DATA/Models/randomForest/", an.ID,"forests/",spp,"/ACforest.Rdata", sep=""))

#output folder prep_________________________________________________________________________________

  output.folder<-paste(output.folder,"/normalised monthly maps/", sep="")
  dir.create(output.folder, showWarnings=F)

  output.folder<-paste(output.folder, spp, "/", sep="")
  dir.create(output.folder, showWarnings=F)
  
  output.folder<-paste(output.folder, pr.time, "/", sep="")
  dir.create(output.folder, showWarnings=F)

if(is.null(files)){filenames<-list.files(path=paste(input.folder,
                                 "normalised/", sep=""),all.files = FALSE)}else{

filenames<-paste(files, ".Rdata", sep="")}

  
for (i in 1:length(filenames)){  
  load(paste(input.folder,
             "normalised/", filenames[i],sep=""))
  
  x<-try(cbind(time=factor(pr.time, levels=c("day", "night")),
           X.pred[, setdiff(v, "time")]), silent=TRUE)
  
  #...predict occupancy.........
  pred.oc<-try(data.frame(predict(rforOC, newdata=x, type="prob")), silent=TRUE)
    if(class(pred.oc)=="try-error"){next}
  names(pred.oc) <- paste("OC", sub("X","",names(pred.oc)), sep = "")
  
  #...predict abundance category.........
  pred.ac<-data.frame(predict(rforAC, newdata=x, type="prob"))
  names(pred.ac) <- paste("AC", sub("X","",names(pred.ac)), sep = "")
  
  
  preds<-data.frame(r=X.pred$r, c=X.pred$c, pred.oc, pred.ac)
  
      write.csv(preds,file=paste(output.folder,
                               gsub(".RData", ".csv", filenames[i]),sep=""), row.names = F)}
  
}

#...WORKFLOW_________________________________________________________________________________________________________________________





for (spp  in names.spp){
  predictRfor(spp=spp, files=NULL,v=varnames, an.ID=an.ID, pr.time="night" )}



for (spp  in names.spp){
  predictRfor(spp=spp, files=NULL,v=varnames, an.ID=an.ID, pr.time="day" )}

  