# Overview of program

The first thing we need to do is create the large, singular data set. We do that by loading the six required documents: the actual data, the labels for the data, and the subjects for that data, for both the test set and the training set. I appended the labels and subjects to the data via cbind, then i rbinded both data sets together to get the 'raw' data set.

After that, I needed only the mean and standard deviation results, so I loaded the features from the dataset, and I filtered out which ones were means and which were standard deviations using the apply function and grep. I got the indices these occured at, merged them together, and then subsetted the raw data to get the 'actual' data set.

At this point, I labelled the data itself: Named the variables used, appeneded the subjects and activities, and named their columns, too. Now, we need to replace the activity values with actual names. I do that via simple subsetting and re-assignment. 

At this point, our final non-tidy data set is done. All that is left to do is average all the values for each activity and subject. I do that with the melt command from the reshape2 library. I melt the data by Activity and Subject, then use a dcast to call mean over the data in those melt ids. The result is then written to a file called clean_data.txt.

