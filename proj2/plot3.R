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

library(ggplot2)

baltimoretype <-
  baltcity %>% group_by(year, type) %>%
  summarise(total=sum(Emissions, na.rm = TRUE))

baltimoretypeplot <- qplot(year, total, data = baltimoretype) +
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
  facet_wrap(facets = ~ type, ncol=2) +
  ylab("Total PM2.5 emissions in Baltimore City in tons (per type)") +
  geom_line()
ggsave(filename = "plot3.png", plot = baltimoretypeplot)

