CleaningDataPeerAssessment
==========================
###Requirements:
1 You should create one R script called run_analysis.R that does the following. 
2 Merges the training and the test sets to create one data set.
3 Extracts only the measurements on the mean and standard deviation for each measurement. 
4 Uses descriptive activity names to name the activities in the data set
5 Appropriately labels the data set with descriptive activity names. 
6 Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

### Most README.md are included in appropriate places in the run_analysis.R script file for ease of reading while looking at the code.

This analysis assumes the data is in your working directory with the same directory structure contained in the zip file.

### Formatting not required for this assessment, but multiple 
Some non-unique variable column appear to be clumped up in groups of three. Variables before and after follow a pattern of X, Y, then Z observations. 
These are in threes and most likely follow the same pattern. 
X, Y, and Z added to:

	fBodyAcc-bandsEnergy()-1,16      fBodyAcc-bandsEnergy()-1,24       fBodyAcc-bandsEnergy()-1,8     fBodyAcc-bandsEnergy()-17,24     fBodyAcc-bandsEnergy()-17,32 

    fBodyAcc-bandsEnergy()-25,32     fBodyAcc-bandsEnergy()-25,48     fBodyAcc-bandsEnergy()-33,40     fBodyAcc-bandsEnergy()-33,48     fBodyAcc-bandsEnergy()-41,48 

    fBodyAcc-bandsEnergy()-49,56     fBodyAcc-bandsEnergy()-49,64     fBodyAcc-bandsEnergy()-57,64      fBodyAcc-bandsEnergy()-9,16  fBodyAccJerk-bandsEnergy()-1,16 

	fBodyAccJerk-bandsEnergy()-1,24   fBodyAccJerk-bandsEnergy()-1,8 fBodyAccJerk-bandsEnergy()-17,24 fBodyAccJerk-bandsEnergy()-17,32 fBodyAccJerk-bandsEnergy()-25,32 

	fBodyAccJerk-bandsEnergy()-25,48 fBodyAccJerk-bandsEnergy()-33,40 fBodyAccJerk-bandsEnergy()-33,48 fBodyAccJerk-bandsEnergy()-41,48 fBodyAccJerk-bandsEnergy()-49,56 

	fBodyAccJerk-bandsEnergy()-49,64 fBodyAccJerk-bandsEnergy()-57,64  fBodyAccJerk-bandsEnergy()-9,16     fBodyGyro-bandsEnergy()-1,16     fBodyGyro-bandsEnergy()-1,24 

    fBodyGyro-bandsEnergy()-1,8    fBodyGyro-bandsEnergy()-17,24    fBodyGyro-bandsEnergy()-17,32    fBodyGyro-bandsEnergy()-25,32    fBodyGyro-bandsEnergy()-25,48 

	fBodyGyro-bandsEnergy()-33,40    fBodyGyro-bandsEnergy()-33,48    fBodyGyro-bandsEnergy()-41,48    fBodyGyro-bandsEnergy()-49,56    fBodyGyro-bandsEnergy()-49,64 
 
	fBodyGyro-bandsEnergy()-57,64     fBodyGyro-bandsEnergy()-9,16 
Add these modified features to the datasets.
### /end Formatting that was not required. 


Add Activities to each test/train set.
Add SubjectIDs to each test/train set. 
Combined train set and test set. Train set first.

3 Extracts only the measurements on the mean and standard deviation for each measurement. 

str_detect() in the stringr package will return a logical boolean for
whether the string "mean" appears in the vector of names of columns.
Used this boolean vector to subset out column variables containing means.
Same for "std" (standard deviation.)

Create a sanity check dataset without these variables to see if anything resembling mean or sd remains in the dataset.

13 variables are meanFreq variables. This is defined as:
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
Since these are indeed (weighted) means of these variables,
these were left in as they may be valuable means and can easily be subsetted out if not needed.
There are no associated standard deviations for these meanFreq variables.

4 Use descriptive activity names to name the activities in the data set

Integrity Check: Table occurrences of Activity numbers (1-6)

Descriptions for activities pulled from the "activity_labels.txt" file.

Integrity Check: Totals remain in the same order and are labelled in the order of "activity_labels.txt". 

5 Appropriately labels the data set with descriptive activity names. 

Create 'data' dataframe which has only the subjectIDs, Activities, and summaries data.


6 Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Rename variables to be more descriptive. Use underscore_ naming scheme for ease of calling variables within R.
fixed = TRUE argument needed to deal with '()-'

The psych package will return descriptive statistics of the dataset, broken down by Subject Id and Activity 
( by passing in a list() of variables to break down the data by)
mat = TRUE can be used to return this information as a matrix.
Only columns 3 to 81 are passed in since descriptive statistics on Subject ID/Activity are not needed.

Group1 is our first grouping variable, SubjectID and group2 is our second, Activity. Assign these names back to the vars.

Convert row.names to the first column of the dataset.
Remove the row names since they are now the first variable.
Rename first row to VariableID. 
Convert Signal variable form factor variable to strings.

Remove the number that was added to each Signal variable for each combination of SubjectID and Activity. 
Integrity Check: The average of SubjectID(5) and Activity(2) in the uncompressed data is 0.2773308
This matches the tidyData set for this combination produced by describeBy: 0.2773308 


While all of the descriptive statistics are useful, this assignment only asks for the mean of each signal mean for 
each SubjectID/Activity Combination. Columns of containing Signals, Means, SubjectsIDs and Activities are extracted.

Integrity check: The activity label for tidyData$Activity matches the original labels vector.

Create a second tidy dataset in case we want this to be a wide format instead of long format.

Remove 'mean.' that added to each variable in the wide format conversion. fixed = TRUE to only remove "mean."

Integrity Check: mean for subject 1 Walking is still 0.2773308.
Write data to text files for submission.


Please refer to the CodeBook.md file for variable names and meanings.