run_analysis <- function() {
  library(data.table)
  
  data_path <- "./UCI HAR Dataset/"
  test_path <- paste(data_path, "test/", sep="")
  train_path <- paste(data_path, "train/", sep="")
  # 1. Merges the training and the test sets to create one data set.
  
  ## 1a. load test set and train set
  test_set <- read.table(paste(test_path, "X_test.txt", sep=""))
  test_label <- read.table(paste(test_path, "y_test.txt", sep=""))
  train_set <- read.table(paste(train_path, "X_train.txt", sep=""))
  train_label <- read.table(paste(train_path, "y_train.txt", sep=""))
  ## 1b. merge the training and test sets, as well as the labels
  merge_set <- rbind(train_set, test_set)
  merge_labels <- rbind(train_label, test_label)
  # rm(test_set, test_label, train_set, train_label)
  # print(list(dim(merge_set), dim(merge_labels)))
  
  # 2. Extracts only the measurements on the mean and standard deviation for each measurement.
  features <- read.table(paste(data_path, "features.txt", sep=""))
  means_pos <- features[[1]][grep("mean", features[[2]])]
  means_desc <- grep("mean", features[[2]], value = TRUE)
  stds_pos <- features[[1]][grep("std", features[[2]])]
  stds_desc <- grep("std", features[[2]], value = TRUE)
  mean_set <- merge_set[, means_pos]
  std_set <- merge_set[, stds_pos]
  # rm(merge_set)
  
  # 3. Uses descriptive activity names to name the activities in the data set.
  act_lbls_idx <- read.table(paste(data_path, "activity_labels.txt", sep=""))
  act_lbls <- act_lbls_idx[merge_labels[[1]],2]
  
  # 4. Appropriately labels the data set with descriptive variable names.
  desc <- list(t="",
               f="FFT_",
               Acc="Acceleration_",
               Body="Body_",
               Graviy="Gravity_",
               Gyro="Gyro_",
               Jerk="Jerk_",
               Mag="Magnitude_",
               "-mean"="mean",
               "-sd"="sd",
               Freq="_Frequency",
               "\\(\\)"=""
               )
  for (i in seq_along(desc)) {
    means_desc <- gsub(names(desc)[i], desc[[i]], means_desc)
    stds_desc <- gsub(names(desc)[i], desc[[i]], stds_desc)
  }
  names(mean_set) <- means_desc
  names(std_set) <- stds_desc
  
  # 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  sbj_train <- read.table(paste(train_path, "subject_train.txt", sep=""))
  sbj_test <- read.table(paste(test_path, "subject_test.txt", sep=""))
  merge_sbjs <- rbind(sbj_train, sbj_test)
  # rm(sbj_train, sbj_test)
  # print(dim(merge_sbjs))
  
  # rm(mean_set, std_set)
  ms_set <- cbind(mean_set, std_set)
  ms_table <- data.table(ms_set)
  ms_table[, Activity:=act_lbls]
  ms_table[, Subject:=merge_sbjs]
  ms_molten <- melt(ms_table, id=c("Activity", "Subject"))
  tidy_set <- dcast(ms_molten, Activity + Subject ~ variable, mean)
  write.table(tidy_set, "tidy_set.txt", row.names=F)
}