
setwd("C:/Users/fch80_000/Dropbox/~Coursera/DataScienceSpec/Getting-and-Cleaning-Data/Week-3")
#1 You should create one R script called run_analysis.R that does the following. 

#2 Merges the training and the test sets to create one data set.

#This assumes the data is in your working directory with the same directory structure contained in the zip file.
setwd("UCI HAR Dataset/test")



y_test<-(read.table("y_test.txt", col.names = "Activity"))
x_test<- (read.table("X_test.txt"))
subject_test<- read.table("subject_test.txt", col.names = "SubjectID") #Add subject IDs to the new dataset.

setwd("..")
setwd("train")

x_train<- read.table("X_train.txt")
y_train<- read.table("y_train.txt", col.names = "Activity") 
subject_train<- read.table("subject_train.txt", col.names = "SubjectID") #Add subject IDs to the new dataset.

setwd("..")

features<- as.character(features<- read.table("features.txt")[,2])




unique(features)#477, not 561. Some column names are repeated.

which(table(features)>1) #Check for names that appear more than once.

which(features=="fBodyAcc-bandsEnergy()-25,48")# Find the indecies for the non-unique columns.



features[303:316] #They appear to be clumped up. Variables before and after follow a pattern of X, Y, then Z observations. 
#These are in threes and most likely follow the same pattern. 
features[303:316]<- paste0(features[303:316],"_X") #Rename the variables to X, Y, Z

features[317:330]
features[317:330]<- paste0(features[317:330],"_Y")

features[331:344]
features[331:344]<- paste0(features[331:344], "_Z")

which(table(features)>1)
which(features=="fBodyAccJerk-bandsEnergy()-1,8")

features[380:440]

features[382:395]
features[382:395]<- paste0(features[382:395],"_X")

features[396:409]
features[396:409]<- paste0(features[396:409],"_Y")

features[410:423]
features[410:423]<- paste0(features[410:423],"_Z")

which(table(features)>1)
which(features=="fBodyGyro-bandsEnergy()-1,8")

features[461:474]
features[461:474]<- paste0(features[461:474],"_X")

features[475:488]
features[475:488]<- paste0(features[475:488],"_Y")

features[489:502]
features[489:502]<- paste0(features[489:502],"_Z")

which(table(features)>1) #No non-unique values left

## Add these modified features to the datasets.
names(x_test)<- features
names(x_train)<- features
##Add Activities to each test/train set.
x_test<- cbind(y_test, x_test)
x_train<- cbind(y_train, x_train)

##Add SubjectIDs to each test/train set. 
x_test<- cbind(subject_test, x_test)
x_train<- cbind(subject_train, x_train)

#combine train set and test set. Train set first.
x_all<- rbind(x_train, x_test)

names(x_all)


#3 Extracts only the measurements on the mean and standard deviation for each measurement. 

library(stringr)
#str_detect() in the stringr package will return a logical boolean for
#whether the string "mean" appears in the vector of names of columns.
str_detect(names(x_all), "mean") 

means<- x_all[,str_detect(names(x_all), "mean")] #Subset the data based on the presence of "mean" in the column name.


sd<- x_all[,str_detect(names(x_all), "std")] # Same for "std" (standard deviation.)

## Create a sanity check dataset without these variables to see if anything resembling mean or sd remains in the dataset.
sanityCheck<- x_all[,!str_detect(names(x_all), "mean")]
sanityCheck<- sanityCheck[,!str_detect(names(sanityCheck), "std")]
names(sanityCheck) #There doesn't appear to be anything left.

summaries<- cbind(means, sd) # Create a dataset of these mean and sd subsets
names(summaries)

# 13 variables are meanFreq variables. This is defined as:
# meanFreq(): Weighted average of the frequency components to obtain a mean frequency
# Since these are indeed (weighted) means of these variables,
# these were left in as they may be valuable means and can easily be subsetted out if not needed.
# There are no associated standard deviations for these meanFreq variables.
sum(str_detect(names(summaries), "-meanFreq"))

#4 Uses descriptive activity names to name the activities in the data set

##
table(x_all$Activity) # Integrity Check: Table occurences of Activity numbers (1-6)

#Descriptions for activities pulled from the "activity_labels.txt" file.
activityLabels<- c("Walking", "Walking_Upstairs", "Walking_Downstairs", "Sitting", "Standing", "Laying")
x_all$Activity<- factor(x_all$Activity, labels = activityLabels)

table(x_all$Activity) # Integrity Check: Totals remain in the same order but are now labelled in the order of "activity_labels.txt". 

#5 Appropriately labels the data set with descriptive activity names. 

#Create 'data' dataframe which has only the subjectIDs, Activities, and summaries data.
data<- cbind(x_all[1:2], summaries)

#6 Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


#Rename variables to be more descriptive. Use underscore_ naming scheme for ease of calling variables within R.
names(data)

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

names(data)

library(psych)

## The psych package will return descriptive statistics of the dataset, broken down by Subject Id and Activity 
## ( by passing in a list() of variables to break down the data by)
## mat = TRUE can be used to return this information as a matrix.
## Only columns 3 to 81 are passed in since descriptive statistics on Subject ID/Activity are not needed.
tidyData<- describeBy(data[3:81], list(data$SubjectID, data$Activity), mat = TRUE)

#Group1 is our first grouping variable, SubjectID and group2 is our second, Activity. Assign these names back to the vars.
names(tidyData)[2:3]<- c("SubjectID", "Activity")


tidyData<- cbind( rownames(tidyData), tidyData) #Convert row.names to the first column of the dataset.
rownames(tidyData)<- NULL #Remove the row names since they are now the first variable.
names(tidyData)[1]<- "Signal" #Rename first row to VariableID. 

# Convert Signal variable form factor variable to strings
tidyData$Signal<-as.character(tidyData$Signal)

#Remove the number that was added to each Signal variable for each combination of SubjectID and Activity. 
tidyData$Signal<- gsub("[0-9]","",tidyData$Signal)



## Integrity Check: The average of SubjectID(5) and Activity(2) in the uncompressed data is 0.2773308
## This matches the tidyData set for this combination produced by describeBy: 0.2773308 
mean(data$Time_Domain_Body_Acceleration_mean_X[data$SubjectID == 1 & data$Activity == "Walking"]) 
tidyData[1,]

# While all of the descriptive statistics are useful, this assignment only asks for the mean of each signal mean for 
# each SubjectID/Activity Combination. We can extract the columns of interest.
tidyData<-(tidyData[,c(1,3,4,7)])


#Integrity check: The activity label for tidyData$Activity matches the original labels vector.
tidyData[1,]
table(x_all$Activity)


## We will create a second tidy dataset in case we want this to be a wide format instead of long format.
library(reshape)

tidyDataWide<- reshape(tidyData, idvar = c("SubjectID", "Activity"), timevar = "Signal", direction = "wide")
# Remove 'mean.' that added to each variable in the wide format conversion. fixed = TRUE to only remove "mean."
names(tidyDataWide)<-gsub("mean.", "", names(tidyDataWide), fixed =TRUE)

#Integrity Check: mean for subject 1 Walking is still 0.2773308.
tidyDataWide$Time_Domain_Body_Acceleration_mean_X[tidyDataWide$SubjectID == 1 & tidyDataWide$Activity == "Walking"]

# Write data to text files for submission.
write.table(tidyData, file = "tidyDataLongFormat.txt")
write.table(tidyDataWide, file = "tidyDataWideFormat.txt")
