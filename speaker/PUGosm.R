library(osmdata) ## step 1 - load OSMData library (assuming that its already installed)
getbb ("Harrogate North Yorkshire") ## step 2 - set boundary box

## step 3 - build a query string to pass over to Overpass API
## key - look this up from openstreetmap wiki or check out overpass turbo for web 
## interface http://overpass-turbo.eu 
 
q <- opq ("Harrogate North Yorkshire") %>% 
  	add_osm_feature(key = "amenity", value = "restaurant") %>% 
osmdata_sf()

x = as.data.frame(q$osm_points) # load osm_points data frame into Power Query


