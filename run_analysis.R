library("plyr")
library("dplyr")
#setwd("C:/RLearning/data/UCI HAR Dataset")
#read in the feature labels data, default colums V1 and V2
featurelabels <- read.table("features.txt",stringsAsFactors=FALSE)

featurelabels$V2 = gsub("-","_",featurelabels$V2) #replace "-"s with  "_"s
featurelabels$V2 = gsub("\\(\\)","",featurelabels$V2) #remove "()"s 


#read in the training X,Y,subject data
trainx <- read.table("train/X_Train.txt",stringsAsFactors=FALSE)
trainy <- read.table("train/Y_Train.txt",stringsAsFactors=FALSE)
trainsubject <- read.table("train/subject_train.txt",stringsAsFactors=FALSE)

#read in the test and test X,Y,subject data
testx <- read.table("test/X_Test.txt",stringsAsFactors=FALSE)
testy <- read.table("test/Y_Test.txt",stringsAsFactors=FALSE)
testsubject <-read.table("test/subject_test.txt",stringsAsFactors=FALSE)


#extract IDs of std and mean colums
stdandmeancolIDs <- c(grep("mean()",featurelabels$V2),grep("std()",featurelabels$V2))
stdandmeancolnames <- c(grep("mean()",featurelabels$V2,value=TRUE),grep("std()",featurelabels$V2,value=TRUE))


#subset to only mean and std colums
trainx_std_mean = trainx[,stdandmeancolIDs]
testx_std_mean = testx[,stdandmeancolIDs]


#merge train,test X data
merged_x <- rbind(trainx_std_mean,testx_std_mean)

#merge train,test Y data
merged_y <- rbind(trainy,testy)

#merge train,test subject data
merged_subject <- rbind(trainsubject,testsubject)

#merge into one dataset
ucihar_data <- cbind(merged_subject,merged_y,merged_x)

#append "_mean_value" to final column names, as these columns will store the mean at a latter step
stdandmeancolnames <- lapply(stdandmeancolnames,paste,"_mean_value",sep="")
#Add column names for "Y" and "Subject" fields 
stdandmeancolnames <- c("SubjectID","Activity",stdandmeancolnames)

colnames(ucihar_data) = stdandmeancolnames
#provide descriptive names to the Activity column

activity_labels <- read.table("activity_labels.txt")

ucihar_data[["Activity"]] <- activity_labels[ match(ucihar_data[['Activity']], activity_labels[['V1']] ) , 'V2']
#group by SubjectID, then Activity and apply mean 
x <- ddply(ucihar_data, .(SubjectID,Activity), colwise(mean))
#write out the tidy data
write.table(x,"tidydata.txt",row.names=FALSE )
