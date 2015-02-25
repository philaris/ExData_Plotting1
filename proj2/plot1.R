url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zipfile = "airpollution.zip"
if (!file.exists(zipfile)) { download.file(url, destfile=zipfile, method = "curl") }
summaryfile = "summarySCC_PM25.rds"
classifile = "Source_Classification_Code.rds"
if ((!file.exists(summaryfile)) | (!file.exists(classifile))) {
  unzip(zipfile, overwrite = FALSE)
}
if (!exists("NEI")) { NEI <- readRDS(summaryfile) }
if (!exists("SCC")) { SCC <- readRDS(classifile) }

library(dplyr)

totperyear <- NEI %>% group_by(year) %>%
  summarise(total=sum(Emissions, na.rm = TRUE)/1000000)
png("plot1.png")
plot(totperyear$year, totperyear$total,
     xlim = c(1999, 2008), xaxp  = c(1999, 2008, 3),
     main="Total PM2.5 emmisions per year in USA",
     xlab = "Year", ylab = "Emissions in million tons")
lines(totperyear$year, totperyear$total)     
dev.off()

