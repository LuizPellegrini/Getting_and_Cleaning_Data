## Set libraries to solve the assignment
##
library(dplyr)    
library(data.table)
## Only read the files if they don't exist 
##
    if (!exists("featureNames")) { 
      featureNames <- read.table("features.txt")
     }
    if (!exists("activityLabels"))  { 
      activityLabels <- read.table("activity_labels.txt", header = FALSE)
     }
    if (!exists("activityLabels"))  { 
      subjectTrain <- read.table("train/subject_train.txt", header = FALSE)
     }
    if (!exists("activityLabels"))  { 
      activityTrain <- read.table("train/y_train.txt", header = FALSE)
     }
    if (!exists("activityLabels"))  { 
      featuresTrain <- read.table("train/X_train.txt", header = FALSE)
     }
    if (!exists("activityLabels"))  { 
      subjectTest <- read.table("test/subject_test.txt", header = FALSE)
     }
    if (!exists("activityLabels"))  { 
      activityTest <- read.table("test/y_test.txt", header = FALSE)
     }
    if (!exists("activityLabels"))  { 
      featuresTest <- read.table("test/X_test.txt", header = FALSE)
     }
## Merge Train and Test files according to common field names
##    
    subject <- rbind(subjectTrain, subjectTest)
    activity <- rbind(activityTrain, activityTest)
    features <- rbind(featuresTrain, featuresTest)
## Assign column names from featureNames
##    
    colnames(features) <- t(featureNames[2])
    colnames(activity) <- "Activity"
    colnames(subject) <- "Subject"
## Create the file of all data 
##
    Comb_Files <- cbind(features,activity,subject)
## Extract and add columns of mean and std dev
##
    columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(Comb_Files), ignore.case=TRUE)
    requiredColumns <- c(columnsWithMeanSTD, 562, 563)
    selectedFields <- Comb_Files[,requiredColumns]
## Transform from numeric to character type to receive Activity name
##    
    selectedFields$Activity <- as.character(selectedFields$Activity)
    for (i in 1:6){
      selectedFields$Activity[selectedFields$Activity == i] <- as.character(activityLabels[i,2])
    }
    selectedFields$Activity <- as.factor(selectedFields$Activity)
## Edition and replacement of variables names for more significant ones
##
    names(selectedFields)<-gsub("Acc", "Accelerometer", names(selectedFields))
    names(selectedFields)<-gsub("Gyro", "Gyroscope", names(selectedFields))
    names(selectedFields)<-gsub("BodyBody", "Body", names(selectedFields))
    names(selectedFields)<-gsub("Mag", "Magnitude", names(selectedFields))
    names(selectedFields)<-gsub("^t", "Time", names(selectedFields))
    names(selectedFields)<-gsub("^f", "Frequency", names(selectedFields))
    names(selectedFields)<-gsub("tBody", "TimeBody", names(selectedFields))
    names(selectedFields)<-gsub("-freq()", "Frequency", names(selectedFields), ignore.case = TRUE)
    names(selectedFields)<-gsub("gravity", "Gravity", names(selectedFields))
##
## Creation of a Tidy data set with the orderd variables Subject and Activity
##    
    selectedFields$Subject <- as.factor(selectedFields$Subject)
    selectedFields <- data.table(selectedFields)
    tidyData <- aggregate(. ~Subject + Activity, selectedFields, mean)
    tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
##
## Creadting Tidy_Data on current working directory
##    
    write.table(tidyData, file = "Tidy_Data.txt", row.names = FALSE)
## end
