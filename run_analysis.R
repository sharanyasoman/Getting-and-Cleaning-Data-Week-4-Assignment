
#1 unzipping tidy data set
#1a create the folder if not already existing
if(!file.exists("./DS_4")){dir.create("./DS_4")}
#1b download the file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./DS_4/Dataset.zip")

#1c Extract the zip file contents
unzip(zipfile="./DS_4/Dataset.zip",exdir="./DS_4")

#2 Read all the test data 
#2a Read feature and activity data
features <- read.table('./DS_4/UCI HAR Dataset/features.txt')
activityLabels = read.table('./DS_4/UCI HAR Dataset/activity_labels.txt')

#2b Read training tables data
x_train <- read.table("./DS_4/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./DS_4/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./DS_4/UCI HAR Dataset/train/subject_train.txt")

#2b Read testing tables data
x_test <- read.table("./DS_4/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./DS_4/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./DS_4/UCI HAR Dataset/test/subject_test.txt")

#3 Assign column names to the data
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#4a Merge activity and subject data into one  
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)

#4b Merging all data in one set:
setAll <- rbind(mrg_train, mrg_test)

#5a Read column names(to get the colnames containing the word mean)
colNames <- colnames(setAll)

#5b Create vector for defining ID, mean and standard deviation:
mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

#6 Making nessesary subset from setAll:
setForMeanAndStd <- setAll[ , mean_and_std == TRUE]
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)
#7 Creating another independent tidy data set with the average of each variable for each activity and each subject
# .in aggregrate refers to all other colnames and  on the right hand side of ~ is the columns by which we are going to aggregrate
#Making second tidy data set
TidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]

#8 Writing second tidy data set in txt file
write.table(TidySet, "TidySet.txt", row.name=FALSE)




