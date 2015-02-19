library(reshape2)
library(dplyr)

# Set working directory where UCI HAR Dataset folder resides
setwd("c:/Users/David/Documents/R/")

# Read the training data into R
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = "", header=FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "", header=FALSE)

# Read the test data into R
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "", header=FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "", header=FALSE)

# Read the X feature names into R
features <- read.table("./UCI HAR Dataset/features.txt", sep="", header=FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Merge training and test datasets
merged_data <- rbind(X_train, X_test)
merged_ydata <- rbind(y_train, y_test)
merged_subjects <- rbind(subject_train, subject_test)

# Correct the BodyBody features and then add as column names
features[,2] <- gsub("BodyBody", "Body", features[,2])
colnames(merged_data) <- features[,2]

# Only columns containing exact strings "mean()"or "std()"
keep_cols <- grepl("mean()", features[,2], fixed=TRUE) | grepl("std()", features[,2], fixed=TRUE)
merged_data <- merged_data[,keep_cols]

# Initialize new column to store the activity text label in merged_ydata
merged_ydata$Activity <- "not yet set"

# Assign the correct activity label for each numeric designation in column 1 of merged_ydata
for(i in 1:nrow(activity_labels)){
  merged_ydata[merged_ydata[,1] == activity_labels[i,1], 2] <- as.character(activity_labels[i,2])
}

# Add column name to merged_subjects
colnames(merged_subjects) <- "Subject"

# Remove the activity number column from prior to merger
merged_ydata$V1 <- NULL

# Merge the Subject, Activity and Measurement datasets
tidy_data = cbind(merged_subjects, merged_ydata, merged_data)

# Calculate the mean for each measurement by both subject and activity
tidy_data <- group_by(tidy_data, Subject, Activity)
wide_tidy <- summarise_each(tidy_data, funs(mean))

# Transform the data into a long tidy dataset
long_tidy <- melt(wide_tidy, id.vars = c("Subject", "Activity"), variable.name = "Measure", 
                  variable.value = "Value")

# Write long tidy dataset to a txt file
write.table(long_tidy, file = "long_tidy.txt", row.names=FALSE)
