library(data.table)

### PRE-PROCESS AND LOAD DATA ###

if (!file.exists("data.RData")) {
  # unzip source file
  unzip("exdata_data_household_power_consumption.zip")
  
  # replace ? characters with NA
  system("sed 's/[?]/NA/g' household_power_consumption.txt > data.txt")
  
  # read data into data table
  data <- fread("data.txt", sep = ";", na.strings = "?")
  
  # save the data as an R object
  save(data, file = "data.RData")
  
  # remove the temporary text files
  file.remove("household_power_consumption.txt","data.txt")
} else {
  load("data.RData")
}

### SUBSET AND PREPARE DATA ###

# subset to required dates (specified in original format)
data <- data[data$Date %in% c("1/2/2007","2/2/2007"), ]

# convert date and time to usable formats
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$Time <- as.POSIXct(paste(data$Date,data$Time))

### PLOT DATA ###

# plot multiple time series (plot 3)
png(width = 480, height = 480, bg = "transparent", file = "plot3.png")
with(data, {
  plot(x = Time, y = Sub_metering_1, type = "l", main = "",
       xlab = "", ylab = "Energy sub metering")
  lines(x = Time, y = Sub_metering_2, col = "red", type = "l", main = "",
         xlab = "", ylab = "")
  lines(x = Time, y = Sub_metering_3, col = "blue", type = "l", main = "",
        xlab = "", ylab = "")
})
legend("topright", lty = 1, col = c("black","red","blue"),
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()
