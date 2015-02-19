# Getting_and_Cleaning_Data_Project
Course project for Getting and Cleaning Data on Coursera

This project uses the UCI HAR Dataset.

The Samsung measurement data, subject and activity identifiers are read into data frames 
for both the training and test datasets.  In each case, the training and test datasets
are merged together.  The measurements (i.e. features) are then labeled after correcting
for some typos in the feature list ("BodyBody" error).

Column features that do not include the exact substring mean() or std() in the feature
name are dropped from the dataset.  It was the decision of this user not to include
meanFreq() or angle measurements using mean identifiers.  This results in 66 features
being carrier forward in the tidy dataset.

The activity numeric labels are replaced with their corresponding text identifiers to
make the data more easily read.

The subject, activity and measurement data are then merged into a single data frame which
is grouped by both subject and activity.  The mean for each measurement is then calculated
using the summarise_each function in dplyr.

The resulting dataset is then transformed via the melt function into a 4 column tidy dataset consisting of the Subject identifier, Activity text label, Measurement description and 
Mean Value.  For 66 variables x 30 subjects x 6 activities, this leads to 11880 rows in the
final dataset.

The long, tidy dataset is then written to a text file called "long_tidy.txt".