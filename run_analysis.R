setwd("C:/Users/Christian/datasciencecoursera/Assignmentf")
library(dplyr)
# Part 1: Merges the training and the test sets to create one data set
    X_test  <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
    X_train <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="", stringsAsFactors=FALSE)
    y_test  <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
    y_train <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
    subject_test  <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
    subject_train <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
    colnames(subject_test)  <- c('subject')
    colnames(subject_train)  <- c('subject')
    test_data <-cbind(subject_test, y_test, X_test)
    train_data <-cbind(subject_train, y_train, X_train)
    total_data <- rbind(test_data, train_data)
    
# Part 2: Extracts only the measurements on the mean and standard deviation for each measurement.
    features <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
    mean_features <- filter(features, grepl('mean()', features[, 2]))
    std_features <- filter(features, grepl('std()', features[, 2]))
    colnames(total_data) <- c('subject', 'activity',as.character(features[ ,2]))
    all_data <-  subset(total_data, select = c('subject', 'activity', as.character(mean_features[ ,2]), as.character(std_features[ ,2])))
    
# Part 3 Uses descriptive activity names to name the activities in the data set
    activity_labels <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
    for( i in 1:length(all_data[, 2]))  {all_data[i,2] = as.character(activity_labels[all_data[i,2],2])}
    
# Part 4 Appropriately labels the data set with descriptive variable names.
    names_new <- read.csv("C:/Users/Christian/datasciencecoursera/Assignmentf/names_new.csv", header=FALSE)
    colnames(all_data) <- c(as.character(names_new[ ,2]))
    
# Part 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

    gb_activity <- split(subset(all_data, select = -subject), all_data$activity)
    gb_activity_means <- t(sapply(gb_activity, function(x){colMeans(x[,-1])}))
    gb_activity_means <- as.data.frame(gb_activity_means)
    activities <- rownames(gb_activity_means)
    rownames(gb_activity_means) <- NULL
    gb_activity_means <- cbind(activities,gb_activity_means)
    write.csv(gb_activity_means, file ='activity_means.csv')
    
    gb_subject  <- split(subset(all_data, select =  -activity), all_data$subject)
    gb_subject_means <- t(sapply(gb_subject, function(x){colMeans(x)}))
    gb_subject_means <- as.data.frame(gb_subject_means)
    write.csv(gb_subject_means, file ='subject_means.csv')
    
    gb_activity_subject <- split(all_data, all_data[,c('subject','activity')])
    gb_activity_subject_means <- t(sapply(gb_activity_subject, function(x){colMeans(x[,-2])}))
    gb_activity_subject_means <- as.data.frame(gb_activity_subject_means)
    activities <- rownames(gb_activity_subject_means)
    rownames(gb_activity_subject_means) <- NULL
    activities <- sapply(activities, function(x){strsplit(x,'\\.')[[1]][2]})
    gb_activity_subject_means <- cbind(activities,gb_activity_subject_means)
    gb_activity_subject_means <- arrange(gb_activity_subject_means, subject, activities)
    gb_activity_subject_means <- gb_activity_subject_means[ , c(2, 1, 3:ncol(gb_activity_subject_means)) ]
    write.csv(gb_activity_subject_means, file ='subject_activity_means.csv')
    
    
    
    