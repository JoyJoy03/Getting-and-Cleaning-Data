## Project: Getting and Cleaning Data 

## Goal: To prepare tidy data that can be used for later analysis

## Description:

## To run this R script, it is required that the Samsung data is in your working directory. The data can be downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. A full description of the data is available from:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. More specifically, the data can be downloaded directly from the link provided or downloaded using the following codes:

##     file.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
##     file.des <- "Dataset.zip" 
##     download.file(url = file.url, destfile = file.des, method = "curl")
##     unzip(zipfile = file.des, exdir = getwd()) # unzip the Dataset.zip to the current working directory

## Given the Samsung data in your working directory, this R script then:
##    1. merges the training and the test sets to create one data set;
##    2. extracts only the measurements on the mean and standard deviation for each measurement;
##    3. uses descriptive activity names to name the activities in the data set;
##    4. appropriately labels the data set with descriptive variable names;
##    5. from the data set in step 4, creates a second, independently tidy data set with the average of each variable for each activity and each subject.

## Step 1: Merge the training and the test sets to create one data set.

# 1.1) Set a working directory to the unzipped folder containing the data set called "UCI HAR Dataset".
setwd(paste(getwd(), "/UCI HAR Dataset", sep = "")) 

# 1.2) Read and combine train datasets.
subject_train <- read.table(paste(getwd(), "/train/subject_train.txt", sep = ""))
x_train <- read.table(paste(getwd(), "/train/X_train.txt", sep = ""))
y_train <- read.table(paste(getwd(), "/train/y_train.txt", sep = ""))
all_train <- cbind(subject_train, y_train, x_train)

# 1.3) Read and combine test datasets.
subject_test <- read.table(paste(getwd(), "/test/subject_test.txt", sep = ""))
x_test <- read.table(paste(getwd(), "/test/X_test.txt", sep = ""))
y_test <- read.table(paste(getwd(), "/test/y_test.txt", sep = ""))
all_test <- cbind(subject_test, y_test, x_test)

# 1.4) Merge the train and test data sets from 1.2) and 1.3).
all <- rbind(all_train, all_test)

# 1.5 Assign column names for the merged data set.
activity_labels <- read.table(paste(getwd(),"/activity_labels.txt", sep = "")) 
features <- read.table(paste(getwd(),"/features.txt", sep = ""))
colnames(all) <- c("subject", "activity", as.character(features[,2]))

## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

# 2.1) Create a logical index for extracting the measurements on the mean and standard deviation for each measurement. Note that I DO NOT include MeanFreq in my analysis (i.e., ONLY variables containing mean() and std() are used). 
index <- (grepl("subject", colnames(all)) | grepl("activity", colnames(all)) |
         grepl("-mean\\(\\)", colnames(all))  | grepl("-std\\(\\)", colnames(all))) 

# 2.2) Use the logical index vector created in 2.1) to subset the merged data set, named "all"
all.mean.std <- all[, index == TRUE]

## Step 3: Uses descriptive activity names to name the activities in the data set

# 3.1) Assign column names to a activity_labels table
colnames(activity_labels) <- c("activity", "activity.name")

# 3.2) Create a new table with the descriptive activity names in the "activity" column of the all.mean.std table
all.activity.name <- merge(activity_labels, all.mean.std, by = "activity", all.y = TRUE)
all.activity.name <- all.activity.name[,c(3,2,4:dim(all.activity.name)[2])]
all.activity.name <- all.activity.name[order(all.activity.name$subject),]
colnames(all.activity.name) <- sub(".name", "", colnames(all.activity.name))

## Step 4: Appropriately labels the data set with descriptive variable names
names(all.activity.name) <- gsub("mean", "Mean", names(all.activity.name))
names(all.activity.name) <- gsub("std", "Std", names(all.activity.name))
names(all.activity.name) <- gsub('[-()]', "", names(all.activity.name))
names(all.activity.name) <- gsub("^(t)", "time", names(all.activity.name))
names(all.activity.name) <- gsub("^(f)", "freq", names(all.activity.name))
names(all.activity.name) <- gsub("([Gg]ravity)", "Gravity", names(all.activity.name))
names(all.activity.name) <- gsub("([Bb]ody)", "Body", names(all.activity.name))
names(all.activity.name) <- gsub("([Bb]ody[Bb]ody)", "Body", names(all.activity.name))
names(all.activity.name) <- gsub("([Gg]yro)", "Gyro", names(all.activity.name))
names(all.activity.name) <- gsub("(AccMag)", "AccMagnitude", names(all.activity.name))
names(all.activity.name) <- gsub("([Bb]odyaccjerkmag)", "BodyAccJerkMagnitude", names(all.activity.name))
names(all.activity.name) <- gsub("JerkMag", "JerkMagnitude", names(all.activity.name))
names(all.activity.name) <- gsub("GyroMag", "GyroMagnitude", names(all.activity.name))

## Step 5: Creates a second, independently tidy data set with the average of each variable for each activity and each subject
library(dplyr)
TidyData <- all.activity.name %>% 
    group_by(subject, activity) %>%
    summarise_each(funs(mean))

write.table(TidyData, file = "TidyData.txt",row.names = FALSE)