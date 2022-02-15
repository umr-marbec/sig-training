# ---
# jupyter:
#   jupytext:
#     formats: ipynb,R:light
#     text_representation:
#       extension: .R
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.13.6
#   kernelspec:
#     display_name: R
#     language: R
#     name: ir
# ---

# # SIG training
#
# Date: 12/02/2022
#
# Speakers: David Kaplan & Laure Velez
#
# ## Introduction
#
# Package `sf` for `Simple Features`, a standard for SIG, shared with other SIG tools
#
# Acronyms to know:
#
# - WKT = Well Known Text
# - WKB = Well Known Binaries
# - SRID: spatial reference ID.
#
# SF does not work with raster files.
#
# ## QGIS
#
# First some vocabulary on SIG
#
# - Layer: One element of the map. A project is made of several layers
# - Feature: One layer is composed of features (points, polygons, etc.)
# - Attributes: Metadata associated with the feature. 
# - Fields: List of attributes. 
#
# Note: Attribute tables of dimensions (nFeature, nAttributes). Each line of the attribute table corresponds to a feature
#
# To add layers in QGIS
#
# ```
# Layer > Add Layer
# ```
#
# To open attribute table
#
# ```
# Layer > Open Table Attribute
# ```
#
# To use mainly for first inspection
#
# ## R
#
# ### Read in shapefile

library(sf)
gadm0 = st_read("shapefiles/gadm36_ZAF_0.shp")
gadm0

# 1 geographic object (i.e feature) of type `MULTIPOLYGON` and 2 fields.  

class(gadm0)

names(gadm0)

# Here we see two fields, and the geometric information associated with the feature

class(gadm0$geometry)

# To recover the geometric part of the shapefile:

st_geometry(gadm0)

# **Notes**: most of commands associated with `sf` start with *sf_* 

# ### Plotting

plot(gadm0)

# Here, each color will be associated with a value for the attributes. In our case, we only have one feature, hence one color.

plot(st_geometry(gadm0), col="red", lwd=5)

# Here, we extract only the spatial information, hence no coloring depending on attribute's values. Then we call the plot settings to change colors and linewidth.
#
# Now we explore other shapefiles

gadm1 = st_read("shapefiles//gadm36_ZAF_1.shp")
gadm2 = st_read("shapefiles//gadm36_ZAF_2.shp")
gadm3 = st_read("shapefiles//gadm36_ZAF_3.shp")
gadm4 = st_read("shapefiles//gadm36_ZAF_4.shp")

gadm3

plot(gadm3, max.plot=5)

plot(st_geometry(gadm3))

# To extract a specific column, keeping geometric information:

gadm3["NAME_2"]

# **Note that this is different for standard dataframes.** And this is different from:

gadm3$NAME_2

plot(gadm3["NAME_2"])

# ## Better plots using `tmap`
#
# Bettter plots, but slower. Works a bit like `ggplot2`

# +
library("tmap")
library("htmlwidgets")
library("IRdisplay")

tm_shape(gadm3) + tm_polygons(col="NAME_1")
# -

# In `ggplot2`, you can store plot outputs in a variable and then make some operations on it.

bm = tm_shape(gadm3) + tm_polygons(col="NAME_1", title="Province")
bm = bm + tm_legend(outside=TRUE, outside.position="right") + tm_compass() + tm_grid()
bm

# - `tm_shape`: defines the object that you use
# - `tm_polygons`: specify which geographical figure you draw.

# To create an interactive map, use the `tmap_leaflet` function:

lf = tmap_leaflet(bm)

# The lines below are made just required to embed the leaflet into the Notebook (not used when running in Rstudio).

saveWidget(lf, 'demo.html')
display_html('<iframe src="demo.html"></iframe>')

bm = tm_shape(gadm3) + tm_polygons(col="NAME_1", title="Province", popup.vars=c("NAME_0", "NAME_1", "NAME_2", "NAME_3"))
lf = tmap_leaflet(bm)

saveWidget(lf, 'demo1.html')
display_html('<iframe src="demo1.html"></iframe>')

# ## Loading rasters
#
# `sf` does not work with rasters. The `raster` library should be used instead.

library("raster")
bath = raster("shapefiles/bathymetry.tif")
bath

# We can plot as raster as follows:

plot(bath)

# It is better to use `tmap` library to draw the raster. It can be superimposed with other shapefiles:

tm_shape(bath) + tm_raster(style="cont") + tm_shape(gadm0) + tm_polygons()

# Here, `cont` allows to specify that we use a continous colortable. By default, a discrete colorbar is used, whose discrete levels is controlled by `breaks`

tm_shape(bath) + tm_raster(breaks=seq(-6000, 6000, 1000)) + tm_shape(gadm0) + tm_polygons()

# In order to remove continents but keeping coastlines:

tm_shape(bath) + tm_raster(style="cont") + tm_shape(gadm0) + tm_polygons(border.col='black', alpha=0, lwd=5)

# Same as: 

tm_shape(bath) + tm_raster(style="cont") + tm_shape(gadm0) + tm_borders(col='black', lwd=5)

# **Note**: In `tmap`, col or lwd can be either fixed or depend on a column attribute. By default, `tmap` takes the fist layer to define the figure bounding box. This can be changed by using the `is.master` option. It is also possible to define a bounding box using the `bbox` argument.

tm_shape(bath) + tm_raster(style="cont") + tm_shape(gadm0, is.master=TRUE) + tm_borders(col='black', lwd=5)

# ## Working using database
#

# For a database, we need to provide an additional argument, which is the name of the layer that we want.

sites = st_read("data/gannet_stomach_data_for_class.sqlite", "sites")

# `Sqlite` has an extension which uses the `Simple Features` standard, which is `SpatialLite`.
#
# To add the sites to the map, we use the `tm_symbols` method.

bm = tm_shape(gadm3) + tm_polygons(col="NAME_1", title="Province", popup.vars=c("NAME_0", "NAME_1", "NAME_2", "NAME_3"))
bm2 = bm + tm_legend(outside=TRUE, outside.position='right') + tm_compass() + tm_grid()
bm2 + tm_shape(sites) + tm_symbols(col='site', title.col='Study sites', border.col = 'black', border.lwd = 2)

# ## Data analysis
#
# So far, we have mainly used functions to visualize data. Now we will process that. For each station, we will extract some informations, such as topography, population, and so on.
#
# ### Step 1
#
# First, we add population data to `gadm1`. First, we execute David's file defining SA population by province

source("data//pop.R")
population

# We need to merge the dataframes. The `merge` method takes the `by.x` argument, which allows to specify the columns of argument `x`, and `by.y`, which specifies the argument to use in `y` for the merging. Province in `x` is specified by `NAME_1`, in `y` it is provided by `province`:

merged = merge(gadm1, population, by.x="NAME_1", by.y='province')
merged

# Now we make the plot of map by population.

tm_shape(merged) + tm_polygons(col="population")

# ### Step 2
#
# Now we want to join sites with provinces. In this case, `merge` method cannot be used. We must use `st_join`.

test = st_join(x=sites, y=merged, left=TRUE)
test

# ### Step 3
#
# We want to do the same thing for the bathymetry. But `st_join` does not work with raster. So we need to use `extract` method of the `raster` package.
#
# Note: it used to work only with `sp`, not `sf`. To convert from `sf` to `sp`, use `as_Spatial` method.

test2 = extract(bath, test)
test2

# Here, we see that 5 sites are not in the raster. We need to check that carefully. 

# Finally, we need to add these values to the merged dataframe.

test$bat = test2
test

# ## Saving results
#
# Several output formats can be used. Shapefiles, Google Earth files, etc, but also R formats. Better use the former.
#
# First, we create a results folder

dir.create("results")

# ### Writting shapefile

st_write(test, "results/sites_pop.shp")

# ### Writting database
#
# First, we copy the original database.

file.copy("data//gannet_stomach_data_for_class.sqlite", "results/gannet_stomach_data_for_class.sqlite")

# As before, we need to specify the new layer:

st_write(test, "results/gannet_stomach_data_for_class.sqlite", "sites_pop", delete_layer = TRUE)

# To check that the layer is ok:

st_layers("results/gannet_stomach_data_for_class.sqlite")

# ### Writting KML
#
# Same as before, except that we must specify the driver.

st_write(test, "results/sites_pop.kml", layer="sites_pop", driver="LIBKML", append=TRUE)

# **Note**: accessible drivers are accessible by:

st_drivers()

# ### Leaflet package
#
# `tmap_leaflet` works in many case, but some loss of information. Better to use `leaflet` package direcly. First, we create a `volcanoes` object using David's script

source("shapefiles//volcanoes_layer.R")
volcanoes

# Using `tmap_leaflet`, it does not work since the link is not clickable.

library("leaflet")

lf = leaflet(volcanoes)
lf = addTiles(lf)
lf = addMarkers(lf)

# It is usually written using pipes. Note: in R > 4.1, should use `|>`. In old R versions, use `%>%`

lf = volcanoes %>% leaflet() %>% addTiles() %>% addMarkers()

# To change map:

lf %>% addProviderTiles(providers$OpenTopoMap)
lf

# To list all providers:

names(providers)

saveWidget(lf, 'demo3.html')
display_html('<iframe src="demo3.html"></iframe>')

# Improving marks:

# +
pal = colorNumeric("YlOrRd",volcanoes$altitude)

lf = volcanoes %>% leaflet() %>% addTiles() %>% 
  addCircleMarkers(stroke=FALSE,color=~pal(altitude),fillOpacity=1)

saveWidget(lf, 'demo4.html')
display_html('<iframe src="demo4.html"></iframe>')
# -

# Adding legend:

# +
pal = colorNumeric("YlOrRd",volcanoes$altitude)

lf = volcanoes %>% leaflet() %>% addTiles() %>% 
  addCircleMarkers(stroke=FALSE,color=~pal(altitude),fillOpacity=1) %>% 
  addLegend(title="Altitude (m)",pal=pal,values=volcanoes$altitude,
            opacity=1)

saveWidget(lf, 'demo5.html')
display_html('<iframe src="demo5.html"></iframe>')
# -

# Layer controls:

# +
pal = colorNumeric("YlOrRd",volcanoes$altitude)

lf = volcanoes %>% leaflet() %>% addTiles(group="OSM") %>% addProviderTiles(providers$OpenTopoMap,group="OTM") %>%
  addCircleMarkers(stroke=FALSE,color=~pal(altitude),fillOpacity=1,
                   group="Volcanoes") %>% 
  addLegend(title="Altitude (m)",pal=pal,values=volcanoes$altitude,
            opacity=1,group="Volcanoes") %>%
  addLayersControl(position="topleft",
                   baseGroups = c("OSM","OTM"),
                   overlayGroups = c("Volcanoes"))

saveWidget(lf, 'demo6.html')
display_html('<iframe src="demo6.html"></iframe>')
# -

# For popups:

library(htmltools)
volcanoes$popup = 
  paste0(htmlEscape(volcanoes$name),'<br/>',
         volcanoes$altitude,' m<br/>',
         '<a href="',volcanoes$wikipedia,'">Wikipedia</a>') %>%
  lapply(HTML) # Forces recognition as HTML

head(volcanoes$popup)

# +
pal = colorNumeric("YlOrRd",volcanoes$altitude)

lf = volcanoes %>% leaflet() %>% addTiles(group="OSM") %>%
  addProviderTiles(providers$OpenTopoMap,group="OTM") %>%
  addCircleMarkers(stroke=FALSE,color=~pal(altitude),fillOpacity=1,
                   group="Volcanoes",popup=~popup,label=~name) %>% 
  addLegend(title="Altitude (m)",pal=pal,values=volcanoes$altitude,
            opacity=1,group="Volcanoes") %>%
  addLayersControl(position="topleft",
                   baseGroups = c("OSM","OTM"),
                   overlayGroups = c("Volcanoes"))

saveWidget(lf, 'demo7.html')
display_html('<iframe src="demo7.html"></iframe>')