# Code Book
## Features used in the experimet

### These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ                  
tGravityAcc-XYZ                            
tBodyAccJerk-XYZ                             
tBodyGyro-XYZ                           
tBodyGyroJerk-XYZ                     
tBodyAccMag                       
tGravityAccMag                  
tBodyAccJerkMag                      
tBodyGyroMag                         
tBodyGyroJerkMag                      
fBodyAcc-XYZ                            
fBodyAccJerk-XYZ                       
fBodyGyro-XYZ                      
fBodyAccMag                
fBodyAccJerkMag                      
fBodyGyroMag                         
fBodyGyroJerkMag

### The set of variables that were estimated from these signals are: 

mean(): Mean value                     
std(): Standard deviation                      
mad(): Median absolute deviation                       
max(): Largest value in array                  
min(): Smallest value in array                   
sma(): Signal magnitude area                                      
energy(): Energy measure. Sum of the squares divided by the number of values.                           
iqr(): Interquartile range                         
entropy(): Signal entropy               
arCoeff(): Autorregresion coefficients with Burg order equal to 4                   
correlation(): correlation coefficient between two signals                     
maxInds(): index of the frequency component with largest magnitude                    
meanFreq(): Weighted average of the frequency components to obtain a mean frequency                       
skewness(): skewness of the frequency domain signal                     
kurtosis(): kurtosis of the frequency domain signal                    
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.                    
angle(): Angle between to vectors.

### Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean          
tBodyAccMean                         
tBodyAccJerkMean                             
tBodyGyroMean                                 
tBodyGyroJerkMean

## Activities
1 WALKING                               
2 WALKING_UPSTAIRS                                 
3 WALKING_DOWNSTAIRS        
4 SITTING              
5 STANDING             
6 LAYING               

# R code and comments for the assignment
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
## Creation of a Tidy data set with the orderd variables Subject and Activity
##    
    selectedFields$Subject <- as.factor(selectedFields$Subject)
    selectedFields <- data.table(selectedFields)
    tidyData <- aggregate(. ~Subject + Activity, selectedFields, mean)
    tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
## Creadting Tidy_Data on current working directory
##    
    write.table(tidyData, file = "Tidy_Data.txt", row.names = FALSE)
## end

