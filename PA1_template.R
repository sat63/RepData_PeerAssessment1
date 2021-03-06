
  ## Loading and preprocessing the data ##
  
setwd("C:/Users/sanch/Desktop/JHU_DS")

# Library
library(ggplot2)
library(lattice)
actdata <- read.csv("activity.csv", stringsAsFactors = FALSE)

actdata$date

str(actdata) #display the structure of actdata

summary(actdata) #provide summary of actdata

head(actdata) #headers

pairs(actdata) #create scatterplot matrices


  ## What is mean total number of steps taken per day?

stepsperday <- aggregate(steps ~ date, actdata, sum, na.rm = TRUE) # split data into subsets and compute summary
  
hist(stepsperday$steps)

meansteps <- mean(stepsperday$steps)
meansteps

mediansteps <- median(stepsperday$steps)
mediansteps
  
  ## What is the average daily activity pattern?

intervalsteps <- aggregate(steps ~ interval, actdata, mean, na.rm = TRUE)

plot(steps ~ interval, intervalsteps, type = "l") ## L 

  # calculate which 5 min interval, on average across all days in dataset, contains max steps

maxsteps <- intervalsteps[which.max(intervalsteps$steps),]$interval
maxsteps

## Imputing missing values

missingval <- sum(is.na(actdata$steps))
missingval

  # Fill missing values with mean per interval

getMean <- function(interval){
  intervalsteps[intervalsteps$interval == interval,]$steps
}

  # Create new dataset with missing data filled in the original dataset

activitydata <- actdata
for (i in 1:nrow(activitydata)){
  if(is.na(activitydata[i,]$steps)){
    activitydata[i,]$steps <- getMean(activitydata[i,]$interval)
  }
}

totalsteps <- aggregate(steps ~ date, activitydata, sum)
hist(totalsteps$steps)

meanStepsPerDay <- mean(totalsteps$steps)
  
medianStepsPerDay <- median(totalsteps$steps)

## Are there differences in activity patterns between weekdays and weekends?

activitydata$date <- as.Date(strptime(activitydata$date, format = "%Y-%m-%d"))
activitydata$day <- weekdays(activitydata$date)
for (i in 1:nrow(activitydata)){
  if (activitydata[i,]$day %in% c("Saturday", "Sunday")) {
    activitydata[i,]$day <- "Weekend"
  }
  else{
    activitydata[i,]$day <- "Weekday"
  }
}

daysteps <- aggregate(activitydata$steps ~ activitydata$interval + activitydata$day, activitydata, mean)

daysteps


names(daysteps) <- c("interval", "day", "steps")

xyplot(steps ~ interval | day, daysteps, type = "l", layout = c(1,2),
       xlab = "Interval", ylab = "Number of Steps")
