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

baltcity <- NEI %>% filter(fips == "24510")

vehicleset <-
  ( SCC %>%
      filter(grepl("Mobile Sources", SCC.Level.One),
             grepl("Vehicle", SCC.Level.Two))
  ) [["SCC"]]

baltveh <- baltcity %>% filter(SCC %in% vehicleset) %>% group_by(year) %>%
  summarise(total=sum(Emissions, na.rm = TRUE))
png("plot5.png")
plot(baltveh$year, baltveh$total,
     xlim = c(1999, 2008), xaxp  = c(1999, 2008, 3),
     main="Motor vehicle PM2.5 emmisions in Baltimore City",
     xlab = "Year", ylab = "Emissions in tons (per year)")
lines(baltveh$year, baltveh$total)     
dev.off()

