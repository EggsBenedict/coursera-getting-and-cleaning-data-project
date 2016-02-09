library(reshape2)
library(dplyr)

setwd("~/RStudioDirectory")
filename <- "getdata-projectfiles-UCI HAR Dataset.zip"

# Download the .zip file with project data if it doesn't already exist
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}
# Unzip the file if directory not present
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

# Retrieve Labels. Rename columns for future use in merge.
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
colnames(activityLabels) <- c("activityID", "activityName")
# Retrieve features
features <- read.table("UCI HAR Dataset/features.txt")

# Build list of labels for features that we want to keep and rename them for clarity
featuresWanted <- grep(".*mean\\(\\).*|.*std\\(\\).*", features[,2],ignore.case=TRUE)
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names <- gsub("-mean", "Mean", featuresWanted.names)
featuresWanted.names <- gsub("-std", "Std", featuresWanted.names)
featuresWanted.names <- gsub("[-()]", "", featuresWanted.names)
featuresWanted.names <- gsub("^t","time", featuresWanted.names)
featuresWanted.names <- gsub("^f","freq", featuresWanted.names)
featuresWanted.names <- gsub("Mag","Magnitude", featuresWanted.names)
featuresWanted.names <- gsub("^anglet","angleTime", featuresWanted.names)

# Load training information and limit variables pulled into data set
# using [featuresWanted]
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
allTrain <- cbind(trainSubjects, trainActivities, train)

# Load test information and limit variables pulled into data set
# using [featuresWanted]
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
allTest <- cbind(testSubjects, testActivities, test)

# Combine both sets of data
combinedData <- rbind(allTrain, allTest)

# Rename columns to something memorable
colnames(combinedData) <- c("subject", "activityID", featuresWanted.names)
combinedData <- merge(activityLabels, combinedData, by="activityID")
# Drop that ID - cause, why not?
combinedData <- select(combinedData, -activityID)

# Aggregate by subject & activity - then take the means.
combinedMeans <- aggregate(combinedData[, 3:68], list(combinedData$subject, 
                 combinedData$activityName), mean)
colnames(combinedMeans)[c(1,2)] <- c("subject", "activityName")

# For some reason this ordering made more sense
combinedMeans <- combinedMeans[order(combinedMeans$subject,
                 combinedMeans$activityName),]

# Write to text file
write.table(combinedMeans, 
            file = "~/GitHubRepos/coursera-getting-and-cleaning-data-project/tidydata.txt"
           ,row.name=FALSE)