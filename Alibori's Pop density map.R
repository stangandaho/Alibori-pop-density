#loadin necessaries pacakeges
library(raster)
library(sf)
library(tidyverse)
library(showtext)
library(ggtext)
alibori_raster <- raster("./Alibori/Alibori.tif")
alibori_shp <- st_read(dsn = "./Alibori",layer = "Alibori")
alibori_shp <- st_transform(x = alibori_shp, crs = proj4string(alibori_raster))
# 
# Plotting
alibori_df <- raster::as.data.frame(alibori_raster, xy = TRUE) |> 
  na.omit() |> 
  rename("value" = Alibori)
head(alibori_df, 3)
# Ploting
# Add fonts to session
source("fonts.R")

ggplot()+
   geom_raster(data = alibori_df, aes(x = x, y = y, fill = value))+
   #coord_sf()+
   scale_fill_gradient(low = "#e5e4e0", high = "#d00021",
                       breaks = c(0, 175, 350, 525, 700, 875, 1050, 1225, 1400))+
   geom_sf(data = alibori_shp, aes(geometry=geometry), 
           fill = "#FFFFFF63", color = "#0e0836", size = 2)+
   geom_sf_label(data = alibori_shp, aes(label = NAME_2),
                 label.r = unit(0.5, units = "lines"), label.size = 0.3, fill = "NA", color = "#490058", family = "Comic Sans MS", size = 6)+
   geom_text(aes(x = 3.5, y=12.31, label = "Alibori"), family = "Comic Sans MS", color = "#e5b7b4", size = 12)+
   geom_text(aes(x = 3.5, y=12.33, label = "Alibori"), family = "Comic Sans MS", color = "white", size = 12)+
   geom_text(aes(x = 3.60, y=12.15, label = "Benin's department"), family = "Tw Cen MT", color = "white", size = 6)+
   guides(fill = guide_colorbar(barwidth = unit(0.6, "lines"),
                                barheight = unit(8, "lines")))+
   labs(title = str_wrap(source("data_description.R")), 
        x = "Longitude", y = "Latitude", fill = "People/Km²",
        caption = "by Stanislas Mahussi GANDAHO \nData source: WorldPop - www.worldpop.org")+
   theme(
      
      plot.title.position = "plot",
      plot.title = element_text(size = 14, color = "white", family = "Tw Cen MT", hjust = 0.5, margin = margin(b = 30)),
      
      plot.background = element_rect(fill = "#0e0836", colour ="NA" ),
      panel.background = element_rect(fill = "#0e0836", colour ="#FFFFFF63" ),
      panel.grid = element_blank(),
      
      legend.background = element_rect(fill = "#0e0836", colour ="NA"),
      legend.title = element_text(color = "#f7eace",
                                  family = "Adobe Devanagari", size = 16),
      legend.text = element_text(color = "#f7eace", family = "Adobe Devanagari", size = 14),
      
     axis.title = element_text(color = "#f7eace", size = 18, family = "Adobe Devanagari"),
        axis.text = element_text(color = "#f7eace", size = 16, family = "Adobe Devanagari"),
     
     plot.caption = element_text(color = "gray60", family = "Elephan",
                                 size = 12, hjust = 1),
     plot.caption.position = "plot"
   )
ggsave("Alibori.png", dpi = 300, width = 21, height = 25, units = "cm")
