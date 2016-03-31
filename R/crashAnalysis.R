data <- read.table(file="/home/kos/Code/kos/dataMining/nycData/crash.csv",sep = ",", header = TRUE)

data <- na.omit(data)
#data <- data[data$latitude==0,]

# now add the month and year by splitting the date info

splitItYear <- function(inputString)
{
  splitted <- strsplit(as.character(inputString),"T")[[1]]
  year <- strsplit(as.character(splitted),"-")[[1]]
  #month <- strsplit(as.character(splitted),"-")[0]
  
  return(year[[1]])
}

yearlist=mapply(splitItYear,data[,2])

splitItMonth <- function(inputString)
{
  splitted <- strsplit(as.character(inputString),"T")[[1]]
  month <- strsplit(as.character(splitted),"-")[[1]]
  return(month[[2]])
}

data_erweitert <- cbind(data,yearlist)
monthlist=mapply(splitItMonth,data[,2])
data_erweitert <- cbind(data_erweitert,monthlist)



upper_east_lat=40.771308
upper_east_lon= -73.959537
upper_west_lat=40.785263
upper_west_lon=  -73.976240
regions_list=c("Upper East Side","Upper West Side","Harlem",
               "Hells Kitchen","East Village","Tribeca",
               "Downtown","Little Italy",
               "Greenwich Village","Chelsea","Midtown",
               "Washington Heights","Bronx","Brooklyn","Queens")
regions_lat=c(upper_east_lat,upper_west_lat,40.809844,40.763260,
              40.727240,40.715910,40.709650,
              40.719050,40.733313,40.747391,40.755482,40.842172,40.820159,40.692272,40.752413)
regions_long=c(upper_east_lon,upper_west_lon, -73.946402,-73.992351,
               -73.982070,-74.009129,-74.011642, 
               -73.997206,-74.002988,-74.001412,-73.983629,
               -73.939661,-73.918615, -73.960356,-73.938089)
getmindist <- function(lat,lon,lat2,lon2)
{
  return(abs(lat-lat2)+abs(lon-lon2))
}

getNameOfRegion <- function(longitude,latitude)
{
  mindist<-1000000
  regionName<-""
  for(i in 1:length(regions_list)){
    val <- getmindist(latitude,longitude,regions_lat[i],regions_long[i])
   # print(val)
    if(val<mindist)
    {
      regionName<-regions_list[i]
      mindist <- val
    }
  }
  return(regionName)
}


list_regions <- mapply(getNameOfRegion,data$longitude,data$latitude)
data_erweitert <- cbind(data_erweitert,list_regions)

getLengthOfInput <- function(inputRegionName)
{
  dataset <- data_erweitert[data_erweitert$list_regions==inputRegionName,]
  return(length(dataset$list_regions))
}

#create dataframe with region data

#region_data_frame=data.frame()
region_data_frame <- data.frame(regions_list)
#now get the number of crashes for every region
no_crashes <- mapply(getLengthOfInput,regions_list)
#region_data_frame <- cbind(region_data_frame,no_crashes)

region_data_frame$no_crashes <- no_crashes
# getPedestrianDeath <- function(inputRegionName)
# {
#   sum=0
#   dataset <- data_erweitert[data_erweitert$list_regions==inputRegionName,]
#   for(i in seq(dataset$number_of_pedestrians_killed))
# {
# #print(sum)
# sum=sum+as.numeric(dataset$number_of_pedestrians_killed[[i]])
# }
#   return(sum)
# }
# 
# no_pedestrians_killed <- mapply(getPedestrianDeath,regions_list)
# region_data_frame <- cbind(region_data_frame,no_pedestrians_killed)
# 
# getPedestrianInjured <- function(inputRegionName)
# {
#   sum=0
#   dataset <- data_erweitert[data_erweitert$list_regions==inputRegionName,]
#   for(i in seq(dataset$number_of_pedestrians_injured))
#   {
#     #print(sum)
#     sum=sum+as.numeric(dataset$number_of_pedestrians_injured[[i]])
#   }
#   return(sum)
# }
# 
# no_pedestrians_injured <- mapply(getPedestrianInjured,regions_list)
# region_data_frame <- cbind(region_data_frame,no_pedestrians_injured)
# 
# 
# getPersonInjured <- function(inputRegionName)
# {
#   sum=0
#   dataset <- data_erweitert[data_erweitert$list_regions==inputRegionName,]
#   for(i in seq(dataset$number_of_persons_injured))
#   {
#     #print(sum)
#     sum=sum+as.numeric(dataset$number_of_persons_injured[[i]])
#   }
#   return(sum)
# }
# 
# number_of_persons_injured <- mapply(getPersonInjured,regions_list)
# region_data_frame <- cbind(region_data_frame,number_of_persons_injured)

getSumList <- function(inputRegionName,columnIndex)
{
  sum=0
  dataset <- data_erweitert[data_erweitert$list_regions==inputRegionName,]
  #print(nrow(dataset))
  for(i in 1:nrow(dataset))
  {
    #print(sum)
    sum=sum+as.numeric(dataset[,columnIndex][i])
  }
  return(sum)
}


# 1"unique_key",
#2"date",
#3 "time",
#4 "latitude",
#5 "longitude",
#6 "number_of_persons_injured",
#7 "number_of_persons_killed",
#8 "number_of_pedestrians_killed",
#9"number_of_pedestrians_injured",
#10"number_of_cyclist_injured",
#11"number_of_cyclist_killed",
#12"number_of_motorist_injured",
#13"number_of_motorist_killed",
#14"contributing_factor_vehicle_1"

# "number_of_persons_injured "-- index 6
list_no_persons_killed <- mapply(getSumList,regions_list,7)
region_data_frame <- cbind(region_data_frame,list_no_persons_killed)
list_no_persons_injured <- mapply(getSumList,regions_list,6)
region_data_frame <- cbind(region_data_frame,list_no_persons_injured)
list_no_pedestrians_injured <- mapply(getSumList,regions_list,9)
region_data_frame <- cbind(region_data_frame,list_no_persons_injured)
list_no_pedestrians_killed <- mapply(getSumList,regions_list,8)
region_data_frame <- cbind(region_data_frame,list_no_pedestrians_killed)
list_no_cyclist_injured <- mapply(getSumList,regions_list,10)
region_data_frame <- cbind(region_data_frame,list_no_cyclist_injured)
list_no_cyclist_killed <- mapply(getSumList,regions_list,11)
region_data_frame <- cbind(region_data_frame,list_no_cyclist_killed)
list_no_motorist_injured <- mapply(getSumList,regions_list,12)
region_data_frame <- cbind(region_data_frame,list_no_motorist_injured)
list_no_motorist_killed <- mapply(getSumList,regions_list,13)
region_data_frame <- cbind(region_data_frame,list_no_motorist_killed)

library(ggplot2)


bp <- ggplot(region_data_frame,aes(x=reorder(regions_list,list_no_persons_killed/no_crashes),y=list_no_persons_killed/no_crashes*100))+
  geom_point(colour = "red", size = 10)
bp <- bp + scale_x_discrete(name="borough") +scale_y_continuous(name="probability of being killed when involved in an accident [%]")
bp + theme(text = element_text(size=20))
ggsave("PkilledWhenAccident.png", width = 80, height = 20, units = "cm")

bp2 <- ggplot(region_data_frame,aes(x=reorder(regions_list,list_no_pedestrians_injured/no_crashes),y=list_no_pedestrians_injured/no_crashes*100))+
  geom_point(colour = "red", size = 10)
bp2 <- bp2 + scale_x_discrete(name="borough") +scale_y_continuous(name="likelyhood of pedestrians injured in accident [%]")
bp2 + theme(text = element_text(size=20))
ggsave("PPedestriansInjuredWhenAccident.png", width = 80, height = 20, units = "cm")

bp3 <- ggplot(region_data_frame,aes(x=reorder(regions_list,no_crashes),y=no_crashes))+
  geom_point(colour = "red", size = 10)
bp3 <- bp3 + scale_x_discrete(name="borough") +scale_y_continuous(name="number of accidents")
bp3 + theme(text = element_text(size=20))
ggsave("Noaccidents.png", width = 80, height = 20, units = "cm")

bp4 <- ggplot(region_data_frame,aes(x=reorder(regions_list,list_no_persons_injured/no_crashes),y=list_no_persons_injured/no_crashes*100))+
  geom_point(colour = "red", size = 10)
bp4 <- bp4 + scale_x_discrete(name="borough") +scale_y_continuous(name="probability of being injured when involved in an accident [%]")
bp4 + theme(text = element_text(size=20))
ggsave("PinjuredWhenAccident.png", width = 80, height = 20, units = "cm")

#deadly accidents per month
data_killed <- data_erweitert[data_erweitert$number_of_persons_killed>0,]
#qplot(data_killed$monthlist, geom="histogram")
ggplot(data=data_killed, aes((data_killed$monthlist)),stat=count) + geom_bar()

data_injured2013 <- data_erweitert[data_erweitert$number_of_persons_injured>0 & yearlist==2013,]
data_injured2014 <- data_erweitert[data_erweitert$number_of_persons_injured>0 & yearlist==2014,]
histo <- ggplot(data=data_injured2013, aes((data_injured2013$monthlist)),stat=count) #,legendPosition="top",legendTitle="Groups") 
histo <- histo + geom_bar(fill = "red", alpha = 0.2) 
histo <- histo + geom_bar(data=data_injured2014, aes((data_injured2014$monthlist)),fill = "green", alpha = 0.2)
histo <- histo + scale_x_discrete(name="month")
histo <- histo + scale_y_continuous(name="number of accidents") 
#histo <- histo + scale_fill_discrete(labels=c("trt1","ctrl"),values=c("trt1","ctrl"))
histo <- histo + scale_colour_manual(labels=c("red","green"),values=c("trt1","ctrl"))
histo <- histo + guides(fill=guide_legend(labels=c("trt1","ctrl")))
histo
  #  guides(fill=guide_legend(title=NULL))
#  scale_colour_manual(name="group", values=c("r" = "red", "b"="blue"), labels=c("b"="blue values", "r"="red values")) +
  #scale_fill_manual(name="group", values=c("r" = "red", "b"="blue"), labels=c("b"="blue values", "r"="red values"))
#ggplot(histogram,aes(x=monthlist),stat=count) + 
#  geom_histogram(data=data_injured2013,aes(data_injured2013$monthlist),stat=count,fill = "red", alpha = 0.2) +
#geom_histogram(data=data_injured2014,aes(data_injured2014$monthlist),stat=count,fill = "green", alpha = 0.2) 
#
#



