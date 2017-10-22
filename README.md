# Description of Getting and Cleaning Data Course Project
This repo hosts the scripts, final tidy data set and two description files for the week 4 course project of the course **Getting and Cleaning Data**
---

## Description of the scirpts
To successfully run the run_analysis.R script, please follow the steps as below:
1. Download the data from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and unzip to a directory.
2. Place the run_analysis.R under the `UCI HAR Dataset` directory just unzipped.
3. Enter R environment, the script has been test in R version 3.2.3.
4. (optional) Install **data.table** package if necessary, which is required by the script.
5. Execute the R source script and generate the tidy data set, which is placed under the same directory and named "tidy_set.txt".

## The tidy data set
After running the script, it generates the tidy data set which every column is the average of the mean and standard deviation of each measurement, of each activity and subject.  The headings in the first row tell the meaning of each variable.

To read the tidy data set, please use the below R code:
`data <- read.table("tidy_set.txt", header=TRUE)`

The codebook CodeBook.md contains detail description of the variables.

## How does the script work
The code was implemented based on the instructions of the course project.
1. Merges the training and the test sets to create one data set.  
The script reads the training and test set into two different data frames, then merges the two sets into one using rbind. It also treats the training and test labels similarly.
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
The script searches for feature names containing the word _mean_ or _std_ using `grep` command and extract the columns to new data frames.
3. Uses descriptive activity names to name the activities in the data set.  
In this step the script only needs to read in the activity names file and replace the label data frame with the activity names.
4. Appropriately labels the data set with descriptive variable names.  
First a list of abbreviations-long form term pairs is created, then the original feature names are replaced by the more descriptive variable names by using `gsub` command.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  
The script first reads the lists of subjects of training and test set and merge then together. Then it combines the mean and standard deviation sets into one data set, and add the columns of activities and subjects to that set. For the purpose to group the values by activities and subjects, the script runs the `melt` and `dcast` command to summarize and find the means of the values. Here the data frame is casted into data table for ease of operation. Lastly the data set is written to the output file.
