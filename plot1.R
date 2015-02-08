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

png("plot1.png")
hist(d$Global_active_power,
     main="Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")
dev.off()

