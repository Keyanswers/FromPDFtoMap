---
title: "From Raster to Distance Raster in R"
author: "Juan Carlos Rubio Polania, PhD"
date: "2024-05-11"
---

# From Raster to Distance Raster in R 🌍📏

## Overview

This repository presents a general workflow for transforming a categorical raster into a distance raster using R.

Although rivers are used as the example feature in this project, the methodology can be applied to many other spatial datasets, including:
- Roads
- Forest patches
- Urban areas
- Coral reefs
- Mangroves
- Habitat layers
- Species occurrence rasters
- Water bodies
- Environmental variables

The workflow demonstrates how to:
- Load raster data
- Convert rasters into binary/categorical layers
- Reproject rasters into a metric coordinate reference system
- Generate distance rasters
- Extract raster distance values for points
- Identify nearest spatial features

Distance rasters are widely used in:
- GIS workflows
- Ecological modeling
- Spatial analysis
- Species distribution models
- Environmental monitoring
- Remote sensing

---

# Required Packages

```r
library(terra)
library(sf)
library(dplyr)
```

---

# Example Workflow

## Load Raster

```r
rivers <- rast("NorthRiversTest.tif")
```

---

## Convert Raster into a Binary Layer

```r
rivers[rivers == 0] <- NA
rivers[!is.na(rivers)] <- 1
```

### Interpretation

| Value | Meaning |
|---|---|
| 1 | Target feature |
| NA | Background |

---

## Reproject Raster

```r
rivers_m <- project(rivers,
                    "EPSG:5070",
                    method = "near")
```

Distance calculations require a projected CRS in meters.

---

## Generate Distance Raster

```r
river_distance <- distance(rivers_m)
```

The resulting raster stores the distance from each cell to the nearest feature.

---

# Visualization

```r
plot(river_distance,
     main = "Distance Raster")

plot(rivers_m,
     add = TRUE,
     col = "blue",
     legend = FALSE)
```

---

# Save Raster

```r
writeRaster(river_distance,
            "RiverDistance.tif",
            overwrite = TRUE)
```

---

# Extract Distance Values

## Example Coordinates

```r
xy <- cbind(c(1000000, 1005000),
            c(500000, 505000))
```

## Extract Raster Values

```r
extract(river_distance, xy)
```

---

# Spatial Point Analysis

## Convert Table into sf Object

```r
points <- st_as_sf(values,
                   coords = c("x", "y"),
                   crs = 5070)
```

---

## Reproject Points

```r
points_wgs84 <- st_transform(points,
                             4326)
```

---

# Nearest Feature Analysis

## Merge Spatial Layers

```r
Rivers <- bind_rows(
  st_transform(Shf1, crs(Riv)) %>%
    select(name = PNAME),

  st_transform(Shf2, crs(Riv)) %>%
    select(name = NOMBRES)
)
```

---

## Extract Distance Values

```r
Dis <- terra::extract(Riv,
                      vect(points))

points$distance_m <- Dis[,2]
```

---

## Find Nearest Feature

```r
nearest_idx <- st_nearest_feature(points,
                                  Rivers)

points$nearest_feature <- Rivers$name[nearest_idx]
```

---

# Final Output

```r
print(points)
```

The final dataset contains:
- Point coordinates
- Distance to nearest feature
- Nearest feature name

---

# Applications

This workflow can be adapted for:
- Habitat suitability models
- Ecological studies
- Marine spatial analysis
- Hydrological analysis
- Environmental GIS workflows
- Remote sensing applications
- Infrastructure analysis

---

# Requirements

- R
- terra
- sf
- dplyr

---

# License

This project is licensed under the MIT License.

---

# Author

Juan Rubio
