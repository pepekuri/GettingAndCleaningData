library("data.table")

setwd("C:/Temp/Coursera/Getting Data Clean/Project/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

#Reading Activities
s_activities_file <- "activity_labels.txt"
df_activities <- read.table(s_activities_file, header = FALSE, sep = "")
nrow(df_activities)
ncol(df_activities)
names(df_activities) <- c("ActivityId", "Activity")

#Reading x_test file 
x_test_file <- "./test/X_test.txt"
df_x_test <- read.table(x_test_file, header = FALSE, sep = "")
nrow(df_x_test)
ncol(df_x_test)

#Reading y_test file
y_test_file <- "./test/y_test.txt"
df_y_test <- read.table(y_test_file, header = FALSE, sep = "")
nrow(df_y_test)
ncol(df_y_test)
names(df_y_test) <- "ActivityId"
df_y_test <- merge( df_y_test, df_activities, by = "ActivityId" )

#Reading subject_test file
s_test_file <- "./test/subject_test.txt"
df_s_test <- read.table(s_test_file, header = FALSE, sep = "")
nrow(df_s_test)
ncol(df_s_test)

#Merge
df_test <- cbind(df_s_test, df_y_test, df_x_test)
nrow(df_test)
ncol(df_test)
head(df_test)

#Reading x_train file 
x_train_file <- "./train/X_train.txt"
df_x_train <- read.table(x_train_file, header = FALSE, sep = "")
nrow(df_x_train)
ncol(df_x_train)

#Reading y_train file
y_train_file <- "./train/y_train.txt"
df_y_train <- read.table(y_train_file, header = FALSE, sep = "")
nrow(df_y_train)
ncol(df_y_train)
names(df_y_train) <- "ActivityId"
df_y_train <- merge(df_y_train, df_activities, by = "ActivityId")

#Reading subject_train file
s_train_file <- "./train/subject_train.txt"
df_s_train <- read.table(s_train_file, header = FALSE, sep = "")
nrow(df_s_train)
ncol(df_s_train)

#Binding 
df_train <- cbind(df_s_train, df_y_train, df_x_train)
nrow(df_train)
ncol(df_train)

#Binding
df_full <- rbind(df_test, df_train)
nrow(df_full)
ncol(df_full)

#Column Names
col_names_file <- "features.txt"
ds_names <- read.table(col_names_file, header = FALSE, sep = "")
ds_names <- rbind(data.frame(V1 = 0, V2 = "Activity"), ds_names)
ds_names <- rbind(data.frame(V1 = 0, V2 = "ActivityId"), ds_names)
ds_names <- rbind(data.frame(V1 = 0, V2 = "Subject"), ds_names)
names(df_full) <- ds_names$V2


#Selecting mean and std columns
dt_col_names <- data.table(ColNameId = 1:length(df_full), ColName = names(df_full))
dt_col_names <- dt_col_names[ColName %like% ".*mean[(].*|.*st.*|Activity.*|Subject"]
df_mean_std <- df_full[, dt_col_names$ColName]

dt_mean_std <- data.table(df_mean_std)
dt_mean_std_2 <- aggregate(dt_mean_std, by = list(Subject_ = dt_mean_std$Subject, ActivityId_ = dt_mean_std$ActivityId, Activity_ = dt_mean_std$Activity), FUN = mean, na.rm = TRUE)
names(dt_mean_std_2)
dt_mean_std_2


drops <- c("Subject","Activity", "ActivityId")
dt_mean_std_2 <- dt_mean_std_2[,!(names(dt_mean_std_2) %in% drops)]


write.table(dt_mean_std_2, file = "Tidy_Data.txt", row.name=FALSE)



