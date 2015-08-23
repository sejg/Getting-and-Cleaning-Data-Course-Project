library(plyr)

# Step 1
# read data
TestLabelData<- read.table("y_test.txt")
TrainLabelData<- read.table("y_train.txt")

TestSubjectData<- read.table("subject_test.txt")
TrainSubjectData<- read.table("subject_train.txt")

TestXData<- read.table("x_test.txt")
TrainXData<- read.table("x_train.txt")

# merge data sets by rows

LabelData<- rbind(TrainLabelData, TestLabelData)
SubjectData<- rbind(TrainSubjectData, TestSubjectData)
XData<- rbind(TrainXData, TestXData)

# name variables

names(SubjectData)<-c("subject")
names(LabelData)<-c("activity")

Features<-read.table("features.txt")
names(XData)<-Featuresnames$V2

# merge data sets by column

TwoData<- cbind(SubjectData, LabelData)
Data<- cbind(XData, TwoData)

#Step 2

#find measurements of mean and standard deviation
subFeatures<-Features$V2[grep("mean\\(\\)|std\\(\\)", Features$V2)]

#subset the data frame
selectednames<-c(as.character(subFeatures),"subject","activity")
Data<-subset(Data, select=selectednames)

#Step 3

#get descriptive names
activitylabels<-read.table("activity_labels.txt")

#change 'activity' variable to descriptive names
Data$activity<-factor(Data$activity)
Data$activity<-factor(Data$activity, labels = as.character(activitylabels$V2))

#Step 4

# replace shorthand names with more appropriate variable names
# t becomes time, Acc becomes Acceleromete, Gyro becomes Gyroscope, 
# Mag becomes Magnitude, f becomes frequency, and BodyBody becomes Body
names(Data)<-gsub("^t","time", names(Data))
names(Data)<-gsub("Acc","Accelerometer", names(Data))
names(Data)<-gsub("Gyro","Gyroscope",names(Data))
names(Data)<-gsub("Mag","Magnitude", names(Data))
names(Data)<-gsub("^f","frequency",names(Data))
names(Data)<-gsub("BodyBody","Body",names(Data))

#Step 5
NewData<-aggregate(. ~subject + activity, Data, mean)
NewData<-NewData[order(NewData$subject,NewData$activity),]
# write to file
write.table(NewData, file="tidydata.txt",row.names = FALSE)
