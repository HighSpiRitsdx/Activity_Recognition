### Read the data needed ###

library(data.table)
library(dplyr)
x_test <- fread("test/X_test.txt")
y_test <- fread("test/y_test.txt")
sub_test <- fread("test/subject_test.txt")
x_train <- fread("train/X_train.txt")
y_train <- fread("train/y_train.txt")
sub_train <- fread("train/subject_train.txt")


### Merges the training and the test sets to create one data set ###
names(sub_test) <- "subject"
names(y_test) <- "y" # To avoid same variable name "V1"
test <- bind_cols(sub_test, y_test, x_test) # Combine test set by columns
names(sub_train) <- "subject"
names(y_train) <- "y"
train <- bind_cols(sub_train, y_train, x_train) # Combine train set by columns

merged <- bind_rows(test, train) # Combine train and test set by rows

### Extracts only the measurements on the mean and standard deviation ###
### Find which variables are mean and std ###
feature <- fread("features.txt")
mean_std <- grep("mean\\(\\)|std\\(\\)", feature$V2) # Find the feature with "mean()" or "std()"

merged2 <- select(merged, c(1, 2, mean_std + 2)) # Extract y and variables with mean() and std()

### Uses descriptive activity names to name the activities in the data set ###
label <- fread("activity_labels.txt")
for (i in 1:nrow(label)){ 
        merged2$y <- gsub(label[i,1], label[i,2], merged2$y)} # Replace y with the name of activities

### Appropriately labels the data set with descriptive variable names ###
names(merged2) <- c("Subject", "Activity", feature$V2[mean_std])

### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject ###
table <- tbl_df(merged2)
table <- group_by(table, Subject, Activity) # Group by subjects and activities
summary <- summarize_all(table, mean)





