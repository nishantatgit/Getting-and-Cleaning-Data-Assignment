rm(list = ls())
print("reading features...")
features <- read.table("features.txt",header = FALSE, stringsAsFactors = FALSE)
features <- features[[2]]
features <- gsub("\\(|\\)", "", features)
features <- gsub("\\-","_", features)

print("reading activity labels..")
act_label <- read.table("activity_labels.txt",header = FALSE, stringsAsFactors = FALSE)


setwd("train")

print("reading training set..")
x_train <- read.table("x_train.txt", header = FALSE)
y_train <- read.table("y_train.txt", header = FALSE)
subject_train <- read.table("subject_train.txt", header = FALSE)


setwd("../test")
print("reading test set...")
x_test <- read.table("x_test.txt",header = FALSE)
y_test <- read.table("y_test.txt", header = FALSE)
subject_test <- read.table("subject_test.txt", header = FALSE)

setwd("..")
colnames(x_test) <- features
colnames(x_train) <- features
colnames(y_test) <- c("id")
colnames(y_train) <- c("id")
colnames(act_label) <- c("id","activity")
colnames(subject_train) <- c("subject")
colnames(subject_test)  <- c("subject")
 

act_label <- transform(act_label, activity = gsub("\\_"," ",tolower(activity))) 
  
x_mean <- grep("*mean",names(x_train))
x_std <- grep("*std",names(x_train))
x_test <- x_test[,c(x_mean,x_std)]
x_train <- x_train[,c(x_mean,x_std)]

y_train <- merge(y_train,act_label,by.x="id",by.y="id", all = TRUE)
y_test <- merge(y_test,act_label,by.x="id",by.y="id", all = TRUE)

x_train$activity <- y_train[[2]]

x_train <- cbind(x_train,subject_train)
x_test$activity <- y_test[[2]]
x_test <- cbind(x_test,subject_test)
print("merging training and test sets...")
tidy_data <- rbind(x_train,x_test)

print("done...")
library(data.table)
tidy_data2 <- data.table(tidy_data)

tidy_data2<- tidy_data2[, lapply(.SD, mean), by=c("subject", "activity")]



