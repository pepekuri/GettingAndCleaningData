#Getting And Cleaning Data 
=========================

##Script description

Step 1. Process Variables: these variables are required in order to run the script because they store the working directory, the file names of the required files 
and the name of the final tidy data file These variables will be used during the process.

Step 2. Test files integration: all the Test files are read, bound and also the Activity labels are appended.

Step 3. Train files integration: all the Train files are read, bound and also the Activity labels are appended.

Step 4. Test & Train files integration: the outcome of the step 2 and step 3 are bound.

Step 5. Setting data frame column names: readable names are assigned to the variables of the step 4 outcome.

Step 6. Getting mean & std column names : only the columns containing mean() or std() on their names are taken in order to create a new data frame.

Step 7. Calculating average, grouping by Subject and Activity: the average of each column of the step 6 outcome are calculated grouping by subject and
activity.

Step 8. Creating final file: the outcome of the step 7 is exported to txt file.

End



