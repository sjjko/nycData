data <- read.table(file="/home/kos/Code/kos/dataMining/nycData/taxiSoda.csv",sep = ",", header = TRUE)

#get rid of unreasonable data
data <- data[data$trip_distance<100.0,]
data <- data[data$passenger_count>0,]
data <- data[data$pickup_latitude!=0,]
data <- data[data$trip_distance>0.0,]
data <- data[data$fare_amount>0.0,]

library(gclus)
data.r <- abs(cor(data)) # get correlations
data.col <- dmat.color(data.r) # get colors
data.o <- order.single(data.r) 
cpairs(data, data.o, panel.colors=data.col, gap=.5,main="Variables Ordered and Colored by Correlation" ) 
#hist(data$passenger_count)
#hist(data$fare_amount)
#hist(data$tip_amount)
#hist(data$trip)

with(data,plot(passenger_count,trip_distance))
distance_p_passenger <- with(data,trip_distance)

getDistPerPass <- function(passcount)
{
  onePdata <- data[data$passenger_count==passcount,]
  mVal <- mean(onePdata$trip_distance)
  return(mVal)
}
getTimePerPass <- function(passcount)
{
  onePdata <- data[data$passenger_count==passcount,]
  dt<-abs(onePdata$pickup_time-onePdata$dropoff_time)/60 #in minutes
  mVal <- mean(dt)
  return(mVal)
}

queens_jacksonheights_latitude=40.757459
queens_jacksonheights_longitude=-73.885617
queens_woodside_latitude=40.750607
queens_woodside_longitude=-73.904139
queens_astoria_latitude=40.750088
queens_woodside_longitude=-73.903397

upper_east_lat=40.771308
upper_east_lon= -73.959537
upper_west_lat=40.785263
upper_west_lon=  -73.976240

regions_list=c("Upper East Side","Upper West Side","Harlem",
               "Hells Kitchen","East Village","Tribeca",
               "Downtown","Little Italy",
               "Greenwich Village","Chelsea","Midtown",
               "Washington Heights","Bronx")
regions_lat=c(upper_east_lat,upper_west_lat,40.809844,40.763260,
              40.727240,40.715910,40.709650,
              40.719050,40.733313,40.747391,40.755482,40.842172,40.820159)
regions_long=c(upper_east_lon,upper_west_lon, -73.946402,-73.992351,
               -73.982070,-74.009129,-74.011642, 
               -73.997206,-74.002988,-74.001412,-73.983629,
               -73.939661,-73.918615)


getmindist <- function(lat,lon,lat2,lon2)
{
  return(abs(lat-lat2)+abs(lon-lon2))
}

getNameDropOff <- function(longitude,latitude)
{
  mindist<-1000000
  regionName<-""
  for(i in 1:length(regions_list)){
    val <- getmindist(latitude,longitude,regions_lat[i],regions_long[i])
    #print(val)
    if(val<mindist)
      {
      regionName<-regions_list[i]
      mindist <- val
      }
    }
  return(regionName)
}

list_dropoff_region <- mapply(getNameDropOff,data$dropoff_longitude,data$dropoff_latitude)
list_pickup_region <- mapply(getNameDropOff,data$pickup_longitude,data$pickup_latitude)

#append the columns with the region names
data_erweitert <- cbind(data,list_dropoff_region)
data_erweitert <- cbind(data_erweitert,list_pickup_region)

listPassengers <- unique(data$passenger_count)

distPassengersMean <- lapply(listPassengers,getDistPerPass)
plot(unlist(distPassengersMean), type = "l")
unlist(distPassengersMean), cex = .5, col = "dark red")

 <- lapply(listPassengers,getTimePerPass)
plot(unlist(timePassengersMean), type = "l")
points(unlist(timePassengersMean), cex = .5, col = "dark red")

#now evaluate dt for midnight rides
filterTime <- function(dropoff_time,pickup_time)
{
  returndT <- -1000
  deltaT <- dropoff_time-pickup_time
  if(deltaT<0)
  {
    returndT <- dropoff_time+(24*3600-pickup_time) #ueber Mitternacht
  }
  else
  {
    returndT <- deltaT
  }
  return(returndT)
}

dT <- mapply(filterTime, data$dropoff_time,data$pickup_time)
data_erweitert <- cbind(data_erweitert,dT)


getMeanDistPerHourRegion <- function(regionname)
{
  onePdata <- data_erweitert[data_erweitert$list_dropoff_region==regionname,]
  tmp <- onePdata$trip_distance/onePdata$dT*3600 #return value in miles/hour
  mVal <- mean(tmp)
  return(mVal)
}
getMeanTipPerFareRegion <- function(regionname)
{
  onePdata <- data_erweitert[data_erweitert$list_dropoff_region==regionname,]
  tmp <- onePdata$tip_amount/onePdata$fare_amount
  mVal <- mean(tmp)
  return(mVal)
}

frame()

par(xaxt="t")
par(yaxt="t")
kmpHRegion <- lapply(regions_list,getMeanDistPerHourRegion)
kmpHRegion <- as.vector(kmpHRegion)
#now sort the list
kmpHInd <- order(unlist(kmpHRegion))
kmpHSorted <- kmpHRegion[kmpHInd]
regionSorted <- regions_list[kmpHInd]
lablist.x<-as.vector(regionSorted)

plot(unlist(kmpHSorted),col="blue", type = "l",xlab="",ylab="mph",xaxt="n")## axes=FALSE) #at=1:length(regions_list),labels=regions_list,unlist(kmpHRegion)
points(unlist(kmpHSorted), cex = .5, col = "dark red")
axis(1, at=seq(1, length(regions_list), by=1),labels=lablist.x,las=2)

par(xaxt="t")
par(yaxt="t")
tipPerFare <- lapply(regions_list,getMeanTipPerFareRegion)
tipPerFare <- as.vector(tipPerFare)
#now sort the list
kmpHInd <- order(unlist(tipPerFare))
tipPerFareSorted <- tipPerFare[kmpHInd]
regionSorted <- regions_list[kmpHInd]
lablist.x<-as.vector(regionSorted)

plot(unlist(tipPerFareSorted),col="green", type = "l",xlab="",ylab="% of Tip in Fare amount",xaxt="n")## axes=FALSE) #at=1:length(regions_list),labels=regions_list,unlist(kmpHRegion)
points(unlist(tipPerFareSorted), cex = .5, col = "dark red")
axis(1, at=seq(1, length(regions_list), by=1),labels=lablist.x,las=2)

getDistancePerRide <- function(inputRegionName)
{
  sumDistance=0
  sumRides=0
  dataset <- data_erweitert[data_erweitert$list_pickup_region==inputRegionName,]
  for(i in 1:nrow(dataset))
  {
    sumDistance=sumDistance+as.numeric(dataset$trip_distance[i])
    sumRides=sumRides+1
  }
  return(sumDistance/sumRides)
}
listDistancePerRide <- mapply(getDistancePerRide,regions_list)


#create a region dataframe

region_data_frame <- data.frame(c(1:length(regions_list)))
region_data_frame$region <- regions_list
region_data_frame$tipPerFare <- tipPerFare
region_data_frame$averageSpeed <- kmpHRegion
region_data_frame$distancePerRide <- listDistancePerRide
#region_data_frame$passengerPerRide <- listPassengerPerRide

#coarse grain data - divide day in N intervals
N=12*10 #in 5 minutes intervals
intervals <- c(0:(N-1))
maxSecs <- 3600*24
intervals <- intervals/N
intervals <- intervals*maxSecs
intervalsp1 <- c(1:N)
intervalsp1 <- (intervalsp1/N)*maxSecs

getIntervalTrips <- function(secondLower,secondUpper)
{
  data <- data_erweitert[data_erweitert$pickup_time>=secondLower,]
  data <- data[data$pickup_time<=secondUpper,]
  
  return(nrow(data))
}

intervalsPerTrip <- mapply(getIntervalTrips,intervals,intervalsp1)

getIntervalTipPerFare <- function(secondLower,secondUpper)
{
  data <- data_erweitert[data_erweitert$pickup_time>=secondLower,]
  data <- data[data$pickup_time<=secondUpper,]
  tmp <- data$tip_amount/data$fare_amount
  mVal <- mean(tmp)
  return(mVal)
}

intervalsPerTrip <- mapply(getIntervalTrips,intervals,intervalsp1)
intervalsTipPerFare <- mapply(getIntervalTipPerFare,intervals,intervalsp1)



waveletData  <- data.frame(c(1:length(intervals)))
waveletData$interval <- intervals/3600
waveletData$noTrips <- intervalsPerTrip
waveletData$tipPerFare <- intervalsTipPerFare

par(mar=c(1,1,1,1))
plot((intervalsPerTrip))

#doing some wavelet analysis

library(WaveletComp)

my.data = data.frame(x = waveletData$noTrips)
my.w = analyze.wavelet(my.data, "x",
                       loess.span = 0,
                       dt = 1, dj = 1/64,
                       lowerPeriod = 16,
                       upperPeriod = 64,
                       make.pval = T, n.sim = 10)

wt.image(my.w, color.key = "quantile", n.levels = 100) #,
        # legend.params = list(lab = "wavelet power levels", mar = 0.0))

#plot using ggplot

library(ggplot2)
warnings()
bp <- ggplot(region_data_frame,aes(x=reorder(region,as.numeric(tipPerFare)),y=as.numeric(tipPerFare)))+geom_point(colour = "red", size = 10)
bp <- bp + scale_x_discrete(name="borough") +scale_y_continuous(name="Tip per Dollar Fare [$]")
bp + theme(text = element_text(size=20))
ggsave("TipPerDollarFare.png", width = 80, height = 20, units = "cm")

bp <- ggplot(region_data_frame,aes(x=reorder(region,as.numeric(kmpHRegion)),y=as.numeric(kmpHRegion)))+geom_point(colour = "red", size = 10)
bp <- bp + scale_x_discrete(name="borough") +scale_y_continuous(name="Average Speed [miles/h]")
bp + theme(text = element_text(size=20))
ggsave("AverageSpeed_Taxi.png", width = 80, height = 20, units = "cm")

#with vertical lines at 6:00,12:00,18:00
bp <- ggplot(waveletData,aes(x=waveletData$interval,y=as.numeric(noTrips)))+geom_line(colour = "blue", size = 3)
bp <- bp + geom_vline(xintercept = c(6,12,18))
bp <- bp + scale_x_discrete(name="time interval") +scale_y_continuous(name="Number of rides []")
bp + theme(text = element_text(size=20))
ggsave("NumberOfRidesPerInterval_Taxi.png", width = 80, height = 20, units = "cm")

#also for farepertrip
bp <- ggplot(waveletData,aes(x=waveletData$interval,y=as.numeric(tipPerFare)))+geom_line(colour = "blue", size = 3)
bp <- bp + geom_vline(xintercept = c(6,12,18))
bp <- bp + scale_x_discrete(name="time interval") +scale_y_continuous(name="Tip per Dollar Fare [$]")
bp + theme(text = element_text(size=20))
ggsave("TipPerFare_Taxi.png", width = 80, height = 20, units = "cm")

#do a wavelet

my.data = data.frame(x = waveletData$tipPerFare)
my.w = analyze.wavelet(my.data, "x",
                       loess.span = 0,
                       dt = 1, dj = 1/40,
                       lowerPeriod = 5,
                       upperPeriod = 40,
                       make.pval = T, n.sim = 10)

wt.image(my.w, color.key = "quantile", n.levels = 500)#,xlab="time of day",ylab="wavelet width") 

library(wavelets)
#k <- c(4,6,10,12,8,6,5,5)
w <- dwt(waveletData$tipPerFare, filter="d4",n.levels=6,boundary="periodic")
figure108.wt.filter(w@filter, level = 0, l = NULL, wavelet = TRUE)
#plot(w)
plot(w, levels = NULL, draw.boundary = FALSE, type = "stack",
     col.plot = "blue", col.boundary = "red", X.xtick.at = NULL, X.ytick.at
     = NULL, Stack.xtick.at = NULL, Stack.ytick.at = NULL, X.xlab = "interval",
     y.rlabs = TRUE, plot.X = TRUE, plot.W = TRUE, plot.V = FALSE)

filter <- w.filter
figure108.wt.filter(filter)
figure108.wt.filter(list("haar", "d4", "d6"))
figure108.wt.filter(list("haar", "d4", "d6"), wavelet = FALSE)
# getMeanTipPerFareTwoREgions <- function(regionname1,regionname2)
# {
#   onePdata <- data_erweitert[data_erweitert$list_dropoff_region==regionname1,]
#   onePdata <- onePdata[onePdata$list_dropoff_region==regionname2,]
#   tmp <- onePdata$tip_amount/onePdata$fare_amount
#   mVal <- mean(tmp)
#   return(mVal)
# }
# 
# #get the data for two regions
# 
# regionRegionList <- {}
# for(region1 in regions_list)
# {
#   for(region2 in regions_list)
#   {
#     item=rbind(c(region1,region2))
#     regionRegionList <- cbind(regionRegionList,item)
#     meanTipList <- cbind(meanTipList,getMeanTipPerFareTwoREgions(region1,region2))
# }}
#text(x = seq(1, length(regions_list), by=1), par("usr")[3] - .5, labels = lablist.x, srt = 45, pos = 1, xpd = TRUE)
#par("usr")[3] - 0.5

#regionData <- data.frame(cbind(as.vector(regionSorted),as.vector(kmpHSorted)))
#library(ggplot2)
#p <- ggplot(regionData,aes(x=as.numeric(X1),y=as.numeric(X2)))
#p + geom_point()


months <- unique(data$pickup_date)


X1 <- c(.2,-.4,-.6,-.5,-.8,-.4,-.9,0,-.2,.1,-.1,.1,.7,.9,0,.3)
X2 <- c(.2,-.4,-.6,-.5,-.8,-.4,-.9,0,-.2,.1,-.1,.1,-.7,.9,0,.3)
# compute the LA8 wavelet filter for both DWT and MODWT
la8.dwt <- wt.filter()
la8.modwt <- wt.filter(modwt=TRUE)
# compute the DWT and MODWT level one wavelet and scaling coefficients
wt.dwt <- dwt.forward(X1, la8.dwt)
wt.modwt <- modwt.forward(X2, la8.modwt, 1)
# compute the original series with the level one coefficients
newX.dwt <- dwt.backward(wt.dwt$W, wt.dwt$V, la8.dwt)
newX.modwt <- modwt.backward(wt.modwt$W, wt.modwt$V, la8.modwt, 1)

