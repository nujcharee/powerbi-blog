library(osmdata) ## step 1 - load OSMData library (assuming that its already installed)
getbb ("Harrogate North Yorkshire") ## step 2 - set boundary box

## step 3 - build a query string to pass over to Overpass API
## key - look this up from openstreetmap wiki or check out overpass turbo for web 
## interface http://overpass-turbo.eu 

q <- opq ("Harrogate North Yorkshire") %>% 
    add_osm_feature(key = "amenity", value = "restaurant") %>% 
    osmdata_sf()


osm_points = q$osm_points
x = as.data.frame(q$osm_points) # load osm_points data frame into Power Query


# geo-coding --------------------------------------------------------------
library(sf)

g = osm_points$geometry
a = as.data.frame(st_coordinates(g))
dataset = cbind(as.data.frame(osm_points$name), a)
dataset = dataset %>% mutate(id = row_number()) %>% rename(lon = X, lat = Y)

# OSRM --------------------------------------------------------------------

library(osrm) #load library

# Travel time matrix in small cut of data 
# comparing rows 1-5 with rows 6-10

distA2 <- osrmTable(src = dataset[1:5,c("id","lon","lat")], 
                    dst = dataset[5:10,c("id","lon","lat")])

#the above object is in matrix, so the below changes it to data.table for PowerBI

y = as.data.frame(as.table(distA2$durations))


