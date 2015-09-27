################################ STEP 1 ########################################
############################### LIBRARIES ######################################

# load dplyr and tidyr to manipulate data
library(dplyr)
library(tidyr)


################################ STEP 2 ########################################
############################## MAIN DIRECTORY ##################################

# reads features
# reads activities

features <- read.table("./features.txt")
# this sequence removes all alphanumeric characters and numbers from features' names
# and join names from rows of column 1 and column 2 just to be sure that names
# in column 2 are unique
features[,2] <- gsub(",", "", features[,2])
features[,2] <- gsub("\\(", "", features[,2])
features[,2] <- gsub("\\)", "", features[,2])
features[,2] <- gsub("\\d+", "", features[,2])
features[,2] <- gsub("\\-", "", features[,2])
features[,2] <- paste(features[,2], features[,1], sep="_")

activities_info <- read.table("./activity_labels.txt")


# set column names in features data frame
# set column names in activities data frame

names(features) <- c("featureID", "featureName")

names(activities_info) <- c("activityID", "activityName")


################################# STEP 3 #######################################
############################# TEST DIRECTORY ###################################

# reads subject_test - a file where people who performed activities are listed
# reads y_test - a file where performed activities are listed
# reads file with test signals

subject_test <- read.table("./test/subject_test.txt")

activities_test <- read.table("./test/y_test.txt")

signals_test <- read.table("./test/X_test.txt", nrows = 2947, colClasses = "numeric")


# set column names in subject_test data frame
# set column names in activities_test data frame
# change names of columns to names of signals from features data frame

names(subject_test) <- "subjectID"

names(activities_test) <- "activityID"

names(signals_test) <- features[,2]


################################ STEP 4 ########################################
############################# TRAIN DIRECTORY ##################################

# reads subject_train - a file where people who performed activities are listed
# reads y_train - a file where performed activities are listed
# reads file with train signals

subject_train <- read.table("./train/subject_train.txt")

activities_train <- read.table("./train/y_train.txt")

signals_train <- read.table("./train/X_train.txt", nrows = 7352, colClasses = "numeric")


# set column name in subject_train data frame
# set column names in activities_test data frame
# change names of columns to names of signals from features file

names(subject_train) <- "subjectID"

names(activities_train) <- "activityID"

names(signals_train) <- features[,2]


############################# STEP 5 ###########################################
# converts all data frames to tbl_df object from dplyr package

features_tbldf <- tbl_df(features)
activities_info_tbldf <- tbl_df(activities_info)

subject_test_tbldf <- tbl_df(subject_test)
activities_test_tbldf <- tbl_df(activities_test)
signals_test_tbldf <- tbl_df(signals_test)

subject_train_tbldf <- tbl_df(subject_train)
activities_train_tbldf <- tbl_df(activities_train)
signals_train_tbldf <- tbl_df(signals_train)

############################## STEP 6 ##########################################
# removes all data frames from memory
rm("features")
rm("activities_info")
rm("subject_test")
rm("activities_test")
rm("signals_test")
rm("subject_train")
rm("activities_train")
rm("signals_train")

############################## STEP 7 ##########################################
# merging

#merges test and train signals
signals_tbldf <- bind_rows(signals_test_tbldf, signals_train_tbldf)

#merges test and train activities
activities_tbldf <- bind_rows(activities_test_tbldf, activities_train_tbldf)

# combines ids of activities with their names and overwrites
activities_tbldf <- tbl_df(merge(activities_info_tbldf, activities_tbldf))

# merges test and train subjects
subject_tbldf <- bind_rows(subject_test_tbldf, subject_train_tbldf)


########################### STEP 8 #############################################
# selects mean values of signals
signals_mean_tbldf <- select(signals_tbldf, contains("mean"))

# selects standard deviations of signals
signals_std_tbldf <- select(signals_tbldf, contains("std"))

# creates one data set
data <- bind_cols(subject_tbldf, activities_tbldf, signals_mean_tbldf, signals_std_tbldf)

# drops activityID and overwrites data
data <- select(data, -activityID)

# checks activities performed by subjects
data %>% select(subjectID, activityName) %>% spread(activityName, subjectID) %>% unique()


########################### STEP 9 #############################################
# reorders data so that the names of features are no more columns but variavles
data_reordered <- gather(data, feature, value, tBodyAccmeanX_1:fBodyBodyGyroJerkMagstd_543)

# groups fata by subject and activity
data_reordered <- group_by(data_reordered, subjectID, activityName, feature)

# calculates mean values for each group
data_means <- summarize(data_reordered, meanValue=mean(value))

# separates feature name from number attached in the beginning of this script
# this way rows in feature column look nicer
data_means <- separate(data_means, feature, c("feature", "fID"))

# removes the column fID with numbers
data_means <- select(data_means, -fID)

# sorts data by subject and activity name
data_means <- arrange(data_means, subjectID, activityName, feature)


########################## STEP 10 #############################################
# writes data to disk
write.table(data_means, file = "tidy_data.txt", row.names = FALSE, quote = FALSE)
