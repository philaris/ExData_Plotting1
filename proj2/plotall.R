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

baltcity <- NEI %>% filter(fips == "24510")

totperyearbaltimore <-
  baltcity %>% group_by(year) %>%
  summarise(total=sum(Emissions, na.rm = TRUE)/1000)

png("plot2.png")
plot(totperyearbaltimore$year, totperyearbaltimore$total,
     xlim = c(1999, 2008), xaxp  = c(1999, 2008, 3),
     main="Total PM2.5 emmisions per year in Baltimore",
     xlab = "Year", ylab = "Emissions in thousand tons")
lines(totperyearbaltimore$year, totperyearbaltimore$total)     
dev.off()


library(ggplot2)

baltimoretype <-
  baltcity %>% group_by(year, type) %>%
  summarise(total=sum(Emissions, na.rm = TRUE))

baltimoretypeplot <- qplot(year, total, data = baltimoretype) +
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
  facet_wrap(facets = ~ type, ncol=2) +
  ylab("Total PM2.5 emissions in Baltimore City in tons (per type)") +
  geom_line()
ggsave(filename = "plot3.png")

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


ballac <- NEI %>% filter((fips == "24510") | (fips == "06037"))
ballacgroup <-
  ballac %>% filter(SCC %in% vehicleset) %>% group_by(year, fips) %>%
  summarise(total=sum(Emissions, na.rm = TRUE)) %>%
  mutate(place=(ifelse(fips == "24510", "Baltimore City", "Los Angeles County")))

ballacplot <- qplot(year, total, data = ballacgroup) +
  scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
  facet_wrap(facets = ~ place) +
  ylab("Motor vehicle PM2.5 emissions in tons") +
  geom_line()
ggsave(filename = "plot6.png")
