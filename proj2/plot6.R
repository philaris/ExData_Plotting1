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
library(ggplot2)

ballac <- NEI %>% filter((fips == "24510") | (fips == "06037"))

vehicleset <-
  ( SCC %>%
      filter(grepl("Mobile Sources", SCC.Level.One),
             grepl("Vehicle", SCC.Level.Two))
  ) [["SCC"]]

ballacgroup <-
  ballac %>% filter(SCC %in% vehicleset) %>% group_by(year, fips) %>%
  summarise(total=sum(Emissions, na.rm = TRUE)) %>%
  mutate(place=(ifelse(fips == "24510", "Baltimore City", "Los Angeles County")))

ballacplot <- qplot(year, total, data = ballacgroup) +
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
  facet_wrap(facets = ~ place) +
  ylab("Motor vehicle PM2.5 emissions in tons") +
  geom_line()
ggsave(filename = "plot6.png", plot = ballacplot)
