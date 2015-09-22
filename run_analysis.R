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

library(reshape2)

#################################################################
# 1. Merge the training and the test sets to create one data set 
#################################################################

#The six files we need to build the large data set
test_data_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_data_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_data_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
train_data_set <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_data_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_data_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Apply labels and subjects
test_data_set = cbind(test_data_set, cbind(test_data_labels, test_data_subject))
train_data_set = cbind(train_data_set, cbind(train_data_labels, train_data_subject))

#merge the data

raw_data = rbind(test_data_set, train_data_set)

#################################################################
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
# 4. Appropriately labels the data set with descriptive variable names.
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

# Create and name new data frame
data = raw_data[indices]
names(data) <- features[,2][indices]

data = cbind(data, raw_data[562])
data = cbind(data, raw_data[563])
names(data)[80] <- "Activity"
names(data)[81] <- "Subject"

#################################################################
# 3. Use descriptive activity names to name the activities in the data set.
#################################################################

data$Activity[data$Activity == 1] <- "WALKING"
data$Activity[data$Activity == 2] <- "WALKING_UPSTAIRS"
data$Activity[data$Activity == 3] <- "WALKING_DOWNSTAIRS"
data$Activity[data$Activity == 4] <- "SITTING"
data$Activity[data$Activity == 5] <- "STANDING"
data$Activity[data$Activity == 6] <- "LAYING"

#################################################################
# Create a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
#################################################################

Molten <- melt(data, id.vars = c("Activity", "Subject"))
result <- dcast(Subject + Activity ~ variable, data = Molten, fun = mean)
write.table(result, "clean_data.txt", row.name=FALSE)

print(cat(names(data), sep="\n"))