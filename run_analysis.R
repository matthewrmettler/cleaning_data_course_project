###############################################################################
## run_analysis.R
## Getting and Cleaning Data Course Project
## By Matthew Mettler, 2015
##
## Instructions from course project:
## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the 
##    average of each variable for each activity and each subject.
##
## Data used for this comes from:
## Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. 
## Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support 
## Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). 
## Vitoria-Gasteiz, Spain. Dec 2012
##
## Explanation of the data can be seen here:
##  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## A link to the actual data set can be found here:
##  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
###############################################################################

#################################################################
# 1. Merge the training and the test sets to create one data set 
#################################################################

#The four files we need
test_data_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_data_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
train_data_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_data_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")

#Apply labels
test_data_set = cbind(test_data_set, test_data_labels)
train_data_set = cbind(train_data_set, train_data_labels)

#merge the data

data = rbind(test_data_set, train_data_set)

#################################################################
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
#################################################################

# Load features.txt
# First column is the index, the second is the feature name
features <- read.table("./UCI HAR Dataset/features.txt")


# Use grep to get the mean and std indices from the features.txt file
filtered_mean <- apply(features, 1, function(x) { any(grep("-mean()", x)) } )
filtered_std <- apply(features, 1, function(x) { any(grep("-std()", x)) } )
mean_indices <- features[,1][filtered_mean]
std_indices <- features[,1][filtered_std]

indices <- sort(c(mean_indices, std_indices))

data_extracted = data[indices]
names(data_extracted) <- features[,2][indices]

#################################################################
# 3. Use descriptive activity names to name the activities in the data set.
#################################################################

data_extracted = cbind(data_extracted, data[562])
names(data_extracted)[80] <- "Activity"