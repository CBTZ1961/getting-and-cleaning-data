---
title: "Code Book for getting-and-cleaning-data final assignment"
output: github_document
---

Assumption is that data have been downloaded already into directory:
C:/Users/Christian/datasciencecoursera/Assignmentf

The assignment does not state that the download need to be included in the script and that a generic directory is used.
After download the data are uploaded into R . First only the data required for part one of the assignment are read. Other data is read later on.

Additional file with descriptive feature names (C:/Users/Christian/datasciencecoursera/Assignmentf/names_new.csv) has been created and is read in step4

## Main variables:
part 1:
total data: data frame,contains all the train and test data merged together by subject and activity code 

part 2:
all_data: data frame, contains all the measurements for features with mean() and std() in their names by subject 
          and activity code
          
part 3:
all_data: all_data from part 2, where activity code is replaced by desciption

part 4:
all_data: all_data from part 3 where feature names are replace by descriptive names from file ./names_new.csv

part 5:
 gb_activity_means:    all_data df split by activity and mean calculated by feature column (across all subjects)
 stored in file: 'activity_means.csv' in the work directory
 gb_subjects_means:   all_data  df split by subject and mean calculated by feature column(across all activities)
 stored in file: 'subject_means.csv' in the work directory
 gb_activity_subject_means: all-data df split by subject and activity. Mean calculated by feature column
 stored in file: 'activity_subject_means.csv' in the work directory
 

## Script logic:

Part one of the assignment:

Merges the training and the test sets to create one data set.

After reading the data from the file, I first added the subjects to the files as first column. Then the test data and the train data are merged together.
I did not use the merge command but tather rbind since the test data set is really an extension of the train data set.

```
    test_data <-cbind(subject_test, y_test, X_test)
    train_data <-cbind(subject_train, y_train, X_train)
    total_data <- rbind(test_data, train_data)

```
Result after step 1:
```
head(total_data[, 1:10],3)
  subject V1      V1.1          V2          V3         V4         V5         V6         V7         V8
1       2  5 0.2571778 -0.02328523 -0.01465376 -0.9384040 -0.9200908 -0.6676833 -0.9525011 -0.9252487
2       2  5 0.2860267 -0.01316336 -0.11908252 -0.9754147 -0.9674579 -0.9449582 -0.9867988 -0.9684013
3       2  5 0.2754848 -0.02605042 -0.11815167 -0.9938190 -0.9699255 -0.9627480 -0.9944034 -0.9707350

```
```
tail(total_data[, 1:10],3)
      subject V1      V1.1          V2          V3         V4          V5        V6         V7          V8
10297      30  2 0.2733874 -0.01701062 -0.04502183 -0.2182182 -0.10382198 0.2745327 -0.3045152 -0.09891303
10298      30  2 0.2896542 -0.01884304 -0.15828059 -0.2191394 -0.11141169 0.2688932 -0.3104875 -0.06820033
10299      30  2 0.3515035 -0.01242312 -0.20386717 -0.2692704 -0.08721154 0.1774039 -0.3774040 -0.03867806
```

 Part two of the assginment:
 
 Extracts only the measurements on the mean and standard deviation for each measurement.
 
 
 First I get all features and select those, which have a 'mean' or a 'std' in the description:
 
```
    features <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
    mean_features <- filter(features, grepl('mean()', features[, 2]))
    std_features <- filter(features, grepl('std()', features[, 2]))
```
I then set the now column names for the total_data data frame and subset based on the selected features

```
    colnames(total_data) <- c('subject', 'activity',as.character(features[ ,2]))
    all_data <-  subset(total_data, select = c('subject', 'activity', as.character(mean_features[ ,2]), as.character(std_features[ ,2])))
    
```
Result after step 2
```
head(all_data[, 1:7],3)
  subject activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tGravityAcc-mean()-X tGravityAcc-mean()-Y
1       2        5         0.2571778       -0.02328523       -0.01465376            0.9364893           -0.2827192
2       2        5         0.2860267       -0.01316336       -0.11908252            0.9274036           -0.2892151
3       2        5         0.2754848       -0.02605042       -0.11815167            0.9299150           -0.2875128
```

 Part three of the assginment:
 
 Uses descriptive activity names to name the activities in the data set
 
 Read in the actvity labels and replaces the activiy codes with the descriptive labels
 
``` 
    activity_labels <- read.table("C:/Users/Christian/datasciencecoursera/Assignmentf/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
    for( i in 1:length(all_data[, 2]))  {all_data[i,2] = as.character(activity_labels[all_data[i,2],2])}
``` 

Result after step 3:
```
head(all_data[, 1:7],3)
  subject activity tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tGravityAcc-mean()-X tGravityAcc-mean()-Y
1       2 STANDING         0.2571778       -0.02328523       -0.01465376            0.9364893           -0.2827192
2       2 STANDING         0.2860267       -0.01316336       -0.11908252            0.9274036           -0.2892151
3       2 STANDING         0.2754848       -0.02605042       -0.11815167            0.9299150           -0.2875128``
```

Part four of the assginment:

Appropriately labels the data set with descriptive variable names

Reads file with descriptive labels and exchanges them as column headers

```
    names_new <- read.csv("C:/Users/Christian/datasciencecoursera/Assignmentf/names_new.csv", header=FALSE)
    colnames(all_data) <- c(as.character(names_new[ ,2]))
```
Result after step 4:
```
head(all_data[, 1:4],3)
  subject activity body acceleration along x axis of phone body acceleration along y axis of phone
1       2 STANDING                               0.2571778                             -0.02328523
2       2 STANDING                               0.2860267                             -0.01316336
3       2 STANDING                               0.2754848                             -0.02605042
```

Part five of the assginment:

Three different files with average values are created:
Means per activity across all subjects,
Means per subject across all activies, and
Means per activity and subject combinatiion

Means per activity across all subjects
 - data are split by activity
 - Means are calculated for each column (note that the activity column needs to be excluded)
 - The result is the tranposed matix,so I need transpose it back
 - Defining rownames as first colum of data set
 - Writig into csv file

```
    gb_activity <- split(subset(all_data, select = -subject), all_data$activity)
    gb_activity_means <- t(sapply(gb_activity, function(x){colMeans(x[,-1])}))
    gb_activity_means <- as.data.frame(gb_activity_means)
    activities <- rownames(gb_activity_means)
    rownames(gb_activity_means) <- NULL
    gb_activity_means <- cbind(activities,gb_activity_means)
    write.csv(gb_activity_means, file ='activity_means.csv')

```

Similar for means by subject
 
```
    gb_subject  <- split(subset(all_data, select =  -activity), all_data$subject)
    gb_subjects_means <- t(sapply(gb_subject, function(x){colMeans(x)}))
    gb_subject_means <- as.data.frame(gb_subjects_means)
    write.csv(gb_subject_means, file ='subject_means.csv')
```

Mean for activity subject combination

Split by subject and activity.
The split function also adds an index to the activities, which needs to get removed later on

```
    gb_activity_subject <- split(all_data, all_data[,c('subject','activity')])
    gb_activity_subject_means <- t(sapply(gb_activity_subject, function(x){colMeans(x[,-2])}))
    gb_activity_subject_means <- as.data.frame(gb_activity_subject_means)
```
finally do the final touches to tidy the data, by defining the rowname column, remove the index from the rownmes  and sort the data

```
    activities <- rownames(gb_activity_subject_means)
    rownames(gb_activity_subject_means) <- NULL
    activities <- sapply(activities, function(x){strsplit(x,'\\.')[[1]][2]})
    gb_activity_subject_means <- cbind(activities,gb_activity_subject_means)
    gb_activity_subject_means <- arrange(gb_activity_subject_means, subject, activities)
    gb_activity_subject_means <- gb_activity_subject_means[ , c(2, 1, 3:ncol(gb_activity_subject_means)) ]
    write.csv(gb_activity_subject_means, file ='subject_activity_means.csv')
```

I hope this is all correct and I did not misunderstand the task.it was quite some effort with all the renaming etc.
