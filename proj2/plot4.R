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

coalset <-
  ( SCC %>%
      filter(grepl("Combustion", Short.Name) | grepl("Combustion", SCC.Level.One),
             grepl("Coal", Short.Name) | grepl("Coal", SCC.Level.Three)) %>%
      select(SCC) ) [["SCC"]]

coalperyear <- NEI %>% filter(SCC %in% coalset) %>% group_by(year) %>%
  summarise(total=sum(Emissions, na.rm = TRUE)/1000)
png("plot4.png")
plot(coalperyear$year, coalperyear$total,
     xlim = c(1999, 2008), xaxp  = c(1999, 2008, 3),
     main="Coal comb. PM2.5 emmisions per year in USA",
     xlab = "Year", ylab = "Emissions in thousand tons")
lines(coalperyear$year, coalperyear$total)     
dev.off()

