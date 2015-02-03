#import dataset from R script:
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./household_power_consumption.zip", mode = "wb", method = "curl")

#uncompress zip file
unzip("./household_power_consumption.zip", "household_power_consumption.txt")


#read only specific rows of file using sqldf package
library(sqldf)
DF <- read.csv2.sql("household_power_consumption.txt", sql = "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'", header = TRUE, sep = ";")

#replace '?' in data with NA
DF[DF == "?"] <- NA

#combine date and time variables and convert to POSIXlt format

DF$date_time <- paste(DF$Date, DF$Time)
DF$date_time <- strptime(DF$date_time, "%d/%m/%Y %H:%M:%S")

#create line graph for Global Active Power
par(mar = c(2,5,2,2))
with(DF, plot(date_time, Global_active_power, xlab = NA, ylab = "Global Active Power (kilowatts)", type = "l"))

#copy graph to file
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()

