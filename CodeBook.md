Libraries: httr (to handle https protocol), data.table (to handle datasets), dplyr (to aggregate variables to create the tidy data).

Variables:
featureNames and activityLabels contain metadata;
subjectTrain, activityTrain and featuresTrain contain training data;
subjectTest, activityTest and featuresTest contain test data;
subject, activity and features contain results of step 1 (combine the respective data in training and test data sets corresponding to subject, activity and features);
completeData contains merged data;
columnsWithMeanSTD contains column indices that have either mean or std;
requiredColumns contains activity and subject columns;
extractedData contains result of selected columns in requiredColumns from step 2;
extractedData$Activity contains activity names taken from metadata activityLabels (step 3);
names contains names of the variables in extractedData (changed at step 4);
extractedData$Subject is a factor variable;
tidyData is a dataset with average for each activity and subject (step 5).