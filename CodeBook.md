CodeBook.md
==========================

The variables included in this tidy data set include all variables from the original features_info.txt which included mean() or std().
Variables ending in meanFreq were also included since they are weighted means of the signal variables.

This amounted to 79 variable names which were labelled as Signal when put into a single column.

The variable names were renamed to be more descriptive by changing the short descriptions to longer description per the features_info.txt:

	names(data)<- gsub("tBody", "Time_Domain_Body_", names(data))
	names(data)<- gsub("Acc", "Acceleration_", names(data) )
	names(data)<- gsub("-mean()-", "mean_", names(data), fixed = TRUE) # fixed = TRUE argument needed to deal with '()-'
	names(data)<- gsub("-mean()", "mean", names(data), fixed = TRUE)
	names(data)<- gsub("tGravity", "Time_Domain_Gravity_", names(data))
	names(data)<- gsub("Jerk", "Jerk_", names(data))
	names(data)<- gsub("Gyro", "Gyroscope_", names(data))
	names(data)<- gsub("Mag", "Magnitude_", names(data))
	names(data)<- gsub("fBody", "Frequency_Domain_Body_", names(data))
	names(data)<- gsub("-std()-", "std_", names(data), fixed = TRUE)
	names(data)<- gsub("-std()", "std", names(data), fixed = TRUE)
	names(data)<- gsub("-meanFreq()-", "Weighted_mean_Frequency_", names(data), fixed = TRUE)
	names(data)<- gsub("-meanFreq()", "Weighted_mean_Frequency", names(data), fixed = TRUE)

Example input/output would be "tBodyAcc-mean()-X" to Time_Domain_Body_Acceleration_mean_X

SubjectID and Activity were also included.

SubjectID was pulled from the subject_train.txt and subject_test.txt files.
Activity was pulled from the y_train.txt and y_test.txt files.

The Activity variable was made into a factor variable, with the level names for each of the 6 activities changing to match the descriptions in the activities_labels.txt:

1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING

As this is only a codebook for variables, please refer to the README.md file for specifics on choices made in analyzing this data.


