# Getting-and-Cleaning-Data

The goal of the R script, run_analysis.R, is to prepare tidy data that can be used for later analyis. To run this R script, it is required that the Samsung data is in your working directory. The data can be downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. A full description of the data is available from:http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.

Given the Samsung data in your working directory, the R script, run_analysis.R, does the following:

1. Set a working directory to the unzipped folder containing the data set called "UCI HAR Dataset"

2. Read and combine train datasets

3. Read and combine test datasets

4. Merge the train and test data sets from (2) and (3)

5. Assign column names for the merged data set

6. Create a logical index for extracting the measurements on the mean and standard deviation for each measurement

7. Use the logical index vector created in (6) to subset the merged data set, named "all"

8. Assign column names to a activity_labels table

9. Create a new table with the descriptive activity names in the "activity" column of the all.mean.std table

10. Appropriately labels the data set with descriptive variable names

11. Creates a second, independently tidy data set with the average of each variable for each activity and each subject using a dplyr package

The end result is saved in a text file called TidyData.txt. Note that I DO NOT include MeanFreq in my analysis (i.e., ONLY variables containing mean() and std() are used). 