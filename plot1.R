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

#create histogram for Global Active Power
hist(DF$Global_active_power, breaks = 16, col = "red", main = "Global Active Power", xlab = "Global Active Power(kilowatts)")

#copy histogram to file
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()

#create line graph
with(DF, plot(date_time, Global_active_power, type = "l"))


                     