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


#create 4 graphs 
png(file = "plot4.png",width = 480, height = 480)
par(mar = c(4,5,2,2), cex = 0.5)
par(mfrow = c(2,2))


#for Global Active Power
with(DF, plot(date_time, Global_active_power, xlab = NA, ylab = "Global Active Power", type = "l"))

#for Voltage
with(DF,plot(date_time, Voltage, xlab = "datetime", ylab = "Voltage", type = "l"))

#for Energy Sub Metering
with(DF, plot(date_time, Sub_metering_1, xlab = NA, ylab = "Energy sub metering", type = "n"))
with(DF, lines(date_time, Sub_metering_1))
with(DF, lines(date_time, Sub_metering_2, col = "red"))
with(DF, lines(date_time, Sub_metering_3, col = "blue"))
legend("topright", bty = "n", lty = 1, col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex = 0.75)

#for Global Reactive Power
with(DF,plot(date_time, Global_reactive_power, xlab = "datetime", ylab = "Global Reactive Power", type = "l"))

dev.off()