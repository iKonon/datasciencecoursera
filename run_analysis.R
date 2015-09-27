#download and unzip file

setwd("./datasciencecoursera")

library(httr)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "Dataset.zip", method="curl")
datafolder <- "UCI HAR Dataset"
unzip("Dataset.zip", list = FALSE, overwrite = TRUE)

library(data.table)
library(dplyr)

featureNames <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt", header = FALSE)

subjectTrain <- read.table("./train/subject_train.txt", header = FALSE)
activityTrain <- read.table("./train/y_train.txt", header = FALSE)
featuresTrain <- read.table("./train/X_train.txt", header = FALSE)

subjectTest <- read.table("./test/subject_test.txt", header = FALSE)
activityTest <- read.table("./test/y_test.txt", header = FALSE)
featuresTest <- read.table("./test/X_test.txt", header = FALSE)

#step 1
subject <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)

colnames(features) <- t(featureNames[2])

colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

#step 2
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)
extractedData <- completeData[,requiredColumns]
dim(extractedData)

#step 3
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}

extractedData$Activity <- as.factor(extractedData$Activity)

#step 4
names(extractedData)

names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))

names <- names(extractedData)

#step 5
extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

tidyDataset <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyDataset <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "tidy_data.txt", row.names = FALSE)
