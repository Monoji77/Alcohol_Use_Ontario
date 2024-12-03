#### Preamble ####
# Purpose: Map out health regions from daataset
# Author: Chris Yong Hong Sen 
# Date: 02 December 2024
# Contact:luke.yong@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 
# - The `tidyverse` package must be installed and loaded
# - The `tmap` and `sf` package must be installed and loaded
# - 03-clean_data.R must have been run
# - Knowledge about linear regression models, assumptions about sampling distribution

library(sf)
library(tmap)
library(tidyverse)
health_region_shp <- st_read(
  "../data/03-map_data/Health Regions Ontario Shapes/HR_035a18a_e.shp",
  quiet = T)

# tm_shape(canada_shp) +
#   tm_borders() +
tmap_mode('plot')

HR_UID_top <- tibble(HU_ID = top_5_regions) |>
  mutate(health_region = case_when(
    HU_ID == 35951 ~ 'City of Ottawa Health Unit',
    HU_ID == 35953 ~ 'Peel Regional Health Unit',
    HU_ID == 35960 ~ 'Simcoe Muskoka District Health Unit',
    HU_ID == 35970 ~ 'York Regional Health Unit',
    HU_ID == 35995 ~ 'City of Toronto Health Unit'
  ))

HR_UID_btm <- tibble(HU_ID = bottom_5_regions) |>
  mutate(health_region = case_when(
    HU_ID == 35931 ~ 'Elgin-St Thomas Health Unit',
    HU_ID == 35935 ~ 'Haliburton, Kawartha, Pine Ridge District ',
    HU_ID == 35940 ~ 'Chatham-Kent Health Unit',
    HU_ID == 35942 ~ 'Lambton Health Unit',
    HU_ID == 35956 ~ 'Porcupine Health Unit'
  ))



HR_UID_top <- paste0(substr(top_5_regions, 1, 2), substr(top_5_regions, 4, 5))

HR_UID_btm <- paste0(substr(bottom_5_regions, 1, 2), substr(bottom_5_regions, 4, 5))

top_health_regions_shp <- health_region_shp |>
  filter(HR_UID %in% HR_UID_top)

btm_health_regions_shp <- health_region_shp |>
  filter(HR_UID %in% HR_UID_btm)


health_region_map <- tm_basemap('CartoDB.Positron') +
  tm_shape(health_region_shp) +
  tm_borders(colour = 'ENGNAME',
             legend.show = F,
             popup.vars = c('Name: '='ENGNAME'),
             id = 'ENGNAME') +
  tm_shape(top_health_regions_shp) +
  tm_polygons(fill='indianred4',
              fill_alpha = 0.5) +
  tm_shape(btm_health_regions_shp) +
  tm_polygons(fill='skyblue1',
              fill_alpha = 0.5) +
  tm_add_legend(
    type = 'polygons',
    labels = c('Top 5 health regions', 'Bottom 5 health regions'),
    fill = c('indianred4', 'skyblue1'),
    border.col = 'white') +
  tm_layout(frame=FALSE) 

health_region_map
# save the printed map
#tmap_save(health_region_map, "other/map/health_region_map.html")
