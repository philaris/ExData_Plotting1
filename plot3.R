url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile="pwrconsm.zip"
datafile="household_power_consumption.txt"
if (!file.exists(zipfile)) { download.file(url, destfile=zipfile, method = "curl") }
if (!file.exists(datafile)) { unzip(zipfile) }
alld <- read.table(datafile, header=TRUE, sep=";", na.strings = "?")
d <- subset(alld, Date %in% c("1/2/2007", "2/2/2007"))
rm(alld)
d$pasted <- paste(d$Date, d$Time)
d$tmstamp <- strptime(d$pasted, "%d/%m/%Y %H:%M:%S")

png("plot3.png")
plot(d$tmstamp, d$Sub_metering_1, type = "l",
     ylab = "Energy sub metering", xlab = NA, col="black")
lines(d$tmstamp, d$Sub_metering_2, col="red")
lines(d$tmstamp, d$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lwd = c(2,2,2), col = c("black", "red", "blue"))
dev.off()

