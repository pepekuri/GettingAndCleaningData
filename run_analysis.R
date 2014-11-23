########################
## Required libraries ##
########################

library("data.table")

#######################
## Process Variables ##
#######################

WorkDirectory <- "C:/Temp/Coursera/Getting Data Clean/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset"
ActivityLabesFile <- "activity_labels.txt"
xTestFile <- "./test/X_test.txt"
yTestFile <- "./test/y_test.txt"
SubjectTestFile <- "./test/subject_test.txt"
xTrainFile <- "./train/X_train.txt"
yTrainFile <- "./train/y_train.txt"
sTrainFile <- "./train/subject_train.txt"
ColNamesFile <- "features.txt"
FinalFile <- "Tidy_Data.txt"

############################
## Setting Work Directory ##
############################

setwd(WorkDirectory)

##################################
## Reading Activity Labels File ##
##################################

df_activities <- read.table(ActivityLabesFile, header = FALSE, sep = "")
names(df_activities) <- c("ActivityId", "Activity")

############################
## Test files integration ##
############################

## Reading x_test file 
df_x_test <- read.table(xTestFile, header = FALSE, sep = "")

## Reading y_test file
df_y_test <- read.table(yTestFile, header = FALSE, sep = "")
names(df_y_test) <- "ActivityId"

## Merging Activity labels
df_y_test <- merge( df_y_test, df_activities, by = "ActivityId" )

## Reading subject_test file
df_s_test <- read.table(SubjectTestFile, header = FALSE, sep = "")

## Merging Test files
df_test <- cbind(df_s_test, df_y_test, df_x_test)

#############################
## Train files integration ##
#############################

## Reading x_train file
df_x_train <- read.table(xTrainFile, header = FALSE, sep = "")

## Reading y_train file
df_y_train <- read.table(yTrainFile, header = FALSE, sep = "")
names(df_y_train) <- "ActivityId"

## Merging Activity labels
df_y_train <- merge(df_y_train, df_activities, by = "ActivityId")

## Reading subject_train file
df_s_train <- read.table(sTrainFile, header = FALSE, sep = "")

## Merging Train files
df_train <- cbind(df_s_train, df_y_train, df_x_train)

####################################
## Test & Train files integration ##
####################################

df_full <- rbind(df_test, df_train)

#####################################
## Setting data frame column names ##
#####################################

## Reading features file
ds_names <- read.table(ColNamesFile, header = FALSE, sep = "")
ds_names <- rbind(data.frame(V1 = 0, V2 = "Activity"), ds_names)
ds_names <- rbind(data.frame(V1 = 0, V2 = "ActivityId"), ds_names)
ds_names <- rbind(data.frame(V1 = 0, V2 = "Subject"), ds_names)
names(df_full) <- ds_names$V2

#####################################
## Getting mean & std column names ##
#####################################

## Filtering mean and std columns using regular expressions
dt_col_names <- data.table(ColNameId = 1:length(df_full), ColName = names(df_full))
dt_col_names <- dt_col_names[ColName %like% ".*mean[(].*|.*st.*|Activity.*|Subject"]
df_mean_std <- df_full[, dt_col_names$ColName]

##########################################################
## Calculating average, grouping by Subject and Ativity ##
##########################################################

dt_mean_std <- data.table(df_mean_std)
dt_mean_std_2 <- aggregate(dt_mean_std, by = list(Subject_ = dt_mean_std$Subject, ActivityId_ = dt_mean_std$ActivityId, Activity_ = dt_mean_std$Activity), FUN = mean, na.rm = TRUE)
drops <- c("Subject","Activity", "ActivityId")
dt_mean_std_2 <- dt_mean_std_2[,!(names(dt_mean_std_2) %in% drops)]

##########################
## Creatinf fiinal file ##
##########################

write.table(dt_mean_std_2, file = FinalFile, row.name=FALSE)
