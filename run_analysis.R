# Please put this script in the UCI HAR Dataset folder
library("dplyr")
library("reshape2")
# read all the data and merge them.
activity_labels <- read.table("activity_labels.txt")
trainData_X <- read.table("train/X_train.txt", colClasses = "numeric")
trainData_Y <- read.table("train/Y_train.txt", colClasses = "numeric")
testData_X <- read.table("test/X_test.txt", colClasses = "numeric")
testData_Y <- read.table("test/Y_test.txt", colClasses = "numeric")
trainData_subject <- read.table("train/subject_train.txt")
testData_subject <- read.table("test/subject_test.txt")
trainData <- cbind(trainData_subject, trainData_Y, trainData_X)
testData <- cbind(testData_subject, testData_Y, testData_X)
allData <- rbind(testData, trainData)
# read in features
features <- read.table("features.txt", colClasses = c("numeric", "character"))
# construct variable names for the merged data (test data and training data)
variable_names <- c("subject", "activity_label", features[, 2])
# label the data set with "variable_names", use "make.names" and parameter
# "unique = TRUE" to make the variable names legal for R and unique 
colnames(allData) <- make.names(variable_names, unique = TRUE) 
# extract the colunms whose name contains "mean" or "std"
extractedData <- select(allData, subject, activity_label, contains("mean"), contains("std"))
# replace the number of activity to word description of activity
extractedData$activity_label = activity_labels[extractedData$activity_label,2]

# melt the "extracedData"
meltData <- melt(extractedData, id = c("subject", "activity_label") )
# apply "mean" to each combination of "subject" and "activty_label" 
meanData <- dcast(meltData, subject + activity_label ~ variable, mean)
# save the result to a text file
write.table(meanData, "meanData.txt", quote = F, row.names = F)