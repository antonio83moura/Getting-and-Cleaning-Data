## You should create one R script called run_analysis.R that does the following. 
##
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
##
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##
## Good luck!

#setwd("C:/Users/henrique/Documents/Cousera/getdata-033/Project")
  
require("data.table")
require("reshape2")

# read file with activity labels
activity_labels <- read.table("./00-Dataset/UCI HAR Dataset/activity_labels.txt")[,2]

# read file with column names
features <- read.table("./00-Dataset/UCI HAR Dataset/features.txt")[,2]

# Extract mean and standard deviation
extract_features <- grepl("mean|std", features)

# Read and process/calculate X_test and y_test
X_test <- read.table("./00-Dataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./00-Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./00-Dataset/UCI HAR Dataset/test/subject_test.txt")

# Add column names for measurement files
names(X_test) = features

# Select measurement.
X_test = X_test[,extract_features]

# Read activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Bind
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Read and process/calculate X_train and y_train
X_train <- read.table("./00-Dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./00-Dataset/UCI HAR Dataset/train/y_train.txt")

# Subject_train
subject_train <- read.table("./00-Dataset/UCI HAR Dataset/train/subject_train.txt")

# Add column names
names(X_train) = features

# Extract mean and standard deviation
X_train = X_train[,extract_features]

# Read activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge datas
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# calc mean
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")