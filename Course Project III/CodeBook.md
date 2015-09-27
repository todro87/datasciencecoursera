How the script run_analysis.R works
===========

The way the script worsk is explained in 10 consecutive steps. Each step is marked in the run_analysis.R file.

This script work only when the structure of files is as below:

./activity_labels.txt

./features.txt

./test/subject_test.txt

./test/X_test.txt

./test/y_test.txt

./train/subject_train.txt

./train/X_train.txt

./train/y_tran.txt

./run_analysis.R

Dot sign denotes the working directory

### Step 1

In this step libraries dplyr and tidyr are loaded. The will be used to manipualte data in order to create tidy data set.

### Step 2

In step two sciprt operates on files in working directory: activity_labels.txt and features.txt. File activity_labels.txt contains names of activities and their ID numbers. In features.txt names of all variables are stored. These variables deonte the names of signals from accelerometer and gyroscope. After reading feature.txt all the alphanumeric charatcers and numbers are removed from names of variables. After that to each variable a unique number is added. This is necessary in order to have unique names of variables.

In this step script also reads a file with names of acitvities and their IDs. Each column in each object gets a unique name.

### Step 3

In step 3 script read three files: subject_test.txt with IDs of each person who performed an activity, y_test.txt with IDs of each performed activity, X_test.txt with the recorded signals (not raw signals). Each column in each object created in this step gets a unique name. Signals from X_test.txt get names from features object

### Step 4

This step does the same as step 3 but on files from train directory.

### Step 5

In the fifth step all the data frame are converted into tbl_df objects. Now the power of dplyr and tidyr can be revealed!

### Step 6

Data frames are removed to free the memory. This way it is also easier to use the auto completion in RStudio.

### Step 7

In step 7 test and train objects are merged. Also the object with a list of performed activities is merged with the object with names of activities and their IDs.

### Step 8

In this step only the means and standrad deviations of signals are selected. Object with means and standard deviations is merged with performed activities and subjects who have been performing activities. I have also checked if every person in the experiment has beedn performing every activity. It seems that people have been divided into groups performing different activities. 

### Step 9

Now data is reorded so that features with variable names are no longer columns but rows. Reordered data is grouped by subject, activity and variable. From that moment it is possible to calculate means of each variable for each subject and activity. To have data which look much nicer from each variable name a unique number is removed by sepataion of string and number. Now the column with numbers is just dropped. Last operation in this step sorts data by subject and activity name.

### Step 10

In the final step data is exported to a file tidy_data.txt in working directory.

### Names of variables in tidy_data.txt

* subjectID - this column contains IDs of each person who performed activity
* activityName - this column contains descriptive names of performed activities
* feature - this column contains descriptive names of signals
* meanValue - this column contains mean values of signals

A file with tidy data has only 4 columns and 3011 rows.